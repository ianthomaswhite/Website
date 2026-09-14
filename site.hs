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

    -- Templates (editorial and legacy)
    match "templates/*"           $ compile templateBodyCompiler
    match "templates/editorial/*" $ compile templateBodyCompiler

    -- Core Pages
    match "pages/index.md" $ do
        route $ constRoute "index.html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/editorial/page.html"    defaultContext
            >>= loadAndApplyTemplate "templates/editorial/default.html" (constField "isHome" "true" `mappend` siteCtx "Home")
            >>= relativizeUrls

    match "pages/resume.md" $ do
        route $ constRoute "resume.html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/editorial/resume.html"  defaultContext
            >>= loadAndApplyTemplate "templates/editorial/default.html" (constField "isResume" "true" `mappend` siteCtx "Resume")
            >>= relativizeUrls

    match "pages/writing.md" $ do
        route $ constRoute "writing.html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/editorial/page.html"    defaultContext
            >>= loadAndApplyTemplate "templates/editorial/default.html" (constField "isWriting" "true" `mappend` siteCtx "Writing")
            >>= relativizeUrls

    match "pages/contact.md" $ do
        route $ constRoute "contact.html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/editorial/contact.html" defaultContext
            >>= loadAndApplyTemplate "templates/editorial/default.html" (constField "isContact" "true" `mappend` siteCtx "Contact")
            >>= relativizeUrls

    -- Blog Posts
    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/editorial/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/editorial/default.html" (constField "isBlog" "true" `mappend` postCtx)
            >>= relativizeUrls

    -- Blog Archive
    create ["blog.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Blog"                `mappend`
                    constField "isBlog" "true"               `mappend`
                    siteCtx "Blog"

            makeItem ""
                >>= loadAndApplyTemplate "templates/editorial/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/editorial/default.html" archiveCtx
                >>= relativizeUrls

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

siteCtx :: String -> Context String
siteCtx currentTitle =
    constField "siteTitle" "Ian Thomas White" `mappend`
    constField "title" currentTitle           `mappend`
    defaultContext
