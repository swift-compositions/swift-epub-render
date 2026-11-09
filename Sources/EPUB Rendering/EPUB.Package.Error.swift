extension EPUB.Package {

    /// A package document that EPUB forbids.
    public enum Error: Swift.Error, Sendable, Hashable {

        /// A spine `itemref` whose `idref` names no manifest item.
        case unknownSpineItem(idref: String)
    }
}
