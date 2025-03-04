// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "UXKit",
  platforms: [
    .macOS(.v10_13), .iOS(.v13), .tvOS(.v13)
  ],
  products: [
    .library(name: "UXKit", targets: ["UXKit"]),
  ],
  dependencies: [],
  targets: [
    .target(name:"UXKit")
  ]
)
