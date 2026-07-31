// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-epub-render",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(name: "EPUB Rendering", targets: ["EPUB Rendering"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-html.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-html-render.git", branch: "main"),
        .package(url: "https://github.com/swift-standards/swift-epub-standard.git", branch: "main"),
        .package(url: "https://github.com/swift-iso/swift-iso-21320.git", branch: "main"),
        .package(url: "https://github.com/swift-ietf/swift-bcp-47", from: "0.1.4"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.0"),
    ],
    targets: [
        .target(
            name: "EPUB Rendering",
            dependencies: [
                .product(name: "HTML", package: "swift-html"),
                .product(name: "HTML Rendering Core", package: "swift-html-render"),
                .product(name: "EPUB Standard", package: "swift-epub-standard"),
                .product(name: "ISO 21320", package: "swift-iso-21320"),
                .product(name: "BCP 47", package: "swift-bcp-47"),
            ]
        ),
        .testTarget(
            name: "EPUB Rendering Tests",
            dependencies: [
                "EPUB Rendering",
                .product(name: "InlineSnapshotTesting", package: "swift-snapshot-testing"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin].contains(target.type) {
    let existing = target.swiftSettings ?? []
    target.swiftSettings = existing + [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility")
    ]
}
