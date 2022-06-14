// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "darwin-perdux",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .watchOS(.v7),
        .tvOS(.v14),
        .macCatalyst(.v14)
    ],
    products: [
        .library(
            name: "Perdux",
            type: .dynamic,
            targets: ["Perdux"]
        ),
    ],
    dependencies: Package.remoteDependencies,
    targets: [
        .target(
            name: "Perdux",
            dependencies: Package.perduxDependencies
        ),
    ]
)


// MARK: -- Dependencies
extension Package {
    static var remoteDependencies: [Package.Dependency] {
        [
            .package(url: "git@github.com:ivalx1s/darwin-logger.git", from: "0.1.0"),
        ]
    }

    static var perduxDependencies: [Target.Dependency] {
        [
            .product(name: "Logger", package: "darwin-logger"),
        ]
    }
}
