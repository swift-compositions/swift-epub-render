// EPUB.Container.swift
//
// Generates META-INF/container.xml for EPUB OCF.

extension EPUB {
    /// Container XML generator for OCF.
    public enum Container {}
}

extension EPUB.Container {
    /// Generate container.xml content.
    ///
    /// - Parameter packagePath: Path to the package document (e.g., "EPUB/package.opf")
    /// - Returns: The container.xml content as a string
    public static func xml(packagePath: String) -> String {
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
          <rootfiles>
            <rootfile full-path="\(escapeXML(packagePath))" media-type="application/oebps-package+xml"/>
          </rootfiles>
        </container>
        """
    }
}
