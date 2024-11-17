// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RestNetworking",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RestNetworking",
            targets: ["RestNetworking"]),
    ],
    dependencies: [
        .package(name: "CommonCore", path: "../CommonCore"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMinor(from: "5.5.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RestNetworking",
            dependencies: ["CommonCore", "Alamofire"]),
        .testTarget(
            name: "RestNetworkingTests",
            dependencies: ["RestNetworking"]
        ),
    ]
)
