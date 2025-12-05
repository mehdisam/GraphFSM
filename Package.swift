// swift-tools-version:5.8
import PackageDescription

let package = Package(
    name: "GraphFSM",
    platforms: [.iOS(.v13), .macOS(.v10_15)],
    products: [
        .library(name: "GraphFSM", targets: ["GraphFSM"]),
    ],
    targets: [
        .target(name: "GraphFSM", path: "Sources/GraphFSM"),
        .testTarget(name: "GraphFSMTests", dependencies: ["GraphFSM"], path: "Tests/GraphFSM"),
    ]
)
