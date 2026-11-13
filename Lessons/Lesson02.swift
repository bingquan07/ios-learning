// Lesson 2 · 函数、闭包与集合
// SwiftUI 的界面里到处是闭包,这一课是写 UI 前最重要的一课。

func lesson02() {
    // ── 2.1 函数 ────────────────────────────────────────────
    // 参数名 _ 表示调用时不写标签。TODO: 实现 triple(三倍)。
    func triple(_ x: Int) -> Int {
        return 0                 // ← TODO
    }
    check(triple(3) == 9, "2.1 函数")

    // ── 2.2 闭包 ────────────────────────────────────────────
    // 闭包 = 可以当值传的函数块 { 参数 in 返回值 }。
    let add: (Int, Int) -> Int = { a, b in a + b }
    check(add(2, 3) == 5, "2.2 闭包基础(示例,已通过)")

    // TODO: 补全 upper,让字符串变大写。
    let upper: (String) -> String = { _ in "" }   // ← 提示:String.uppercased()
    check(upper("swift") == "SWIFT", "2.2 闭包")

    // ── 2.3 map / filter ────────────────────────────────────
    // map 逐个变换,filter 逐个筛选,$0 是闭包第一个参数的简写。
    let nums = [1, 2, 3, 4, 5, 6]
    let evens = nums.filter { $0 % 2 == 0 }
    check(evens == [2, 4, 6], "2.3 filter(示例,已通过)")

    // TODO: 用 map 得到每个数的平方。
    let squares = nums.map { $0 }                 // ← 改这里
    check(squares == [1, 4, 9, 16, 25, 36], "2.3 map")

    // ── 2.4 reduce ──────────────────────────────────────────
    // reduce 把集合折叠成一个值:reduce(初始值) { 累加规则 }。
    // TODO: 让 sum 等于 nums 所有数之和(21)。
    let sum = nums.reduce(0) { x, _ in x }        // ← 改这里(提示:$0 是累积值,$1 是当前元素)
    check(sum == 21, "2.4 reduce")

    // ── 2.5 结构体 struct ────────────────────────────────────
    // struct 是 Swift 最常用的建模工具(比 class 更常用)。
    struct Student {
        let name: String
        var score: Int
    }
    var stu = Student(name: "小明", score: 80)
    stu.score += 5

    // TODO: 再建一个"小红",分数 95,放进数组,找出最高分。
    let students = [stu]                          // ← 加入小红
    let best = students.map(\.score).max() ?? 0
    check(best == 95, "2.5 struct 与集合")

    // ── 2.6 协议 protocol ───────────────────────────────────
    // 协议 = 能力清单。ExpressibleByStringLiteral 是标准库协议,
    // 实现 init(stringLiteral:) 就能让自定义类型直接用字符串字面量创建。
    protocol Greetable { func greet() -> String }
    struct Cat: Greetable {
        let name: String
        func greet() -> String { "喵,我是\(name)" }
    }
    // TODO: 写一个 Dog 也遵守 Greetable,叫"汪,我是名字"。
    let animals: [Greetable] = [Cat(name: "咪")]
    let greetings = animals.map { $0.greet() }
    check(greetings == ["喵,我是咪", "汪,我是旺"], "2.6 协议")
}
