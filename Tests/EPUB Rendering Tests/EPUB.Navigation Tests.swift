import BCP_47
import RFC_3987
import Testing

@testable import EPUB_Rendering

enum `EPUB.Navigation Tests` {}

extension `EPUB.Navigation Tests` {
    @Suite
    struct `Navigation document` {

        @Test
        func `an empty item list is rejected`() throws {
            let language = try BCP47.LanguageTag("en")
            #expect(throws: EPUB.Navigation.Error.empty) {
                try EPUB.Navigation.xhtml(title: "Book", heading: "Contents", items: [], language: language)
            }
        }

        @Test
        func `the heading is the one given`() throws {
            let xhtml = try EPUB.Navigation.xhtml(
                title: "Boek",
                heading: "Inhoud",
                items: [.init(title: "Een", href: try RFC_3987.IRI.Reference("een.xhtml"))],
                language: try BCP47.LanguageTag("nl")
            )
            #expect(xhtml.contains("<h1>Inhoud</h1>"))
            #expect(!xhtml.contains("Table of Contents"))
            #expect(xhtml.contains("<ol>"))
        }
    }
}
