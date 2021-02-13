// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "Nakri",
  platforms: [
    .iOS(.v10)
  ],
  products: [
    .library(name: "Nakri", targets: ["Nakri"]),
  ],
  targets: [
    .target(name: "Nakri", path: "Sources"),
  ],
  swiftLanguageVersions: [
    .v5
  ]
)