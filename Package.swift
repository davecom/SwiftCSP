// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "SwiftCSP",
    products: [
        .library(
            name: "SwiftCSP",
            targets: ["SwiftCSP"]),
        ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftCSP",
            dependencies: []),
        .testTarget(
            name: "SwiftCSPTests",
            dependencies: ["SwiftCSP"]),
        ]
)
