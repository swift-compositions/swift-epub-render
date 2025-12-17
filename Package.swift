// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "swift-epub-rendering",
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
        .package(url: "https://github.com/coenttb/swift-renderable", from: "3.1.0"),
        .package(path: "../swift-html"),
        .package(path: "../swift-html-rendering"),
        .package(path: "../../swift-standards/swift-epub-standard"),
        .package(path: "../../swift-standards/swift-iso-21320"),
        .package(url: "https://github.com/swift-standards/swift-bcp-47", from: "0.1.4"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.18.0"),
    ],
    targets: [
        .target(
            name: "EPUB Rendering",
            dependencies: [
                .product(name: "Rendering", package: "swift-renderable"),
                .product(name: "HTML", package: "swift-html"),
                .product(name: "HTML Renderable", package: "swift-html-rendering"),
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
