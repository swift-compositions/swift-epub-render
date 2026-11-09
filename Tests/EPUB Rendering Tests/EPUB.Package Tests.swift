import BCP_47
import ISO_8601
import RFC_3987
import Testing

@testable import EPUB_Rendering

enum `EPUB.Package Tests` {}

extension `EPUB.Package Tests` {
    @Suite
    struct `Package document` {

        static func metadata() throws -> EPUB.Package.Metadata {
            EPUB.Package.Metadata(
                identifier: "urn:uuid:example",
                title: "Example",
                language: try BCP47.LanguageTag("en"),
                modified: try ISO_8601.DateTime(year: 2025, month: 1, day: 2)
            )
        }

        @Test
        func `manifest properties are escaped`() throws {
            let item = EPUB.Package.Item(
                id: "nav",
                href: try RFC_3987.IRI.Reference("nav.xhtml"),
                media: "application/xhtml+xml",
                properties: ["nav", "a\"b<c"]
            )
            let xml = try EPUB.Package.xml(metadata: try Self.metadata(), manifest: [item], spine: [])
            #expect(xml.contains("properties=\"nav a&quot;b&lt;c\""))
        }

        @Test
        func `a spine idref without a manifest item is rejected`() throws {
            let item = EPUB.Package.Item(
                id: "chapter1",
                href: try RFC_3987.IRI.Reference("chapter1.xhtml"),
                media: "application/xhtml+xml"
            )
            let metadata = try Self.metadata()
            #expect(throws: EPUB.Package.Error.unknownSpineItem(idref: "chapter2")) {
                try EPUB.Package.xml(
                    metadata: metadata,
                    manifest: [item],
                    spine: [.init(idref: "chapter1"), .init(idref: "chapter2")]
                )
            }
        }

        @Test
        func `a spine idref naming a manifest item is written`() throws {
            let item = EPUB.Package.Item(
                id: "chapter1",
                href: try RFC_3987.IRI.Reference("chapter1.xhtml"),
                media: "application/xhtml+xml"
            )
            let xml = try EPUB.Package.xml(
                metadata: try Self.metadata(),
                manifest: [item],
                spine: [.init(idref: "chapter1")]
            )
            #expect(xml.contains("<itemref idref=\"chapter1\"/>"))
        }
    }
}
