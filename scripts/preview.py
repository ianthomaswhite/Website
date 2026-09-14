#!/usr/bin/env python3
"""
Simple local preview generator & web server.
Compiles pages, templates, and assets into _site/ and serves at http://localhost:8000.
Zero dependencies: runs using Python's standard library.
"""

import os
import re
import sys
import shutil
import http.server
import socketserver
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent.parent
SITE_DIR = ROOT_DIR / "_site"
TEMPLATES_DIR = ROOT_DIR / "templates" / "editorial"
PAGES_DIR = ROOT_DIR / "pages"
POSTS_DIR = ROOT_DIR / "posts"
CSS_DIR = ROOT_DIR / "css"
PDFS_DIR = ROOT_DIR / "pdfs"

def parse_frontmatter(content):
    """Extract YAML frontmatter and body."""
    metadata = {}
    body = content
    if content.startswith("---"):
        parts = content.split("---", 2)
        if len(parts) >= 3:
            fm_text = parts[1]
            body = parts[2]
            for line in fm_text.strip().splitlines():
                if ":" in line:
                    k, v = line.split(":", 1)
                    metadata[k.strip()] = v.strip().strip('"').strip("'")
    return metadata, body.strip()

def simple_markdown_to_html(md_text):
    """Convert common markdown features to HTML while preserving inline HTML."""
    lines = md_text.splitlines()
    html_lines = []
    in_code_block = False
    in_list = False

    for line in lines:
        stripped = line.strip()

        # Code block toggle
        if stripped.startswith("```"):
            if in_code_block:
                html_lines.append("</code></pre>")
                in_code_block = False
            else:
                lang = stripped[3:].strip()
                html_lines.append(f'<pre><code class="language-{lang}">' if lang else '<pre><code>')
                in_code_block = True
            continue

        if in_code_block:
            html_lines.append(line)
            continue

        # Unordered list items
        if stripped.startswith("- ") or stripped.startswith("* "):
            if not in_list:
                html_lines.append("<ul>")
                in_list = True
            item_content = stripped[2:].strip()
            item_content = inline_formatting(item_content)
            html_lines.append(f"<li>{item_content}</li>")
            continue
        elif in_list and not stripped:
            html_lines.append("</ul>")
            in_list = False
            continue
        elif in_list and not (stripped.startswith("- ") or stripped.startswith("* ")):
            html_lines.append("</ul>")
            in_list = False

        # Blank line
        if not stripped:
            html_lines.append("")
            continue

        # Headings
        if stripped.startswith("# "):
            html_lines.append(f"<h1>{inline_formatting(stripped[2:])}</h1>")
            continue
        elif stripped.startswith("## "):
            html_lines.append(f"<h2>{inline_formatting(stripped[3:])}</h2>")
            continue
        elif stripped.startswith("### "):
            html_lines.append(f"<h3>{inline_formatting(stripped[4:])}</h3>")
            continue
        elif stripped.startswith("#### "):
            html_lines.append(f"<h4>{inline_formatting(stripped[5:])}</h4>")
            continue
        elif stripped == "---":
            html_lines.append("<hr>")
            continue

        # Check if inside an existing HTML block (e.g. <div>, <p>, etc.)
        if stripped.startswith("<") and not stripped.startswith("<code>") and not stripped.startswith("<a"):
            if not stripped.endswith("/>") and not ("</" in stripped):
                # An opening tag like <div ...> or <p ...>
                pass

        # HTML passthrough or regular paragraph
        if stripped.startswith("<") or stripped.endswith(">") or stripped.startswith("<!--") or stripped.startswith("&"):
            html_lines.append(stripped)
        else:
            html_lines.append(f"<p>{inline_formatting(stripped)}</p>")

    if in_list:
        html_lines.append("</ul>")
    if in_code_block:
        html_lines.append("</code></pre>")

    return "\n".join(html_lines)

def inline_formatting(text):
    """Handle bold, italic, code, and links."""
    # Inline code
    text = re.sub(r'`([^`]+)`', r'<code>\1</code>', text)
    # Bold **text**
    text = re.sub(r'\*\*([^*]+)\*\*', r'<strong>\1</strong>', text)
    # Italic *text*
    text = re.sub(r'(?<!\*)\*([^*]+)\*(?!\*)', r'<em>\1</em>', text)
    # Links [text](url) - handles brackets inside text like [at]
    text = re.sub(r'\[(.*?)\]\((mailto:[^\s)]+|https?://[^\s)]+|/[^\s)]*)\)', r'<a href="\2">\1</a>', text)
    return text

def render_template(template_str, context):
    """Replace $variable$ tags in template."""
    result = template_str

    # Handle conditionals: $if(var)$...$else$...$endif$ or $if(var)$...$endif$
    def replace_cond(match):
        var = match.group(1)
        then_part = match.group(2)
        else_part = match.group(3) if match.group(3) else ""
        if context.get(var):
            return then_part
        return else_part

    cond_pattern = re.compile(r'\$if\(([a-zA-Z0-9_]+)\)\$((?:(?!\$if\().)*?)(?:\$else\$((?:(?!\$if\().)*?))?\$endif\$', re.DOTALL)
    for _ in range(5):
        if not cond_pattern.search(result):
            break
        result = cond_pattern.sub(replace_cond, result)

    # Handle standard replacements
    for key, val in context.items():
        result = result.replace(f"${key}$", str(val))

    # Clean up unreplaced optional variables
    result = re.sub(r'\$[a-zA-Z0-9_]+\$', '', result)
    return result

def build_site():
    """Build all pages into _site directory."""
    print("Building website preview...")
    if SITE_DIR.exists():
        shutil.rmtree(SITE_DIR)
    SITE_DIR.mkdir(parents=True, exist_ok=True)

    # Copy static assets
    if CSS_DIR.exists():
        shutil.copytree(CSS_DIR, SITE_DIR / "css")
    if PDFS_DIR.exists():
        (SITE_DIR / "pdfs").mkdir(parents=True, exist_ok=True)
        for pdf in PDFS_DIR.glob("*.pdf"):
            shutil.copy(pdf, SITE_DIR / "pdfs" / pdf.name)

    # Load templates
    default_tpl = (TEMPLATES_DIR / "default.html").read_text(encoding="utf-8")
    page_tpl = (TEMPLATES_DIR / "page.html").read_text(encoding="utf-8")
    background_tpl = (TEMPLATES_DIR / "background.html").read_text(encoding="utf-8")
    contact_tpl = (TEMPLATES_DIR / "contact.html").read_text(encoding="utf-8")
    post_tpl = (TEMPLATES_DIR / "post.html").read_text(encoding="utf-8")
    archive_tpl = (TEMPLATES_DIR / "archive.html").read_text(encoding="utf-8")
    post_item_tpl = (TEMPLATES_DIR / "post-list.html").read_text(encoding="utf-8")

    # 1. Render Index (Home)
    if (PAGES_DIR / "index.md").exists():
        fm, body = parse_frontmatter((PAGES_DIR / "index.md").read_text(encoding="utf-8"))
        html_body = simple_markdown_to_html(body)
        page_html = render_template(page_tpl, {"isHome": "true", "title": "", "body": html_body})
        full_html = render_template(default_tpl, {"isHome": "true", "title": "Ian Thomas White", "body": page_html})
        (SITE_DIR / "index.html").write_text(full_html, encoding="utf-8")
        print("  &check; Built index.html")

    # 2. Render Background
    if (PAGES_DIR / "background.md").exists():
        fm, body = parse_frontmatter((PAGES_DIR / "background.md").read_text(encoding="utf-8"))
        html_body = simple_markdown_to_html(body)
        background_html = render_template(background_tpl, {"body": html_body})
        full_html = render_template(default_tpl, {"isBackground": "true", "title": "Background", "body": background_html})
        (SITE_DIR / "background.html").write_text(full_html, encoding="utf-8")
        print("  &check; Built background.html")

    # 3. Render Writing
    if (PAGES_DIR / "writing.md").exists():
        fm, body = parse_frontmatter((PAGES_DIR / "writing.md").read_text(encoding="utf-8"))
        html_body = simple_markdown_to_html(body)
        page_html = render_template(page_tpl, {"title": fm.get("title", "Writing"), "body": html_body})
        full_html = render_template(default_tpl, {"isWriting": "true", "title": "Writing", "body": page_html})
        (SITE_DIR / "writing.html").write_text(full_html, encoding="utf-8")
        print("  &check; Built writing.html")

    # 4. Render Contact
    if (PAGES_DIR / "contact.md").exists():
        fm, body = parse_frontmatter((PAGES_DIR / "contact.md").read_text(encoding="utf-8"))
        html_body = simple_markdown_to_html(body)
        contact_html = render_template(contact_tpl, {"body": html_body})
        full_html = render_template(default_tpl, {"isContact": "true", "title": "Contact", "body": contact_html})
        (SITE_DIR / "contact.html").write_text(full_html, encoding="utf-8")
        print("  &check; Built contact.html")

    # 5. Render Blog/Thoughts Posts
    posts_data = []
    (SITE_DIR / "posts").mkdir(parents=True, exist_ok=True)
    if POSTS_DIR.exists():
        for post_file in sorted(POSTS_DIR.glob("*.md"), reverse=True):
            fm, body = parse_frontmatter(post_file.read_text(encoding="utf-8"))
            html_body = simple_markdown_to_html(body)
            post_title = fm.get("title", post_file.stem)
            post_date = fm.get("date", "")
            post_tags = fm.get("tags", "")
            post_url = f"/posts/{post_file.stem}.html"

            post_html = render_template(post_tpl, {
                "title": post_title,
                "date": post_date,
                "tags": post_tags,
                "body": html_body
            })
            full_html = render_template(default_tpl, {"isThoughts": "true", "title": "Thoughts", "body": post_html})
            (SITE_DIR / "posts" / f"{post_file.stem}.html").write_text(full_html, encoding="utf-8")

            posts_data.append({
                "title": post_title,
                "date": post_date,
                "url": post_url
            })
            print(f"  &check; Built posts/{post_file.stem}.html")

    # 6. Render Thoughts Archive
    post_items_html = ""
    for p in posts_data:
        post_items_html += render_template(post_item_tpl, p) + "\n"

    archive_body = re.sub(r'\$for\(posts\)\$.*?\$endfor\$', post_items_html, archive_tpl, flags=re.DOTALL)
    full_archive_html = render_template(default_tpl, {"isThoughts": "true", "title": "Thoughts", "body": archive_body})
    (SITE_DIR / "thoughts.html").write_text(full_archive_html, encoding="utf-8")
    (SITE_DIR / "blog.html").write_text(full_archive_html, encoding="utf-8")
    print("  &check; Built thoughts.html & blog.html")
    print(f"\nPreview site compiled into: {SITE_DIR}")

class NoCacheHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()

def serve_site(port=8000):
    """Run local HTTP server with cache-busting headers."""
    os.chdir(SITE_DIR)
    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(("", port), NoCacheHandler) as httpd:
        print(f"\n=======================================================")
        print(f"  Local Preview running at: http://localhost:{port}")
        print(f"  Press Ctrl+C in terminal to stop.")
        print(f"=======================================================\n")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nServer stopped.")

if __name__ == "__main__":
    build_site()
    if len(sys.argv) > 1 and sys.argv[1] == "--build-only":
        sys.exit(0)
    serve_site()
