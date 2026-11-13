import SwiftUI

// ============================================================
// App 入口。
// @main 标记程序从哪里启动;App 协议描述"一个 App 是什么";
// WindowGroup 是 iOS 的主窗口场景,body 返回你界面的根视图。
// ============================================================
@main
struct LearnApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

// 底部 Tab 导航:SwiftUI 用 TabView 管理多个平级页面。
// 每个 Tab 有自己的标签和图标(SF Symbols 图标库)。
struct RootView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("学习", systemImage: "book.fill") }
            StateDemoView()
                .tabItem { Label("练习", systemImage: "square.and.pencil") }
        }
    }
}

// ============================================================
// Tab 1 · 学习路线。
// 演示:List / ForEach / VStack / 字体 / 颜色 / 圆角卡片。
// ============================================================
struct HomeView: View {
    // 路线数据:写 App 就是"数据 → 视图"的映射,先定义数据长什么样
    private let roadmap: [(phase: String, items: [String], icon: String)] = [
        ("第 1 阶段 · Swift 语法", ["变量与类型", "函数与闭包", "struct / class / protocol"], "1.circle"),
        ("第 2 阶段 · SwiftUI 组件", ["Stack 布局", "List 与导航", "表单与交互"], "2.circle"),
        ("第 3 阶段 · 状态管理", ["@State / @Binding", "@Observable", "数据流"], "3.circle"),
        ("第 4 阶段 · 做个小项目", ["网络请求", "本地存储", "上架 TestFlight"], "flag.checkered"),
    ]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    // HStack 横向排列,VStack 纵向;间距用 spacing 控制
                    HStack(spacing: 12) {
                        Image(systemName: "sparkles")
                            .font(.title2)
                            .foregroundStyle(.yellow)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("iOS 学习实验室")
                                .font(.headline)
                            Text("改代码 → git push → 云端真模拟器截图")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                // ForEach:把数组变成一串视图 —— SwiftUI 的核心思路
                ForEach(roadmap, id: \.phase) { phase in
                    Section(phase.phase) {
                        ForEach(phase.items, id: \.self) { item in
                            Label(item, systemImage: phase.icon)
                        }
                    }
                }
            }
            .navigationTitle("路线")
        }
    }
}
