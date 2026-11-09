extension EPUB.Navigation {

    /// A navigation document that EPUB forbids.
    public enum Error: Swift.Error, Sendable, Hashable {

        /// A `toc` nav needs an `ol` with at least one entry.
        case empty
    }
}
