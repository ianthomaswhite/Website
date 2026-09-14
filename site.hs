{-# LANGUAGE OverloadedStrings #-}

import           Data.Monoid (mappend)
import           Hakyll

--------------------------------------------------------------------------------
config :: Configuration
config = defaultConfiguration
    { destinationDirectory = "_site"
    , storeDirectory       = "_cache"
    , tmpDirectory         = "_cache/tmp"
    }

main :: IO ()
main = hakyllWith config $ do
    -- Static assets
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "pdfs/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "CNAME" $ do
        route   idRoute
        compile copyFileCompiler

    -- Templates
    match "templates/*" $ compile templateBodyCompiler

    -- Core Pages
    match "pages/index.md" $ do
        route $ constRoute "index.html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/page.html"    defaultContext
            >>= loadAndApplyTemplate "templates/default.html" (constField "isHome" "true" `mappend` siteCtx "Home")
            >>= relativizeUrls

    match "pages/resume.md" $ do
        route $ constRoute "resume.html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/resume.html"  defaultContext
            >>= loadAndApplyTemplate "templates/default.html" (constField "title" "Resume" `mappend` siteCtx "Resume")
            >>= relativizeUrls

    match "pages/writing.md" $ do
        route $ constRoute "writing.html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/page.html"    defaultContext
            >>= loadAndApplyTemplate "templates/default.html" (constField "title" "Writing" `mappend` siteCtx "Writing")
            >>= relativizeUrls

    -- Blog Posts
    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" (constField "title" "Blog" `mappend` postCtx)
            >>= relativizeUrls

    -- Blog Archive
    create ["blog.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Blog"                `mappend`
                    siteCtx "Blog"

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

siteCtx :: String -> Context String
siteCtx currentTitle =
    constField "siteTitle" "Ian Thomas White" `mappend`
    constField "activePage" currentTitle      `mappend`
    defaultContext
