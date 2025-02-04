// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FunctionCalling-AIProxySwift",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "FunctionCalling-AIProxySwift",
            targets: [
                "FunctionCalling-AIProxySwift"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/fumito-ito/FunctionCalling", from: "0.5.0"),
        .package(url: "https://github.com/lzell/AIProxySwift.git", from: "0.66.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "FunctionCalling-AIProxySwift",
            dependencies: [
                .product(name: "FunctionCalling", package: "FunctionCalling"),
                .product(name: "AIProxy", package: "AIProxySwift")
            ]),
        .testTarget(
            name: "FunctionCalling-AIProxySwiftTests",
            dependencies: [
                "FunctionCalling-AIProxySwift"
            ]
        )
    ]
)
