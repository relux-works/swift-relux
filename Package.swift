// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "darwin-relux",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .watchOS(.v7),
        .tvOS(.v14),
        .macCatalyst(.v14)
    ],
    products: [
        .library(
            name: "Relux",
            targets: ["Relux"]
        ),
    ],
    dependencies:      [
        .package(url: "https://github.com/ivalx1s/darwin-logger.git", from: "0.5.2"),
    ],
    targets: [
        .target(
            name: "Relux",
            dependencies:  [
                .product(name: "Logger", package: "darwin-logger"),
            ],
            path: "Sources"
        ),
    ]
)
