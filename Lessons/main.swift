// 练习课入口:每课自带 check() 自检,填完 TODO 跑一次就知道过没过。
//
//   运行方式:  swift run Lessons
//   全部 ✅ 后进入下一课(课程路线见 README.md)

import Foundation

var passed = 0
var failed = 0
var currentLesson = ""

/// 自检:通过打 ✅,失败打 ❌ 并提示位置
func check(_ condition: Bool, _ label: String) {
    if condition {
        passed += 1
        print("  ✅ \(label)")
    } else {
        failed += 1
        print("  ❌ \(label)  ← 回去把对应的 TODO 填了")
    }
}

func lesson(_ name: String, _ body: () -> Void) {
    currentLesson = name
    print("\n━━ \(name) ━━")
    body()
}

// 按顺序跑各课;写新课时在这里加一行
lesson("Lesson 1 · 变量、类型与控制流") { lesson01() }
lesson("Lesson 2 · 函数、闭包与集合") { lesson02() }

print("\n━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("结果: \(passed) 过 / \(failed) 未过")
if failed == 0 {
    print("🎉 全部通过!去 ios-app/ 写 SwiftUI,或继续下一课。")
} else {
    print("还有 \(failed) 个 TODO 等着你,改完再跑一遍。")
}
