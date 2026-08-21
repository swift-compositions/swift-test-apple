// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-test-apple",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [.library(name: "Test Apple", targets: ["Test Apple"])],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-test.git", branch: "testing-stack/neutral-test-boundary"),
        .package(url: "https://github.com/swift-primitives/swift-source-primitives.git", branch: "main"),
    ],
    targets: [
        .target(name: "Test Apple", dependencies: [
            .product(name: "Test", package: "swift-test"),
            .product(name: "Source Primitives", package: "swift-source-primitives"),
        ]),
        .testTarget(name: "Test Apple Tests", dependencies: [
            .target(name: "Test Apple"),
            .product(name: "Test", package: "swift-test"),
            .product(name: "Source Primitives", package: "swift-source-primitives"),
        ]),
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
