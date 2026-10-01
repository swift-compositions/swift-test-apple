// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-test-apple",
    platforms: [
        .macOS(
            .v27
        ),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27)
    ],
    products: [.library(name: "Test Apple", targets: ["Test Apple"])],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-test.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-source.git",
            branch: "main"
        ),
        .package(url: "https://github.com/swift-atoms/swift-text.git", branch: "main", traits: ["Byte"]),
        .package(url: "https://github.com/swift-atoms/swift-tagged.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-cardinal.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-byte.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Test Apple",
            dependencies: [
                .product(name: "Test", package: "swift-test"),
                .product(name: "Source", package: "swift-source"),
                .product(name: "Text", package: "swift-text"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Byte", package: "swift-byte"),
            ]
        ),
        .testTarget(
            name: "Test Apple Tests",
            dependencies: [
                .target(name: "Test Apple"),
                .product(
                    name: "Test",
                    package: "swift-test"
                ),
                .product(
                    name: "Source",
                    package: "swift-source"
                ),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(), .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"), .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"), .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"), .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"), .enableUpcomingFeature("LifetimeDependence"),
    ]
}
