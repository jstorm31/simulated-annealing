// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SimulatedAnnealing",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.0"),
    ],
    targets: [
        .target(
            name: "SimulatedAnnealing",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "SimulatedAnnealingTests",
            dependencies: ["SimulatedAnnealing"]),
    ]
)
