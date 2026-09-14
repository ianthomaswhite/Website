{-# LANGUAGE OverloadedStrings #-}

{- |
Module      : Main
Description : Hakyll static site compiler configuration for Ian Thomas White's website.
Author      : Ian Thomas White

This file defines the build rules and compilation pipeline for the website:
  1. Static Assets: Copies images, minifies CSS, passes through PDFs and CNAME.
  2. Templates: Compiles inner and outer templates from templates/editorial/.
  3. Pages: Compiles Markdown pages (index, background, writing, contact) into HTML,
     wrapping each with an inner page template and the global editorial default template.
  4. Posts: Converts Markdown thought/blog posts into standalone HTML articles.
  5. Archive: Dynamically queries all posts, sorts them chronologically, and generates
     the Thoughts listing archive (thoughts.html).
-}

import           Data.Monoid (mappend)
import           Hakyll

--------------------------------------------------------------------------------
-- | Build Configuration
-- Specifies destination for generated static HTML and persistent cache storage.
--------------------------------------------------------------------------------
config :: Configuration
config = defaultConfiguration
    { destinationDirectory = "_site"       -- Target output directory for production/deploy
    , storeDirectory       = "_cache"      -- Cache directory tracking content hashes
    , tmpDirectory         = "_cache/tmp"  -- Temporary scratch directory during builds
    }

--------------------------------------------------------------------------------
-- | Main Rules Entry Point
--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith config $ do

    -- -------------------------------------------------------------------------
    -- Static Binary Assets: Copied directly without modification
    -- -------------------------------------------------------------------------
    match "images/*" $ do
        route   idRoute              -- Output file keeps same relative path in _site/
        compile copyFileCompiler     -- Fast binary copy

    match "css/*" $ do
        route   idRoute              -- Keeps path (e.g. css/editorial.css)
        compile compressCssCompiler  -- Strips unnecessary whitespace and minifies CSS

    match "pdfs/*" $ do
        route   idRoute              -- Preserves PDF paths (e.g. pdfs/resume-onepage.pdf)
        compile copyFileCompiler     -- Fast binary copy

    match "CNAME" $ do
        route   idRoute              -- Custom domain configuration file for GitHub Pages
        compile copyFileCompiler

    -- -------------------------------------------------------------------------
    -- Templates: Parsed into Hakyll's internal Template structure
    -- -------------------------------------------------------------------------
    match "templates/*"           $ compile templateBodyCompiler
    match "templates/editorial/*" $ compile templateBodyCompiler

    -- -------------------------------------------------------------------------
    -- Core Content Pages
    -- -------------------------------------------------------------------------

    -- Homepage: / -> index.html
    -- Uses isHome flag so page.html can inject the blank slot reserving header height
    match "pages/index.md" $ do
        route $ constRoute "index.html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/editorial/page.html"    (constField "isHome" "true" `mappend` defaultContext)
            >>= loadAndApplyTemplate "templates/editorial/default.html" (constField "isHome" "true" `mappend` siteCtx "Home")
            >>= relativizeUrls

    -- Background Page: /background.html (Education, Experience, Projects, Publications, Skills, Downloads)
    match "pages/background.md" $ do
        route $ constRoute "background.html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/editorial/background.html" defaultContext
            >>= loadAndApplyTemplate "templates/editorial/default.html"    (constField "isBackground" "true" `mappend` siteCtx "Background")
            >>= relativizeUrls

    -- Writing Page: /writing.html (Academic and Creative sections)
    match "pages/writing.md" $ do
        route $ constRoute "writing.html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/editorial/page.html"    defaultContext
            >>= loadAndApplyTemplate "templates/editorial/default.html" (constField "isWriting" "true" `mappend` siteCtx "Writing")
            >>= relativizeUrls

    {- Contact Page: /contact.html
       Temporarily disabled per user request; preserved here in case needed in the future.
    match "pages/contact.md" $ do
        route $ constRoute "contact.html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/editorial/contact.html" defaultContext
            >>= loadAndApplyTemplate "templates/editorial/default.html" (constField "isContact" "true" `mappend` siteCtx "Contact")
            >>= relativizeUrls
    -}

    -- -------------------------------------------------------------------------
    -- Individual Thoughts / Blog Posts: /posts/<slug>.html
    -- -------------------------------------------------------------------------
    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/editorial/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/editorial/default.html" (constField "isThoughts" "true" `mappend` postCtx)
            >>= relativizeUrls

    -- -------------------------------------------------------------------------
    -- Thoughts Archive Listing: /thoughts.html
    -- Aggregates all posts sorted in reverse chronological order
    -- -------------------------------------------------------------------------
    create ["thoughts.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Thoughts"            `mappend`
                    constField "isThoughts" "true"           `mappend`
                    siteCtx "Thoughts"

            makeItem ""
                >>= loadAndApplyTemplate "templates/editorial/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/editorial/default.html" archiveCtx
                >>= relativizeUrls

--------------------------------------------------------------------------------
-- | Context Helpers
--------------------------------------------------------------------------------

-- | Post Context: Injects formatted date along with default metadata
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

-- | Global Site Context: Injects site title and current page title
siteCtx :: String -> Context String
siteCtx currentTitle =
    constField "siteTitle" "Ian Thomas White" `mappend`
    constField "title" currentTitle           `mappend`
    defaultContext
