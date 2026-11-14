import SwiftUI
import HealthKit

// 一组测试数据:当天几点 + 走多少步
struct StepGroup: Identifiable {
    let id = UUID()
    var time: Date
    var steps: Int
}

/// 全局小工具:把"今天第 hour:minute"变成一个 Date
private func makeTime(hour: Int, minute: Int) -> Date {
    Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
}

// ============================================================
// Tab 3 · 数据实验:向自己的健康库写入多组测试步数。
// 调试场景:一天要造好几组数据、模拟不同时段的运动量 ——
// 在这里按组录入,一键写入,你的计数 App 读 HealthKit 即可测。
// 演示:@State 数组的增删改 / Form 表单 / async 任务编排。
// ============================================================
struct StepTesterView: View {
    @State private var authorized = false
    @State private var day = Date()
    @State private var groups: [StepGroup] = [
        StepGroup(time: makeTime(hour: 7, minute: 30), steps: 3000),   // 早上一组
        StepGroup(time: makeTime(hour: 12, minute: 0), steps: 5000),   // 中午一组
        StepGroup(time: makeTime(hour: 19, minute: 0), steps: 6000),   // 晚上一组
    ]
    @State private var totalSteps: Double = 0
    @State private var busy = false
    @State private var message: String?
    @State private var isError = false

    var body: some View {
        NavigationStack {
            Form {
                Section("HealthKit 状态") {
                    if HealthKitStore.shared.isAvailable {
                        Label(authorized ? "已授权,可读可写" : "未授权",
                              systemImage: authorized ? "checkmark.seal.fill" : "lock")
                            .foregroundStyle(authorized ? .green : .orange)
                        Button("申请读写授权") {
                            Task { await setup() }
                        }
                        .disabled(authorized)
                    } else {
                        Label("当前环境不支持 HealthKit", systemImage: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("写入日期") {
                    DatePicker("日期", selection: $day, displayedComponents: .date)
                }

                Section {
                    ForEach($groups) { $group in
                        HStack {
                            DatePicker("时刻", selection: $group.time,
                                       displayedComponents: .hourAndMinute)
                                .labelsHidden()
                            Spacer()
                            TextField("步数", value: $group.steps, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 90)
                            Button {
                                groups.removeAll { $0.id == group.id }
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                    Button {
                        groups.append(StepGroup(time: Date(), steps: 3000))
                    } label: {
                        Label("添加一组 +3000 步", systemImage: "plus")
                    }
                } header: {
                    Text("测试组(\(groups.count) 组)")
                } footer: {
                    Text("每组会在所选日期的对应时刻生成一条步数样本,写入的是你自己的健康库。")
                }

                Section {
                    Button {
                        Task { await writeGroups() }
                    } label: {
                        HStack {
                            if busy { ProgressView().padding(.trailing, 6) }
                            Label("写入 HealthKit(\(groups.reduce(0) { $0 + $1.steps }) 步)",
                                  systemImage: "square.and.arrow.down")
                        }
                    }
                    .disabled(busy || groups.isEmpty)
                }

                if let message {
                    Section {
                        Label(message, systemImage: isError ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                            .foregroundStyle(isError ? .red : .green)
                    }
                }
            }
            .navigationTitle("数据实验")
            .task { await setup() }
            .onChange(of: day) {
                Task { await readBack() }
            }
        }
    }

    // ── 任务编排:授权 → 读回 ──────────────────────────────
    private func setup() async {
        do {
            guard HealthKitStore.shared.isAvailable else { return }
            try await HealthKitStore.shared.requestAuthorization()
            authorized = HealthKitStore.shared.isAuthorized
            await readBack()
        } catch {
            setMessage("授权失败:\(error.localizedDescription)", isError: true)
        }
    }

    // ── 写入:逐组落库,再读回验证 ─────────────────────────
    private func writeGroups() async {
        busy = true
        defer { busy = false }
        do {
            let calendar = Calendar.current
            let dayStart = calendar.startOfDay(for: day)
            for group in groups {
                let minuteOfDay = calendar.dateComponents([.hour, .minute], from: group.time)
                let when = calendar.date(byAdding: .minute,
                                         value: (minuteOfDay.hour ?? 0) * 60 + (minuteOfDay.minute ?? 0),
                                         to: dayStart)!
                try await HealthKitStore.shared.writeSteps(Double(group.steps), at: when)
            }
            await readBack()
            setMessage("已写入 \(groups.count) 组样本,当日总步数 \(Int(totalSteps))", isError: false)
        } catch {
            setMessage("写入失败:\(error.localizedDescription)", isError: true)
        }
    }

    private func readBack() async {
        do {
            totalSteps = try await HealthKitStore.shared.steps(on: day)
        } catch {
            setMessage("读取失败:\(error.localizedDescription)", isError: true)
        }
    }

    private func setMessage(_ text: String, isError hasError: Bool) {
        message = text
        isError = hasError
    }
}
