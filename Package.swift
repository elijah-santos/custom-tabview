// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "custom-tabview",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(
            name: "CustomTabView",
            targets: ["CustomTabView"]
        ),
    ],
    targets: [
        .target(
            name: "CustomTabView"
        ),

    ]
)
