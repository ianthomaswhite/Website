# Ian Thomas White — Personal Website & Academic Portfolio

A minimalist, brutalist personal website and research repository for **[ianthomaswhite.com](https://ianthomaswhite.com)**.

Powered by **Haskell** ([Hakyll](https://jaspervdj.be/hakyll/)), styled with high-contrast brutalist aesthetics (`#FCF75E` yellow accent), equipped with an automated **LaTeX** publication pipeline, and continuously deployed via **GitHub Actions** to **GitHub Pages**.

---

## Architecture & Features

- **Brutalist Minimalism:** Fast, responsive, clean typography, visible borders, and zero client-side framework bloat.
- **Haskell Static Site Generator:** Compile-time route validation and Markdown processing via Pandoc and Hakyll.
- **Dual-Resume Architecture on `/resume.html`:**
  - **1-Page Concise Resume:** Authored in LaTeX (`resume/resume-onepage.tex`) and compiled to `pdfs/resume-onepage.pdf`.
  - **Full Extended Resume:** Authored in Markdown (`pages/resume.md`) and rendered on-page with direct PDF download and clean `@media print` support.
- **Single-Page Writing Portfolio (`/writing.html`):** Writing samples and papers organized by genre/discipline (*Linguistics*, *Philosophy*, *Technical Systems*), each with an abstract and compiled PDF download link.
- **Continuous LaTeX Compilation:** GitHub Actions automatically compiles LaTeX resumes and writing papers into publication-ready PDFs upon git push.
- **Effortless Web Publishing:** Write and publish blog posts in your browser by pressing `.` on your GitHub repo (via `github.dev` VS Code) or via the built-in Decap CMS `/admin/` interface.

---

## Directory Structure

```
.
├── .github/workflows/deploy.yml # Automated CI/CD (LaTeX build -> Hakyll build -> GitHub Pages)
├── site.hs                     # Hakyll site generator definition in Haskell
├── website.cabal               # Cabal package specification
├── cabal.project               # Cabal project configuration
├── CNAME                       # Custom domain (ianthomaswhite.com)
├── admin/                      # Web CMS portal (/admin/)
│   ├── index.html
│   └── config.yml
├── css/
│   └── style.css               # Brutalist CSS (B&W + #FCF75E accent + print styles)
├── templates/
│   ├── default.html            # Main site shell (nav: Home, Resume, Writing, Blog)
│   ├── page.html               # Generic page container
│   ├── post.html               # Blog post layout
│   ├── post-list.html          # Blog list snippet
│   ├── archive.html            # Blog archive index
│   ├── resume.html             # Resume page (dual PDF download banner + on-page resume)
│   └── commentary.html         # Template for line/quote/commentary reviews
├── pages/
│   ├── index.md                # Homepage (About + Contact information combined)
│   ├── resume.md               # Full on-page resume content
│   └── writing.md              # Writing samples organized by genre
├── resume/
│   ├── resume-onepage.tex      # 1-page LaTeX source (compiled to pdfs/resume-onepage.pdf)
│   └── resume-full.tex         # Full LaTeX source (compiled to pdfs/resume-full.pdf)
├── papers/                     # Curated LaTeX papers organized by genre
│   ├── linguistics/
│   │   └── proto-indo-european-phonology.tex
│   └── essays/
│       └── on-formal-systems.tex
├── posts/                      # Blog posts (Markdown)
│   └── 2026-09-13-welcome.md
├── commentaries/               # Reading commentaries (dedicated schema)
│   └── sample-commentary.md
├── scripts/
│   ├── build-resumes.sh        # Compiles 1-page and full resumes to PDFs
│   └── import-paper.sh         # Helper to copy & stage local LaTeX papers into papers/<genre>/
├── pdfs/                       # Generated PDF outputs for download
└── images/                     # Favicons and image assets
```

---

## How to Manage Content

### 1. Updating Resumes
- **1-Page Resume:** Edit `resume/resume-onepage.tex`. 
- **Full On-Page Resume:** Edit `pages/resume.md` (and `resume/resume-full.tex`).
- To test compile locally:
  ```bash
  ./scripts/build-resumes.sh
  ```
  This immediately updates `pdfs/resume-onepage.pdf` and `pdfs/resume-full.pdf`.

### 2. Publishing Files from Your Private Repositories
Your private repositories (papers, essays, resumes) stay completely separate and private. To selectively publish a file to the website:

1. Add a line to [**`sync-manifest.conf`**](file:///home/ianthomaswhite/Projects/Website/sync-manifest.conf):
   ```bash
   ~/Projects/MyPrivateRepo/paper.tex -> papers/linguistics/paper.tex
   ```
2. Run the sync command:
   ```bash
   ./scripts/sync.sh
   ```
   This will pull only the mapped files that have changed, recompile their PDFs, and report what was updated.
3. Add a link/card in `pages/writing.md` or `pages/resume.md` whenever you want it displayed on the site.

### 3. Writing Blog Posts
You have three convenient ways to publish posts:
- **Instant Browser VS Code (`github.dev`):** Navigate to your repository on GitHub and press the `.` key. Edit or add files in `posts/`, and click Commit & Push.
- **Web CMS:** Visit `https://ianthomaswhite.com/admin/` to use a graphical form-based markdown editor.
- **Local Git:** Create a new markdown file in `posts/YYYY-MM-DD-title.md`:
  ```markdown
  ---
  title: Title of Post
  date: 2026-09-13
  tags: haskell, linguistics
  ---
  Your content here...
  ```

---

## Deployment & Domain Configuration

### Step 1: Push Repository to GitHub
In this folder, initialize git and push to your GitHub account:
```bash
git init
git add .
git commit -m "Revamp website with Hakyll, LaTeX pipeline, and brutalist design"
git branch -M main
git remote add origin git@github.com:ianthomaswhite/Website.git
git push -u origin main
```

### Step 2: Enable GitHub Pages
1. Go to your repository on GitHub -> **Settings** -> **Pages**.
2. Under **Build and deployment** > **Source**, select **GitHub Actions**.
3. The `.github/workflows/deploy.yml` workflow will automatically run on every push to `main`, compile your LaTeX papers, build the Hakyll site, and publish.

### Step 3: Squarespace DNS Settings
In your **Squarespace Domains** dashboard for `ianthomaswhite.com`:
1. Navigate to **DNS Settings**.
2. Add **4 A Records** for the root domain (`@`):
   - Host: `@` | Value: `185.199.108.153`
   - Host: `@` | Value: `185.199.109.153`
   - Host: `@` | Value: `185.199.110.153`
   - Host: `@` | Value: `185.199.111.153`
3. Add **1 CNAME Record** for `www`:
   - Host: `www` | Value: `ianthomaswhite.github.io`
4. Once DNS propagates (usually 15–30 minutes), enable **Enforce HTTPS** in GitHub Pages settings.
