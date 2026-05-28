// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "appinio_social_share",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(name: "appinio-social-share", targets: ["appinio_social_share"])
  ],
  dependencies: [
    // Flutter is provided by the Flutter toolchain at build time and is not
    // declared here. The Facebook iOS SDK is pulled in via SwiftPM.
    .package(url: "https://github.com/facebook/facebook-ios-sdk.git", from: "18.0.0")
  ],
  targets: [
    .target(
      name: "appinio_social_share",
      dependencies: [
        .product(name: "FacebookCore", package: "facebook-ios-sdk"),
        .product(name: "FacebookShare", package: "facebook-ios-sdk")
      ]
    )
  ]
)
