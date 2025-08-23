// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "UsersSDK",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "UsersSDK", targets: ["UsersSDK"])
    ],
    dependencies: [
        .package(name: "CoreModelsSDK", path: "../CoreModelsSDK"), // <-- note the dot
        .package(name: "RSocketSDK",    path: "../RSocketSDK")     // <-- note the dot
    ],
    targets: [
        .target(
            name: "UsersSDK",
            dependencies: ["CoreModelsSDK", "RSocketSDK"],
            path: "Sources/UsersSDK"
        ),
        .testTarget(
            name: "UsersSDKTests",
            dependencies: ["UsersSDK"],
            path: "Tests/UsersSDKTests"
        )
    ]
)
