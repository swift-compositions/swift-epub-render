import Testing

@testable import EPUB_Rendering

@Suite("EPUB Rendering Tests")
struct EPUB_Rendering_Tests {
    @Test("Rendering context defaults")
    func renderingContextDefaults() {
        let context = EPUB.Rendering.Context()
        #expect(context.version == .v3_3)
        #expect(context.ncx == false)
        #expect(context.compression == 6)
    }

    @Test("EPUB output")
    func epubOutput() {
        let output = EPUB.Rendering.Output(data: [0x50, 0x4B, 0x03, 0x04])
        #expect(output.data.count == 4)
    }
}
