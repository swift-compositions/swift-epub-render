// EPUB.Chapter.swift
//
// Generates XHTML chapter documents for EPUB.

public import BCP_47
public import HTML
public import HTML_Renderable

extension EPUB {
    /// Chapter XHTML generator.
    public enum Chapter {}
}

// MARK: - Document

extension EPUB.Chapter {
    /// A chapter document for EPUB.
    ///
    /// This struct provides type-safe chapter construction with XHTML rendering
    /// suitable for EPUB 3.3.
    public struct Document<Content: HTML.View>: Sendable where Content: Sendable {
        /// The chapter title.
        public let title: String

        /// The language tag.
        public let language: BCP47.LanguageTag

        /// Stylesheet paths to include.
        public let stylesheets: [String]

        /// The chapter content.
        public let content: Content

        public init(
            title: String,
            language: BCP47.LanguageTag,
            stylesheets: [String] = [],
            @HTML.Builder content: () -> Content
        ) {
            self.title = title
            self.language = language
            self.stylesheets = stylesheets
            self.content = content()
        }

        /// Render this document to XHTML format suitable for EPUB.
        ///
        /// This method produces XHTML with XML declaration and proper namespace,
        /// as required by EPUB 3.3.
        ///
        /// - Returns: The XHTML content as a string
        public func xhtml() -> String {
            // Render body content
            let bodyBytes: [UInt8] = [UInt8](content)
            let bodyHTML = String(decoding: bodyBytes, as: UTF8.self)

            // Build stylesheet links
            var stylesheetLinks = ""
            for stylesheet in stylesheets {
                stylesheetLinks += "  <link rel=\"stylesheet\" type=\"text/css\" href=\"\(escapeXML(stylesheet))\"/>\n"
            }

            return """
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE html>
            <html xmlns="http://www.w3.org/1999/xhtml" lang="\(escapeXML(language.value))">
            <head>
              <meta charset="UTF-8"/>
              <title>\(escapeXML(title))</title>
            \(stylesheetLinks)</head>
            <body>
            \(bodyHTML)
            </body>
            </html>

            """
        }
    }
}

// MARK: - String-based (Compatibility)

extension EPUB.Chapter {
    /// Generate XHTML chapter document from string content.
    ///
    /// This is the compatibility approach for pre-rendered HTML strings.
    ///
    /// - Parameters:
    ///   - title: The chapter title
    ///   - body: The HTML body content (inner HTML)
    ///   - language: The language tag
    ///   - stylesheets: CSS stylesheet paths to include
    /// - Returns: The XHTML content as a string
    public static func xhtml(
        title: String,
        body: String,
        language: BCP47.LanguageTag,
        stylesheets: [String] = []
    ) -> String {
        var xml = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE html>
        <html xmlns="http://www.w3.org/1999/xhtml" lang="\(escapeXML(language.value))">
        <head>
          <meta charset="UTF-8"/>
          <title>\(escapeXML(title))</title>

        """

        for stylesheet in stylesheets {
            xml += "  <link rel=\"stylesheet\" type=\"text/css\" href=\"\(escapeXML(stylesheet))\"/>\n"
        }

        xml += """
        </head>
        <body>
        \(body)
        </body>
        </html>

        """

        return xml
    }
}
