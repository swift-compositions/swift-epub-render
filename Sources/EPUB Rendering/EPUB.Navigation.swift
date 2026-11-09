public import BCP_47
public import RFC_3987

extension EPUB {

    public enum Navigation {}
}

extension EPUB.Navigation {

    public struct Item: Sendable {
        public var title: String
        public var href: RFC_3987.IRI.Reference
        public var children: [Item]

        public init(title: String, href: RFC_3987.IRI.Reference, children: [Item] = []) {
            self.title = title
            self.href = href
            self.children = children
        }
    }

    /// Throws ``Error/empty`` when `items` is empty: EPUB requires the `toc`
    /// nav's list to hold at least one entry.
    public static func xhtml(
        title: String,
        heading: String,
        items: [Item],
        language: BCP47.LanguageTag
    ) throws(EPUB.Navigation.Error) -> String {
        guard !items.isEmpty else { throw .empty }

        var xml = """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE html>
            <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" lang="\(escapeXML(language.value))">
            <head>
              <meta charset="UTF-8"/>
              <title>\(escapeXML(title))</title>
            </head>
            <body>
              <nav epub:type="toc" id="toc">
                <h1>\(escapeXML(heading))</h1>

            """

        xml += renderList(items, indent: 4)

        xml += """
              </nav>
            </body>
            </html>

            """

        return xml
    }

    private static func renderList(_ items: [Item], indent: Int) -> String {
        guard !items.isEmpty else { return "" }

        let spaces = String(repeating: " ", count: indent)
        var xml = "\(spaces)<ol>\n"

        for item in items {
            xml += "\(spaces)  <li>\n"
            xml += "\(spaces)    <a href=\"\(escapeXML(item.href.value))\">\(escapeXML(item.title))</a>\n"
            if !item.children.isEmpty {
                xml += renderList(item.children, indent: indent + 4)
            }
            xml += "\(spaces)  </li>\n"
        }

        xml += "\(spaces)</ol>\n"
        return xml
    }
}
