// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Repository",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Repository",
            targets: ["Repository"]),
    ],
    dependencies: [
      .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.4.0"),
      .package(path: "../Domain")
    ],
    targets: [
        .target(
            name: "Repository",
            dependencies: [
                .product(name: "Domain", package: "Domain"),
                .product(name: "Dependencies", package: "swift-dependencies")
            ]
        ),
        .testTarget(
            name: "RepositoryTests",
            dependencies: ["Repository"]
        ),
    ]
)
