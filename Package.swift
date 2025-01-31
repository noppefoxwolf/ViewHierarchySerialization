// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ViewHierarchySerialization",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ViewHierarchySerialization",
            targets: ["ViewHierarchySerialization"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ViewHierarchySerialization"),
        .testTarget(
            name: "ViewHierarchySerializationTests",
            dependencies: ["ViewHierarchySerialization"],
            resources: [
                .copy("Resources/_printHierarchy.txt")
            ]
        ),
    ]
)
