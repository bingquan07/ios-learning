import SwiftUI

// ============================================================
// Tab 2 · 状态交互演示:计数器 + 待办清单。
// 演示:@State / TextField / Button / List 增删。
// ============================================================
struct StateDemoView: View {
    // @State:SwiftUI 的"记忆"。值一变,用到它的界面自动刷新。
    // 只在本视图内部使用的简单状态都用 @State。
    @State private var count = 0
    @State private var draft = ""                 // 输入框的草稿
    @State private var todos: [String] = ["跑通云编译", "写第一个 SwiftUI 页面"]

    var body: some View {
        NavigationStack {
            List {
                // ── 计数器:@State 最小示例 ──
                Section("计数器") {
                    HStack {
                        Button {
                            count -= 1            // 按钮的动作写在闭包里(复习 Lesson 2!)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.largeTitle)
                        }
                        // Spacer 把两侧内容推向两端
                        Spacer()
                        Text("\(count)")
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                            .monospacedDigit()
                        Spacer()
                        Button {
                            count += 1
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                        }
                    }
                    .buttonStyle(.borderless)     // 让 List 里的两个按钮各自独立响应
                }

                // ── 待办:输入 + 增删 ──
                Section("待办清单") {
                    HStack {
                        TextField("想做点什么?", text: $draft)
                            // $draft 把"绑定"传给输入框:输入框能写回 @State
                            .onSubmit(addTodo)    // 键盘回车 = 提交
                        Button("添加", action: addTodo)
                            .disabled(draft.trimmed.isEmpty)   // 空输入时禁用
                    }
                    ForEach(todos, id: \.self) { todo in
                        Label(todo, systemImage: "checkmark.circle")
                    }
                    .onDelete { offsets in        // 左滑删除
                        todos.remove(atOffsets: offsets)
                    }
                }

                Section {
                    Text("这个界面跑在 GitHub Actions 的 macOS 模拟器里 —— 你没有 Mac,但你的 App 有。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("练习")
        }
    }

    private func addTodo() {
        let text = draft.trimmed
        guard !text.isEmpty else { return }
        todos.append(text)
        draft = ""                                // 清空输入框
    }
}

// 小扩展:trim 掉空白。扩展(extension)可以给任何已有类型加方法。
private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
