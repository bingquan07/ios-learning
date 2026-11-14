# iOS 学习实验室

没有 Mac 的 iOS 开发环境:**本机(Debian Linux)写代码 + GitHub Actions 的 macOS 机器云编译**,官方 iOS 模拟器跑起来后自动截图,截图在 Actions 页面下载查看。

## 双轨学习

```
本机(Linux)                        云端(macOS runner)
─────────────────                    ─────────────────
Lessons/  纯 Swift 语法练习           ios-app/  SwiftUI App
swift run Lessons  秒级反馈            git push → 编译+模拟器截图 ≈ 3~5 分钟
```

- **语法/算法练习**就在这台机器上写、立刻跑(Lesson 1、2 先做)
- **SwiftUI 界面**在 `ios-app/Sources/` 里改,push 后看云端截图

## 迭代循环(没有 Mac 的开发流)

1. 改 `ios-app/Sources/*.swift`
2. `git push`
3. GitHub → **Actions** → 最新一次运行 → Artifacts → 下载 `learnapp-<编号>` 里的 `screenshot.png`
4. 看图,回到第 1 步

编译错误会显示在 Actions 的 **Build** 步骤日志里,点开就能看到哪一行错了。

## 目录

```
Lessons/        纯 Swift 练习课(Linux 上可跑,自带 check 自检)
  Lesson01.swift   变量、类型、控制流、Optional
  Lesson02.swift   函数、闭包、map/filter/reduce、struct、protocol
  main.swift       练习入口,写新课时在这里注册
ios-app/
  project.yml      xcodegen 工程定义(.xcodeproj 由它生成,不入库)
  Sources/         SwiftUI 代码,主战场
.github/workflows/ios.yml   云编译管线
```

## 本地命令

```bash
swift run Lessons    # 跑练习课,全部 ✅ 才算过关
```

## 路线图

- [x] Lesson 1~2 就位(本机自检跑通,2026-11-13)
- [x] 首次云编译成功,模拟器截图验证(run #1,2026-11-13)
- [ ] 填完 Lesson 1~2 的 11 个 TODO(本机 `swift run Lessons` 全绿)
- [ ] 数据实验 tab:HealthKit 写入多组测试步数 + 读回验证
- [ ] 自己往 App 里加一个新页面(SwiftUI 布局)
- [ ] Lesson 3+:@Observable 状态管理 / 导航
- [ ] 做一个小项目(记账本 / 天气卡 / 计分板)
- [ ] 进阶:云真机 / 付费开发者账号 / TestFlight

## 关于测试数据(为什么用 HealthKit)

调试运动计数 App 需要反复造"一天的步数数据"。正路是往**自己的健康库**
写测试样本(HealthKit,苹果官方支持),你的 App 读 HealthKit 就能拿到
多组数据。"数据实验" tab 干的就是这件事;向第三方平台注入伪造数据
(模拟官方客户端、假设备 ID)不属于本仓库的做法,也不该出现在你的
产品里 —— 那类数据会真实落进对方的生产库并同步到下游排行/奖励系统。
