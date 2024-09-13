// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WalletsUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "WalletsUI",
            targets: ["WalletsUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.15.0"),
        .package(path: "../Domain"),
        .package(path: "../Repository")
    ],
    targets: [
        .target(
            name: "WalletsUI",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "Repository", package: "Repository"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "WalletsUITests",
            dependencies: ["WalletsUI"]
        ),
    ]
)
