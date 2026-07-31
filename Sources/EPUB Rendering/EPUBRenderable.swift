// EPUBRenderable.swift
//
// Rendering protocol for EPUB documents.

public import EPUB_Standard

extension EPUB {
    /// Rendering types for EPUB.
    public enum Rendering {}
}

extension EPUB.Rendering {
    /// The output type for EPUB rendering.
    public struct Output: Sendable, Hashable {
        /// The rendered bytes (ZIP archive).
        public var data: [UInt8]

        public init(data: [UInt8]) {
            self.data = data
        }
    }
}

// MARK: - Context

extension EPUB.Rendering {
    /// Context for EPUB rendering operations.
    public struct Context: Sendable {
        /// The EPUB version to target.
        public var version: W3C_EPUB.Version

        /// Whether to include NCX for EPUB 2 compatibility.
        public var ncx: Bool

        /// Compression level (0-9).
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
