public import BCP_47
import Byte
public import HTML
public import HTML_Rendering_Core

extension EPUB {

    public enum Chapter {}
}

extension EPUB.Chapter {
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
