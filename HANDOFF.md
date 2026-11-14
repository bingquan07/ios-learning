# ios-learning 交接文档

- **交接日期**:2026-11-14
- **交接人**:ZCode 会话(环境搭建 + 云编译管线 + HealthKit 功能)
- **接手人**:接手的开发者或 AI Agent(下称"接手方")
- **仓库**:https://github.com/bingquan07/ios-learning(public,main)
- **机器**:Debian 13 amd64,无 Mac、无 GPU、~7G 内存,/home 剩余约 20G,sudo 需密码

> 接手方按 §3 验证环境、按 §6 领任务、按 §7 避坑即可开工,无需向交接人求证。

## 1. 项目是什么

一套**没有 Mac 的 iOS 开发/学习闭环**,已全部跑通:

- 本机写 Swift/SwiftUI → push → GitHub Actions 的 macOS runner 编译 → 官方 iOS 模拟器运行 → 自动截图 → 下载截图看效果(每次 3~6 分钟)
- 本地另有纯 Swift 练习课(Lessons),秒级反馈
- 第二轨 Flutter SDK 已装好未启用(见 T2)

红线(项目约束,接手方必须遵守):**测试数据只走 HealthKit 写入自己的健康库(§5.3);不向华米/Zepp 等第三方平台注入伪造数据、不模拟官方客户端、不做风控规避。** 此方向已明确拒绝两次,勿再提出。

## 2. 现状快照(交接时点)

- 本地 main = 远端 main(HEAD 含交付文档提交),工作区干净
- 已验证的云编译:
  - Run [#1](https://github.com/bingquan07/ios-learning/actions/runs/43444203967) ✅ 初始骨架,截图 `docs/screenshots/run1-home.png`
  - Run [#2](https://github.com/bingquan07/ios-learning/actions/runs/43552269068) ✅ HealthKit 功能,截图 `docs/screenshots/run2-healthkit.png`(Tab 栏第三项「数据实验」已出现)
- 本地练习课:`swift run Lessons` 跑通,3 过 / 11 个 TODO 待填(这是留给用户本人做的练习,**不要替用户填**)

## 3. 环境清单(接手后先逐条验证)

| 工具 | 路径 | 验证命令 |
|------|------|----------|
| Swift 6.4.2(Debian13 官方包) | `~/swift/usr/bin/`(PATH 已入 `~/.bashrc`) | `swift --version` |
| Flutter 3.50.0 stable | `~/flutter/`(未入 PATH) | `~/flutter/bin/flutter --version` |
| gh CLI 2.104.0 | `~/.local/bin/gh` | `gh auth status` |
| git | 系统自带,user.name/email 已配,credential helper 已接 gh | `git config --global -l` |
| 学习仓库 | `~/……/ios-learning/`(workspace 下) | `git -C ios-learning status` |

预期 `gh auth status`:账号 **bingquan07**,token 在系统 keyring,scopes `repo, workflow, read:org`。若失效,用 `gh auth login` 设备流重新授权(交互由用户完成)。

## 4. 仓库地图

```
Lessons/            纯 Swift 练习课(main.swift 注册课程,自检框架在 main.swift)
ios-app/
  project.yml       xcodegen 工程定义(.xcodeproj 不入库,CI 现场生成)
  Sources/
    LearnApp.swift      @main + TabView 三个 Tab
    StateDemoView.swift 「练习」Tab:@State/列表增删
    HealthKitStore.swift    HealthKit 封装(授权/写样本/日汇总查询)
    StepTesterView.swift    「数据实验」Tab:多组测试步数写入
.github/workflows/ios.yml   云编译管线(macos-15 + xcodegen + simctl 截图)
docs/screenshots/   云编译截图存档(artifact 14 天过期,重要截图入此处)
DELIVERY.md→本文件  交接文档
```

## 5. 日常操作手册

### 5.1 语法练习(本机,秒级)

```bash
cd <仓库路径> && swift run Lessons
```

### 5.2 UI 迭代(云端,3~6 分钟/轮)

```bash
git push                                    # 触发(限 ios-app/** 变更)
gh run list -R bingquan07/ios-learning -L 3  # 看队列
gh run watch <runId> -R bingquan07/ios-learning --exit-status --interval 15
gh run download <runId> -R bingquan07/ios-learning -n learnapp-<n> -D <目录>
```

编译报错看 Actions 里 **Build** 步骤日志(有行号)。

### 5.3 HealthKit 测试数据(App 内操作)

App 第三个 Tab「数据实验」:授权 → 按组录"时刻+步数"(默认 07:30/3000、12:00/5000、19:00/6000,可增删)→ 选日期 → 写入 → 自动读回当日总步数验证。模拟器与真机均支持;写入的是用户自己的健康库。

## 6. 待办任务(按优先级,含验收标准)

| # | 任务 | 验收标准 |
|---|------|----------|
| T1 | Flutter 线启动:`~/flutter/bin/flutter create stepmate`(或用户命名),加入版本管理,禁用 flutter 自动更新检查(`flutter config --no-analytics`) | 项目可 `flutter analyze` 零 error |
| T2 | Flutter 预览方案定型:优先真机(USB + adb,免 sudo 配 udev 规则),备选云 CI(Android emulator runner 免费但慢) | 一条命令能在预览端看到 Demo 页 |
| T3 | Lesson 3 编写:@Observable 状态管理(仿 Lesson01/02 格式,含自检点) | 新课本地跑通,示例项全绿、TODO 数个 |
| T4 | 「数据实验」交互验证:在模拟器上走一遍写入/读回(可在工作流加临时步骤或让用户本地有条件时做) | 写入后读回总数 = 各组之和 |
| T5 | 可选:工作流加 XCUITest 步骤,自动点 Tab 并截「数据实验」页 | run 内出现该页截图 |
| T6 | 可选:真实计步器小项目(CMPedometer/HealthKit 读取 + Swift Charts) | App 显示当日真实步数曲线 |

注意:T1/T2 需要 Java(Android 构建链),本机未装,`sudo apt install openjdk-17-jdk` 需用户输密码。

## 7. 坑清单(必读)

1. **push TLS 抖动**:`GnuTLS recv error (-110)` 偶发,直接重试即可;已配 `http.version=HTTP/1.1`
2. **macOS runner 容量排队**:启动可能等几分钟,属正常;工作流已配 concurrency 取消旧排队
3. **artifact 14 天过期**:重要截图复制进 `docs/screenshots/` 入库
4. **本机永远没有 iOS 模拟器**:UI 只能云端看,不要尝试本地装 Xcode 类工具
5. **磁盘紧张**:/home 剩约 20G;装 Android SDK 前先 `df -h` 并清理下载缓存
6. **内存紧张**:Android 模拟器勉强,优先真机 adb 预览
7. **HF/部分外网受限**:HuggingFace 需 `HF_ENDPOINT=https://hf-mirror.com`;github 主域可用但偶发抖动
8. **HealthKit 红线**:见 §1,测试数据只写自己的健康库
9. **练习课是用户的学习材料**:T3 只新增课程,不代填现有 11 个 TODO

## 8. 交接验收清单

- [ ] `swift --version` 输出 6.4.2
- [ ] `gh auth status` 显示 bingquan07 已登录
- [ ] `swift run Lessons` 输出 3 过 / 11 未过(TODO 未被代填)
- [ ] `git -C ios-learning status` 干净,远端 main 可达
- [ ] 手动触发一次 `workflow_dispatch` 云编译成功
