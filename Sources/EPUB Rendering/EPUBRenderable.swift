public import Byte
public import EPUB_Standard

extension EPUB {

    public enum Rendering {}
}

extension EPUB.Rendering {

    public struct Output: Sendable, Hashable {

        public var data: [Byte]

        public init(data: [Byte]) {
            self.data = data
        }
    }
}

extension EPUB.Rendering {

    public struct Context: Sendable {

        public var version: W3C_EPUB.Version

        public var ncx: Bool

        public var compression: Int

        public init(
            version: W3C_EPUB.Version = .v3_3,
            ncx: Bool = false,
            compression: Int = 6
        ) {
            self.version = version
            self.ncx = ncx
            self.compression = compression
        }
    }
}
