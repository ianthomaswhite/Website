#!/usr/bin/env python3
"""
Simple Local Preview Generator & Zero-Cache Web Server
======================================================
Author: Ian Thomas White
Description:
    A zero-dependency Python script that mirrors the Hakyll build pipeline.
    It reads Markdown sources from `pages/` and `posts/`, evaluates YAML
    frontmatter, parses Markdown syntax into semantic HTML, interpolates
    variables into Hakyll templates from `templates/editorial/`, and serves
    the compiled static site at `http://localhost:8000`.

Why this exists:
    Allows instant local previewing and automated verification of website
    styling and layout without requiring GHC, Cabal, or Hakyll installed.
"""

import os
import re
import sys
import shutil
import http.server
import socketserver
from pathlib import Path

# Base directory paths anchored to the project root
ROOT_DIR = Path(__file__).resolve().parent.parent
SITE_DIR = ROOT_DIR / "_site"
TEMPLATES_DIR = ROOT_DIR / "templates" / "editorial"
PAGES_DIR = ROOT_DIR / "pages"
POSTS_DIR = ROOT_DIR / "posts"
CSS_DIR = ROOT_DIR / "css"
PDFS_DIR = ROOT_DIR / "pdfs"

def parse_frontmatter(content):
    """
    Extracts YAML frontmatter metadata and Markdown body content from a file.

    Parameters:
        content (str): Full text of the Markdown file.

    Returns:
        tuple (dict, str):
            - metadata: Dictionary of key-value pairs parsed from the frontmatter block.
            - body: The remaining Markdown content with leading/trailing whitespace stripped.
    """
    metadata = {}
    body = content
    # YAML frontmatter is enclosed between triple dashes ('---')
    if content.startswith("---"):
        parts = content.split("---", 2)
        if len(parts) >= 3:
            fm_text = parts[1]
            body = parts[2]
            # Parse simple 'key: value' lines
            for line in fm_text.strip().splitlines():
                if ":" in line:
                    k, v = line.split(":", 1)
                    metadata[k.strip()] = v.strip().strip('"').strip("'")
    return metadata, body.strip()

def simple_markdown_to_html(md_text):
    """
    Translates common Markdown constructs to clean HTML while preserving inline HTML blocks.

    Handles:
        - Fenced code blocks (```lang ... ```)
        - Unordered lists (- item or * item)
        - Headings (# through ####)
        - Horizontal rules (---)
        - Inline formatting (bold, italic, inline code, links)
        - Raw HTML passthrough (<div>, <span>, <pre>, etc.)
        - Paragraph wrapping (<p>...</p>)

    Parameters:
        md_text (str): Raw Markdown string.

    Returns:
        str: Resulting HTML snippet.
    """
    lines = md_text.splitlines()
    html_lines = []
    in_code_block = False
    in_list = False
    in_sublist = False

    for line in lines:
        stripped = line.strip()

        # Handle fenced code block open/close toggles
        if stripped.startswith("```"):
            if in_code_block:
                html_lines.append("</code></pre>")
                in_code_block = False
            else:
                lang = stripped[3:].strip()
                html_lines.append(f'<pre><code class="language-{lang}">' if lang else '<pre><code>')
                in_code_block = True
            continue

        # If inside a code block, preserve line content without markdown processing
        if in_code_block:
            html_lines.append(line)
            continue

        # Unordered list items: manage <ul> and nested sub-list opening and closing tags
        if stripped.startswith("- ") or stripped.startswith("* "):
            indent = len(line) - len(line.lstrip())
            item_content = inline_formatting(stripped[2:].strip())

            if indent >= 2 and in_list:
                if not in_sublist:
                    # Open nested <ul> inside previous <li>
                    if html_lines and html_lines[-1].endswith("</li>"):
                        html_lines[-1] = html_lines[-1][:-5]
                    html_lines.append("<ul>")
                    in_sublist = True
                html_lines.append(f"<li>{item_content}</li>")
            else:
                if in_sublist:
                    html_lines.append("</ul></li>")
                    in_sublist = False
                if not in_list:
                    html_lines.append("<ul>")
                    in_list = True
                html_lines.append(f"<li>{item_content}</li>")
            continue
        elif in_list and not stripped:
            if in_sublist:
                html_lines.append("</ul></li>")
                in_sublist = False
            html_lines.append("</ul>")
            in_list = False
            continue
        elif in_list and not (stripped.startswith("- ") or stripped.startswith("* ")):
            if in_sublist:
                html_lines.append("</ul></li>")
                in_sublist = False
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

    if in_sublist:
        html_lines.append("</ul></li>")
    if in_list:
        html_lines.append("</ul>")
    if in_code_block:
        html_lines.append("</code></pre>")

    return "\n".join(html_lines)

def inline_formatting(text):
    """
    Parses common inline Markdown syntax into HTML tags.

    Supports:
        - Inline code: `code` -> <code>code</code>
        - Bold text: **bold** -> <strong>bold</strong>
        - Italic text: *italic* -> <em>italic</em>
        - Hyperlinks: [label](url) -> <a href="url">label</a>
    """
    # Inline code
    text = re.sub(r'`([^`]+)`', r'<code>\1</code>', text)
    # Bold **text**
    text = re.sub(r'\*\*([^*]+)\*\*', r'<strong>\1</strong>', text)
    # Italic *text* (negative lookaround prevents matching inside bold markers)
    text = re.sub(r'(?<!\*)\*([^*]+)\*(?!\*)', r'<em>\1</em>', text)
    # Links [text](url) - supports mailto:, absolute URLs, and root-relative paths
    def _link_replace(m):
        label = m.group(1)
        url = m.group(2)
        if url.endswith(".pdf") or url.startswith("http"):
            return f'<a href="{url}" target="_blank" rel="noopener">{label}</a>'
        return f'<a href="{url}">{label}</a>'

    text = re.sub(r'\[(.*?)\]\((mailto:[^\s)]+|https?://[^\s)]+|/[^\s)]*)\)', _link_replace, text)
    return text

def render_template(template_str, context):
    """
    Evaluates Hakyll-style template variables and conditionals.

    Supports:
        - Conditional blocks: $if(var)$ ... $else$ ... $endif$
        - Variable interpolation: $title$, $body$, $date$, etc.
        - Safe cleanup of unused optional variables.
    """
    result = template_str

    # Process nested conditionals: $if(var)$...$else$...$endif$ or $if(var)$...$endif$
    def replace_cond(match):
        var = match.group(1)
        then_part = match.group(2)
        else_part = match.group(3) if match.group(3) else ""
        if context.get(var):
            return then_part
        return else_part

    # Recursively resolve up to 5 levels of nested conditionals
    cond_pattern = re.compile(r'\$if\(([a-zA-Z0-9_]+)\)\$((?:(?!\$if\().)*?)(?:\$else\$((?:(?!\$if\().)*?))?\$endif\$', re.DOTALL)
    for _ in range(5):
        if not cond_pattern.search(result):
            break
        result = cond_pattern.sub(replace_cond, result)

    # Perform variable interpolation for provided context values
    for key, val in context.items():
        result = result.replace(f"${key}$", str(val))

    # Strip any remaining unpopulated $variable$ placeholders
    result = re.sub(r'\$[a-zA-Z0-9_]+\$', '', result)
    return result

def build_site():
    """
    Executes the full static site generation pipeline into the _site/ directory.

    Pipeline stages:
        1. Resets and cleans the target output directory (_site/).
        2. Copies static CSS stylesheets and resume/paper PDFs.
        3. Loads editorial templates (default, page, background, contact, post, archive).
        4. Compiles Core Pages:
            - Homepage (index.html with header blank slot)
            - Background (background.html)
            - Writing (writing.html with Academic & Creative sections)
            - Contact (contact.html with left indicator lines)
        5. Compiles Individual Thoughts/Blog posts (/posts/<slug>.html).
        6. Builds Reverse-Chronological Archive (thoughts.html & blog.html).
    """
    print("Building website preview...")
    if SITE_DIR.exists():
        shutil.rmtree(SITE_DIR)
    SITE_DIR.mkdir(parents=True, exist_ok=True)

    # Copy static CSS stylesheets
    if CSS_DIR.exists():
        shutil.copytree(CSS_DIR, SITE_DIR / "css")

    # Copy static PDFs (resumes, papers)
    if PDFS_DIR.exists():
        shutil.copytree(PDFS_DIR, SITE_DIR / "pdfs", dirs_exist_ok=True)

    # Load templates from templates/editorial/
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

    # 4. Render Contact (Commented out per user request; preserved in case needed later)
    # if (PAGES_DIR / "contact.md").exists():
    #     fm, body = parse_frontmatter((PAGES_DIR / "contact.md").read_text(encoding="utf-8"))
    #     html_body = simple_markdown_to_html(body)
    #     contact_html = render_template(contact_tpl, {"body": html_body})
    #     full_html = render_template(default_tpl, {"isContact": "true", "title": "Contact", "body": contact_html})
    #     (SITE_DIR / "contact.html").write_text(full_html, encoding="utf-8")
    #     print("  &check; Built contact.html")

    # 5. Render Blog/Thoughts Posts
    posts_data = []
    (SITE_DIR / "posts").mkdir(parents=True, exist_ok=True)
    if POSTS_DIR.exists():
        for post_file in sorted(POSTS_DIR.glob("*.md"), reverse=True):
            fm, body = parse_frontmatter(post_file.read_text(encoding="utf-8"))
            html_body = simple_markdown_to_html(body)
            post_title = fm.get("title", post_file.stem)
            raw_date = fm.get("date", "")
            # Format post date as MM.DD.YYYY (preserving day)
            d_match_day = re.match(r'^(\d{4})[.-](\d{2})[.-](\d{2})$', raw_date.strip())
            if d_match_day:
                post_date = f"{d_match_day.group(2)}.{d_match_day.group(3)}.{d_match_day.group(1)}"
            else:
                d_match_month = re.match(r'^(\d{4})[.-](\d{2})$', raw_date.strip())
                if d_match_month:
                    post_date = f"{d_match_month.group(2)}.{d_match_month.group(1)}"
                else:
                    post_date = raw_date
            post_tags = fm.get("tags", "")
            post_url = f"/posts/{post_file.stem}"

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
    """
    HTTP request handler that adds cache-busting headers to every response.
    This guarantees that browser refreshes immediately display latest CSS/HTML edits.
    Also resolves clean extensionless URLs (e.g. /background -> /background.html).
    """
    def translate_path(self, path):
        translated = super().translate_path(path)
        if not os.path.exists(translated):
            html_candidate = translated + ".html"
            if os.path.isfile(html_candidate):
                return html_candidate
        return translated

    def end_headers(self):
        # Instruct browsers and proxies to never cache preview assets
        self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")
        super().end_headers()

def serve_site(port=8000):
    """
    Starts a local development HTTP server serving the _site/ directory.

    Features:
        - Changes working directory to _site/
        - Sets SO_REUSEADDR on TCP socket to prevent 'Address already in use' errors
        - Handles Ctrl+C (KeyboardInterrupt) cleanly without traceback
    """
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
            print("\nServer stopped gracefully.")

if __name__ == "__main__":
    # Always recompile the preview site first
    build_site()

    # If invoked with --build-only, exit immediately after compilation
    if len(sys.argv) > 1 and sys.argv[1] == "--build-only":
        sys.exit(0)

    # Allow custom port as an argument (e.g. python3 scripts/preview.py 8080)
    target_port = 8000
    if len(sys.argv) > 1 and sys.argv[1].isdigit():
        target_port = int(sys.argv[1])

    serve_site(port=target_port)
