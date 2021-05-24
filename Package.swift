// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "libdav1d",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "libdav1d",
            targets: ["libdav1d"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .binaryTarget(
            name: "libdav1d",
            url: "https://github.com/link-u/libdav1d-static/releases/download/0.0.3/libdav1d.xcframework.zip",
            checksum: "8390757146ebb39ae89b121a55a0b038a7d9614e38a11f753b8effa5f48e66ca"
        )
    ],
    cLanguageStandard: .gnu11,
    cxxLanguageStandard: .gnucxx14
)
