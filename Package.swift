// swift-tools-version: 5.10

import PackageDescription

let package = Package(
	name: "darwin-relux",
	platforms: [
		.iOS(.v13),
		.macOS(.v10_15),
		.tvOS(.v13),
		.watchOS(.v6)
	],
	products: [
		.library(
			name: "Relux",
			targets: ["Relux"]
		),
	],
	dependencies:      [
		.package(url: "https://github.com/ivalx1s/darwin-logger.git", from: "1.0.0"),
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
