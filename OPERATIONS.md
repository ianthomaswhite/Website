# Website Operations & Maintenance Manual

A practical operational guide for managing content, updating resumes, syncing private research documents, and maintaining `ianthomaswhite.com`.

---

## 1. Updating Resumes

The website features two resume versions:

### A. 1-Page Concise Resume (LaTeX)
- **Source:** `resume/resume-onepage.tex`
- **Output:** `pdfs/resume-onepage.pdf`
- **Workflow:** Edit the `.tex` file directly (or sync it from a private repo). When pushed to GitHub, it is compiled into a PDF automatically.

### B. Full On-Page Resume (Markdown)
- **Source:** `pages/resume.md`
- **Output:** Rendered directly on `/resume.html`, and compiled into `pdfs/resume-full.pdf`
- **Workflow:** Edit the Markdown file directly. This is the single source of truth for both the web view and the full downloadable PDF.

### Local Test Compilation
To test-compile both resumes into PDFs locally on your machine:
```bash
./scripts/build-resumes.sh
```

---

## 2. Syncing Documents from Private Repositories

Your private local repositories (papers, essays, drafts) remain completely separate and private. To selectively publish a file to the website:

1. Open [**`sync-manifest.conf`**](sync-manifest.conf) and add a mapping:
   ```text
   ~/path/to/private/repo/paper.tex -> papers/linguistics/paper.tex
   ```
2. Run the sync command:
   ```bash
   ./scripts/sync.sh
   ```
   This script:
   - Reads `sync-manifest.conf`.
   - Checks if any of the mapped files have changed.
   - Copies only the updated files into the website folder.
   - Automatically recompiles the PDFs.
3. Whenever you want the paper listed on `/writing.html`, add an entry card in `pages/writing.md`:
   ```html
   <div class="paper-card">
       <div class="paper-header">
           <h3 class="paper-title">Your Paper Title</h3>
           <span class="paper-meta">Category &middot; 2026</span>
       </div>
       <p class="paper-description">Short abstract or summary.</p>
       <a href="/pdfs/paper.pdf" class="btn btn-accent" download>&darr; Download PDF</a>
   </div>
   ```

---

## 3. Writing and Publishing Blog Posts

### Method A: In Any Browser (Zero Setup)
1. Open your repository on GitHub: `https://github.com/ianthomaswhite/Website`
2. Press the **`.` (period)** key to open the browser-based VS Code editor (`github.dev`).
3. Create a new markdown file in `posts/` named `YYYY-MM-DD-title.md`:
   ```markdown
   ---
   title: Your Post Title
   date: 2026-09-13
   tags: general, research
   ---

   Your content here...
   ```
4. Click **Commit & Push** in the Source Control panel.

### Method B: Local Git
Create the markdown file in `posts/`, commit, and push:
```bash
git add posts/
git commit -m "feat: publish new post"
git push origin main
```

---

## 4. Deployment Pipeline

Deployments are 100% automated via GitHub Actions on every push to the `main` branch:
- **Workflow File:** `.github/workflows/deploy.yml`
- **Actions Performed on Push:**
  1. Installs TeX Live and Pandoc.
  2. Compiles `resume/resume-onepage.tex` to `pdfs/resume-onepage.pdf`.
  3. Compiles `pages/resume.md` to `pdfs/resume-full.pdf` via Pandoc.
  4. Compiles any papers found in `papers/` to `pdfs/`.
  5. Installs Haskell (GHC + Cabal), builds Hakyll, and runs `site build`.
  6. Bundles static HTML and PDFs together and publishes to GitHub Pages.

---

## 5. Squarespace DNS Configuration

To connect your custom domain `ianthomaswhite.com`:

1. In your **Squarespace Domains** dashboard for `ianthomaswhite.com`, go to **DNS Settings**.
2. Add **4 A records** for `@`:
   - Host: `@` | Type: `A` | Data: `185.199.108.153`
   - Host: `@` | Type: `A` | Data: `185.199.109.153`
   - Host: `@` | Type: `A` | Data: `185.199.110.153`
   - Host: `@` | Type: `A` | Data: `185.199.111.153`
3. Add **1 CNAME record** for `www`:
   - Host: `www` | Type: `CNAME` | Data: `ianthomaswhite.github.io`
4. Once DNS propagates, go to your GitHub repository &rarr; **Settings** &rarr; **Pages**, and verify **Enforce HTTPS** is enabled.
