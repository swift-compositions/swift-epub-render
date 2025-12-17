// EPUB.Navigation.swift
//
// Generates nav.xhtml (Navigation Document) for EPUB.

public import BCP_47

extension EPUB {
    /// Navigation document generator.
    public enum Navigation {}
}

extension EPUB.Navigation {
    /// A navigation item (table of contents entry).
    public struct Item: Sendable {
        public var title: String
        public var href: String
        public var children: [Item]

        public init(title: String, href: String, children: [Item] = []) {
            self.title = title
            self.href = href
            self.children = children
        }
    }

    /// Generate navigation document (nav.xhtml).
    ///
    /// - Parameters:
    ///   - title: The document title
    ///   - items: The table of contents items
    ///   - language: The language tag
    /// - Returns: The nav.xhtml content as a string
    public static func xhtml(
        title: String,
        items: [Item],
        language: BCP47.LanguageTag
    ) -> String {
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
            <h1>Table of Contents</h1>

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
            xml += "\(spaces)    <a href=\"\(escapeXML(item.href))\">\(escapeXML(item.title))</a>\n"
            if !item.children.isEmpty {
                xml += renderList(item.children, indent: indent + 4)
            }
            xml += "\(spaces)  </li>\n"
        }

        xml += "\(spaces)</ol>\n"
        return xml
    }
}
