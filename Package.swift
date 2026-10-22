// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MovixTV",
    platforms: [
        .tvOS(.v17)
    ],
    products: [
        .executable(
            name: "MovixTV",
            targets: ["MovixTV"]
        ),
    ],
    targets: [
        .executableTarget(
            name: "MovixTV",
            path: "."
        )
    ]
)