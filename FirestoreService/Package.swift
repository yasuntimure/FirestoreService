// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "FirestoreService",
    platforms: [ .iOS(.v15) ],
    products: [
        .library(
            name: "FirestoreService",
            targets: ["FirestoreService"]),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.15.0"))
    ],
    targets: [
        .target(
            name: "FirestoreService",
            dependencies: [
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ]
        ),
        .testTarget(
            name: "FirestoreServiceTests",
            dependencies: ["FirestoreService"]
        ),
    ]
)
