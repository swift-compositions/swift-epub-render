public import BCP_47
public import ISO_8601
public import RFC_3987

extension EPUB {

    public enum Package {}
}

extension EPUB.Package {

    public struct Metadata: Sendable {
        public var identifier: String
        public var title: String
        public var language: BCP47.LanguageTag
        public var creators: [String]
        public var publisher: String?
        public var date: ISO_8601.CalendarDate.Reduced?
        public var description: String?
        public var subjects: [String]
        public var modified: ISO_8601.DateTime

        public init(
            identifier: String,
            title: String,
            language: BCP47.LanguageTag,
            creators: [String] = [],
            publisher: String? = nil,
            date: ISO_8601.CalendarDate.Reduced? = nil,
            description: String? = nil,
            subjects: [String] = [],
            modified: ISO_8601.DateTime
        ) {
            self.identifier = identifier
            self.title = title
            self.language = language
            self.creators = creators
            self.publisher = publisher
            self.date = date
            self.description = description
            self.subjects = subjects
            self.modified = modified
        }
    }

    public struct Item: Sendable {
        public var id: String
        public var href: RFC_3987.IRI.Reference
        public var media: String
        public var properties: [String]

        public init(id: String, href: RFC_3987.IRI.Reference, media: String, properties: [String] = []) {
            self.id = id
            self.href = href
            self.media = media
            self.properties = properties
        }
    }

    public enum Spine {}
}

extension EPUB.Package.Spine {

    public struct Item: Sendable {
        public var idref: String
        public var linear: Bool

        public init(idref: String, linear: Bool = true) {
            self.idref = idref
            self.linear = linear
        }
    }
}

extension EPUB.Package {

    /// EPUB 3 holds `dcterms:modified` to `CCYY-MM-DDThh:mm:ssZ`: UTC, in whole seconds.
    private static func modifiedText(_ value: ISO_8601.DateTime) -> String {
        let text = ISO_8601.DateTime.Formatter.format(value, timezone: .utc)
        guard let fraction = text.firstIndex(of: ".") else { return text }
        return String(text[..<fraction]) + "Z"
    }

    public static func xml(
        metadata: Metadata,
        manifest: [Item],
        spine: [Spine.Item]
    ) -> String {
        var xml = """
            <?xml version="1.0" encoding="UTF-8"?>
            <package xmlns="http://www.idpf.org/2007/opf" version="3.0" unique-identifier="pub-id">
              <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
                <dc:identifier id="pub-id">\(escapeXML(metadata.identifier))</dc:identifier>
                <dc:title>\(escapeXML(metadata.title))</dc:title>
                <dc:language>\(escapeXML(metadata.language.value))</dc:language>

            """

        for creator in metadata.creators {
            xml += "    <dc:creator>\(escapeXML(creator))</dc:creator>\n"
        }

        if let publisher = metadata.publisher {
            xml += "    <dc:publisher>\(escapeXML(publisher))</dc:publisher>\n"
        }

        if let date = metadata.date {
            xml += "    <dc:date>\(escapeXML(date.extended))</dc:date>\n"
        }

        if let description = metadata.description {
            xml += "    <dc:description>\(escapeXML(description))</dc:description>\n"
        }

        for subject in metadata.subjects {
            xml += "    <dc:subject>\(escapeXML(subject))</dc:subject>\n"
        }

        xml += "    <meta property=\"dcterms:modified\">\(modifiedText(metadata.modified))</meta>\n"
        xml += "  </metadata>\n"
        xml += "  <manifest>\n"

        for item in manifest {
            var props = ""
            if !item.properties.isEmpty {
                props = " properties=\"\(item.properties.joined(separator: " "))\""
            }
            xml +=
                "    <item id=\"\(escapeXML(item.id))\" href=\"\(escapeXML(item.href.value))\" media-type=\"\(escapeXML(item.media))\"\(props)/>\n"
        }

        xml += "  </manifest>\n"
        xml += "  <spine>\n"

        for item in spine {
            let linear = item.linear ? "" : " linear=\"no\""
            xml += "    <itemref idref=\"\(escapeXML(item.idref))\"\(linear)/>\n"
        }

        xml += "  </spine>\n"
        xml += "</package>\n"

        return xml
    }
}
