public import BCP_47
import Byte
public import HTML
public import HTML_Rendering_Core


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
    }
}
