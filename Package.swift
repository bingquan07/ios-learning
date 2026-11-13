// swift-tools-version:5.9
// 本地 Swift 练习:在这台 Linux 机器上用 `swift run Lessons` 运行
import PackageDescription

let package = Package(
    name: "Lessons",
    targets: [
        .executableTarget(
            name: "Lessons",
            path: "Lessons"
        )
    ]
)
