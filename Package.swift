// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SimulatedAnnealing",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.0"),
        .package(name: "SwiftPlot", url: "https://github.com/KarthikRIyer/swiftplot.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "SimulatedAnnealing",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "SwiftPlot",
                .product(name: "AGGRenderer", package: "SwiftPlot")
            ]),
        .testTarget(
            name: "SimulatedAnnealingTests",
            dependencies: ["SimulatedAnnealing"]),
    ]
)
