// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "RSocketSDK",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "RSocketSDK", targets: ["RSocketSDK"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "RSocketSDK",
            dependencies: [],
            path: "Sources/RSocketSDK"
        ),
        .testTarget(
            name: "RSocketSDKTests",
            dependencies: ["RSocketSDK"],
            path: "Tests/RSocketSDKTests"
        )
    ]
)
