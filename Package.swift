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

	],
	targets: [
		.target(
			name: "Relux",
			dependencies:  [

			],
			path: "Sources"
		),
	]
)
