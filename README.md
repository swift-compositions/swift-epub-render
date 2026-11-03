# swift-epub-render

Use this package when you need the text of the files inside an EPUB 3 publication: the container document (`EPUB.Container`), the package document with its metadata, manifest and spine (`EPUB.Package`), the navigation document (`EPUB.Navigation`), and chapter content documents, either from an HTML view (`EPUB.Chapter.Document`) or from a ready-made body string (`EPUB.Chapter`). Every renderer returns a `Swift.String`; zipping those files into an `.epub` archive is left to the caller. For the EPUB specification's own model, use swift-epub-standard (re-exported here as `W3C_EPUB`).

## Laws

- Every caller-supplied string written into element text or an attribute is XML-escaped (`&`, `<`, `>`, `"`, `'`), with three exceptions that are written verbatim: the `body` string given to `EPUB.Chapter.xhtml`, the rendered content of `EPUB.Chapter.Document`, and the `properties` of an `EPUB.Package.Item`, which are joined with single spaces.
- The package document always declares version `3.0` and always names `pub-id` as its unique identifier, which is the id given to the `dc:identifier` element.
- Metadata elements appear in a fixed order: identifier, title, language, creators, publisher, date, description, subjects, then `dcterms:modified`. Optional values that are `nil` and empty lists produce no element. Creators, subjects, manifest items and spine items keep the order of their arrays.
- An `EPUB.Package.Spine.Item` that is linear writes no `linear` attribute; one that is not writes `linear="no"`.
- No cross-file consistency is checked: spine idrefs are not matched against manifest ids, the navigation document's nav property is not added to the manifest for you, and stylesheet and navigation hrefs are not resolved.
- The navigation document always titles its table of contents "Table of Contents", whatever the language. Each `EPUB.Navigation.Item` becomes a list item whose children form a nested ordered list; an item without children has no nested list, and an empty item list produces no list at all.
- The container document names exactly one rootfile, with media type `application/oebps-package+xml`.
- `EPUB.iso8601Date` always writes UTC with a trailing `Z`, zero-pads the year to four digits and the other fields to two, and does not check that the date exists.
