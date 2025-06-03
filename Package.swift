// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    
    name: "SwifterSyntax",
    platforms: [.macOS(.v14), .iOS(.v17)]
    ,
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwifterSyntax",
            targets: ["SwifterSyntax"]),
    
    ],
    dependencies: [.package(url: "https://github.com/swiftlang/swift-syntax", .upToNextMajor(from: "601.0.1")),
                   .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.2.0")),
                  ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwifterSyntax"
            ,dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "OrderedCollections", package: "swift-collections"),
                           ]
        ),
        .testTarget(
            name: "SwifterSyntaxTests",
            dependencies: ["SwifterSyntax"]
        ),
    ]
)
