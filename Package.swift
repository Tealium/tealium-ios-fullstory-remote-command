// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "TealiumFullstory",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "TealiumFullstory", targets: ["TealiumFullstory"]),
    ],
    dependencies: [
        .package(name: "TealiumSwift", url: "https://github.com/tealium/tealium-swift", .upToNextMajor(from: "2.7.0")),
        .package(name: "FullStory", url: "https://github.com/fullstorydev/fullstory-swift-package-ios", .upToNextMajor(from: "1.31.1"))
    ],
    targets: [
        .target(
            name: "TealiumAirship",
            dependencies: [
                .product(name: "Chartbeat", package: "Chartbeat"),
                .product(name: "TealiumCore", package: "TealiumSwift"),
                .product(name: "TealiumRemoteCommands", package: "TealiumSwift")
            ],
            path: "./Sources",
            exclude: ["Support"]
        ),
        .testTarget(
            name: "TealiumChartbeatTests",
            dependencies: ["TealiumChartbeat"],
            path: "./Tests",
            exclude: ["Support"])
    ]
)

