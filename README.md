# ianthomaswhite.com

Source code and assets for the personal website and research repository of **Ian Thomas White**, accessible at [ianthomaswhite.com](https://ianthomaswhite.com).

## Overview

This site is a statically compiled portfolio, research clearinghouse, and blog built with [Hakyll](https://jaspervdj.be/hakyll/) (Haskell), Pandoc, and LaTeX. It is continuously built and published via GitHub Actions to GitHub Pages.

## Repository Layout

- `site.hs` — Hakyll site generator in Haskell.
- `pages/` — Core pages (Home, Resume, Writing).
- `posts/` — Blog posts and notes (Markdown).
- `templates/` — HTML layout templates.
- `css/` — Stylesheets and print media styles.
- `resume/` — LaTeX source for the 1-page resume.
- `papers/` — Published research papers and essays (LaTeX).
- `scripts/` — Helper scripts for syncing files and local PDF compilation.
- `sync-manifest.conf` — Mapping configuration for publishing selected files from private repositories.
- `.github/workflows/deploy.yml` — Automated CI/CD pipeline.

## Build Stack

- **Site Generator:** Hakyll (Haskell)
- **Markup & Formatting:** Pandoc, LaTeX (`pdflatex`)
- **Hosting & CI/CD:** GitHub Pages via GitHub Actions

## Operations & Maintenance

For instructions on adding content, compiling PDFs, syncing documents from private local repositories, and DNS configuration, see [**`OPERATIONS.md`**](OPERATIONS.md).

## License

Written content and papers &copy; Ian Thomas White. All rights reserved.  
Site generation source code is available under the MIT License.
