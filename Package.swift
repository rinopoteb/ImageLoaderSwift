// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImageLoader",
    platforms: [
          .iOS(.v10),
          .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "ImageLoader",
            targets: ["ImageLoader"]),
    ],
    targets: [
        .target(name: "ImageLoader", path: "ImageLoader")
    ],
    swiftLanguageVersions: [.v5]
)
