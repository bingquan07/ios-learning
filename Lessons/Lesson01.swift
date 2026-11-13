// Lesson 1 · 变量、类型与控制流
// Swift 三条铁律:能用 let 就用 let;类型可以推断但要看得懂;switch 必须穷尽。

func lesson01() {
    // ── 1.1 let vs var ─────────────────────────────────────
    // let 不可变,var 可变。下面这行之后没人再改 greeting,
    // 所以应该用 let。TODO: 把 var 改成 let。
    // (改之前编译器会一直警告 "was never mutated" —— 它也在催你。)
    var greeting = "你好, Swift"
    check(greeting == "你好, Swift", "1.1 能用 let 就用 let")

    // ── 1.2 类型推断与标注 ──────────────────────────────────
    // Swift 会推断类型;显式标注用冒号。TODO: 把 0 改成正确答案。
    let answer: Int = 0          // 3 + 4 等于几?
    check(answer == 7, "1.2 类型与算术")

    // ── 1.3 字符串插值 ──────────────────────────────────────
    // \(表达式) 把值嵌进字符串。TODO: 把 0 改成正确的年龄
    // (2012 年出生的人,今年 2026 年几岁?)
    let age = 0
    let intro = "我今年 \(age) 岁,在学 Swift"
    check(intro == "我今年 14 岁,在学 Swift", "1.3 字符串插值")

    // ── 1.4 for 循环与区间 ──────────────────────────────────
    // 1...5 是闭区间,1..<5 是半开区间。TODO: 让 total 等于 1+2+3+4+5。
    var total = 0
    for i in 1...5 {
        total += i * 0           // ← 把这里改成累加 i
    }
    check(total == 15, "1.4 for 循环与区间")

    // ── 1.5 switch 穷尽 ─────────────────────────────────────
    // Swift 的 switch 必须覆盖所有情况(用 default 兜底)。
    // TODO: 补上 .green 的分支描述。
    enum TrafficLight { case red, yellow, green }
    let light = TrafficLight.green
    let meaning: String
    switch light {
    case .red: meaning = "停"
    case .yellow: meaning = "注意"
    case .green: meaning = ""    // ← TODO: 绿灯该填什么?
    }
    check(meaning == "行", "1.5 switch 穷尽")

    // ── 1.6 可选值 Optional ─────────────────────────────────
    // Int(String) 可能转换失败,所以返回 Int?(可选)。
    // nil 合并运算符 ?? 提供默认值。TODO: 让 doubled 等于 246。
    let text = "123"
    let n = Int(text)            // 类型是 Int?
    let doubled = (n ?? 0) * 0   // ← TODO: 用 n 的实际值乘 2
    check(doubled == 246, "1.6 Optional 与 nil 合并")
}
