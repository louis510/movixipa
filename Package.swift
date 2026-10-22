// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MovixTV",
    platforms: [
        .tvOS(.v17)
    ],
    products: [
        .library(
            name: "MovixTV",
            targets: ["MovixTV"]
        ),
    ],
    targets: [
        .target(
            name: "MovixTV",
            path: "."
        )
    ]
)