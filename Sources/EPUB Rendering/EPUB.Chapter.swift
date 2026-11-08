public import BCP_47
import Byte
public import HTML
public import HTML_Rendering_Core

extension EPUB {

    public enum Chapter {}
}

extension EPUB.Chapter {

    public struct Document<Content: HTML.View>: Sendable where Content: Sendable {

        public let title: String

        public let language: BCP47.LanguageTag

        public let stylesheets: [String]

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

        public func xhtml() -> String {

            let bodyBytes: [Byte] = [Byte](content)
            let bodyHTML = String(decoding: bodyBytes, as: UTF8.self)

            var stylesheetLinks = ""
            for stylesheet in stylesheets {
                stylesheetLinks +=
                    "  <link rel=\"stylesheet\" type=\"text/css\" href=\"\(escapeXML(stylesheet))\"/>\n"
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

extension EPUB.Chapter {

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
            xml +=
                "  <link rel=\"stylesheet\" type=\"text/css\" href=\"\(escapeXML(stylesheet))\"/>\n"
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
