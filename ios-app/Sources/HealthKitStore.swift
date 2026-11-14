import Foundation
import HealthKit

// ============================================================
// HealthKit 封装:授权 / 写步数样本 / 读当日步数。
//
// 为什么这是正路:苹果官方支持 App 向"自己的健康库"写入样本
// (文档:Saving data to HealthKit),调试期写入测试数据、
// 换真机后删除即可。这和"往第三方平台注入伪造数据"是两回事。
// ============================================================
struct HealthKitStore {
    static let shared = HealthKitStore()
    private let store = HKHealthStore()

    static let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount)!

    /// 模拟器和真机都支持;其它环境(如扩展外)为 false
    var isAvailable: Bool { HKHealthStore.isHealthDataAvailable() }

    var isAuthorized: Bool {
        guard isAvailable else { return false }
        return store.authorizationStatus(for: Self.stepCount) == .sharingAuthorized
    }

    /// 弹出系统授权弹窗(读、写都要)
    func requestAuthorization() async throws {
        guard isAvailable else { throw HKError.notAvailable }
        try await store.requestAuthorization(toShare: [Self.stepCount], read: [Self.stepCount])
    }

    /// 写入一条步数样本(某个时刻走了多少步)
    func writeSteps(_ steps: Double, at date: Date) async throws {
        let quantity = HKQuantity(unit: .count(), doubleValue: steps)
        let sample = HKQuantitySample(
            type: Self.stepCount,
            quantity: quantity,
            start: date,
            end: date
        )
        try await store.save(sample)
    }

    /// 读取某一天的步数总和(HKStatisticsQuery 做累加)
    func steps(on day: Date) async throws -> Double {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: day)
        let end = start.addingTimeInterval(60 * 60 * 24)
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: Self.stepCount,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, statistics, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                let sum = statistics?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                continuation.resume(returning: sum)
            }
            store.execute(query)
        }
    }

    enum HKError: LocalizedError {
        case notAvailable
        case notAuthorized

        var errorDescription: String? {
            switch self {
            case .notAvailable: "当前环境不支持 HealthKit(需要真机或模拟器)"
            case .notAuthorized: "尚未获得 HealthKit 读写授权"
            }
        }
    }
}
