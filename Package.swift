// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CP3_UI",
    platforms: [.iOS(.v13), .macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CP3_UI",
            targets: ["CP3_UI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CP3_UI",
            dependencies: [],
            resources: [.process("Resources")]),
        .testTarget(
            name: "CP3_UITests",
            dependencies: ["CP3_UI"])
    ]
)
