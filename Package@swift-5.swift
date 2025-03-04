// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "UXKit",
    platforms: [
        .macOS(.v10_13), .iOS(.v12), .tvOS(.v12)
    ],
    products: [
        .library(name: "UXKit", targets: ["UXKit"]),
    ],
    dependencies: [],
    targets: [
        .target(name:"UXKit")
    ]
)
