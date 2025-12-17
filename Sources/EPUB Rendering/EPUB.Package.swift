// EPUB.Package.swift
//
// Generates content.opf (Package Document) for EPUB.

public import BCP_47

extension EPUB {
    /// Package document (OPF) generator.
    public enum Package {}
}

extension EPUB.Package {
    /// Metadata for the package document.
    public struct Metadata: Sendable {
        public var identifier: String
        public var title: String
        public var language: BCP47.LanguageTag
        public var creators: [String]
        public var publisher: String?
        public var date: String?
        public var description: String?
        public var subjects: [String]
        public var modified: String

        public init(
            identifier: String,
            title: String,
            language: BCP47.LanguageTag,
            creators: [String] = [],
            publisher: String? = nil,
            date: String? = nil,
            description: String? = nil,
            subjects: [String] = [],
            modified: String
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

    /// A manifest item.
    public struct Item: Sendable {
        public var id: String
        public var href: String
        public var media: String
        public var properties: [String]

        public init(id: String, href: String, media: String, properties: [String] = []) {
            self.id = id
            self.href = href
            self.media = media
            self.properties = properties
        }
    }

    /// Spine types.
    public enum Spine {}
}

extension EPUB.Package.Spine {
    /// A spine item reference.
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
    /// Generate package document (content.opf).
    ///
    /// - Parameters:
    ///   - metadata: The publication metadata
    ///   - manifest: The manifest items
    ///   - spine: The spine item references
    /// - Returns: The OPF content as a string
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
            xml += "    <dc:date>\(escapeXML(date))</dc:date>\n"
        }

        if let description = metadata.description {
            xml += "    <dc:description>\(escapeXML(description))</dc:description>\n"
        }

        for subject in metadata.subjects {
            xml += "    <dc:subject>\(escapeXML(subject))</dc:subject>\n"
        }

        xml += "    <meta property=\"dcterms:modified\">\(escapeXML(metadata.modified))</meta>\n"
        xml += "  </metadata>\n"
        xml += "  <manifest>\n"

        for item in manifest {
            var props = ""
            if !item.properties.isEmpty {
                props = " properties=\"\(item.properties.joined(separator: " "))\""
            }
            xml += "    <item id=\"\(escapeXML(item.id))\" href=\"\(escapeXML(item.href))\" media-type=\"\(escapeXML(item.media))\"\(props)/>\n"
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
