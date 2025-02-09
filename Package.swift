// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ViewHierarchySerialization",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "ViewHierarchySerialization",
            targets: ["ViewHierarchySerialization"]
        ),
    ],
    targets: [
        .target(
            name: "ViewHierarchySerialization"
        ),
        .testTarget(
            name: "ViewHierarchySerializationTests",
            dependencies: ["ViewHierarchySerialization"],
            resources: [
                .copy("Resources/_printHierarchy.txt"),
                .copy("Resources/_printHierarchy-append.txt"),
            ]
        ),
    ]
)
