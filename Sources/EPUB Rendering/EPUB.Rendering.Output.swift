public import Byte
public import EPUB_Standard


extension EPUB.Rendering {
    public struct Output: Sendable, Hashable {

        public var data: [Byte]

        public init(data: [Byte]) {
            self.data = data
        }
    }
}
