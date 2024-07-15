// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "darwin-relux",
	platforms: [
		.iOS(.v17),
		.macOS(.v14),
		.watchOS(.v10),
		.tvOS(.v17),
		.macCatalyst(.v17)
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
