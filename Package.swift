// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "TealiumFullstory",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "TealiumFullstory", targets: ["TealiumFullstory"]),
    ],
    dependencies: [
        .package(name: "TealiumSwift", url: "https://github.com/tealium/tealium-swift", .upToNextMajor(from: "2.18.2")),
        .package(name: "FullStory", url: "https://github.com/fullstorydev/fullstory-swift-package-ios", .upToNextMajor(from: "1.68.3"))
    ],
    targets: [
        .target(
            name: "TealiumFullstory",
            dependencies: [
                .product(name: "FullStory", package: "FullStory"),
                .product(name: "TealiumCore", package: "TealiumSwift"),
                .product(name: "TealiumRemoteCommands", package: "TealiumSwift")
            ],
            path: "./Sources",
            exclude: ["Support"]
        ),
        .testTarget(
            name: "TealiumFullstoryTests",
            dependencies: ["TealiumFullstory"],
            path: "./Tests",
            exclude: ["Support"])
    ]
)

