public import RFC_3987

extension EPUB {

    public enum Container {}
}

extension EPUB.Container {

    public static func xml(packagePath: RFC_3987.IRI.Reference) -> String {
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
          <rootfiles>
            <rootfile full-path="\(escapeXML(packagePath.value))" media-type="application/oebps-package+xml"/>
          </rootfiles>
        </container>
        """
    }
}
