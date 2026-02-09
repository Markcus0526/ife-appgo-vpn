# AppGo Multi‑Platform VPN Client 🛡️🌐

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE) ![Platforms](https://img.shields.io/badge/Platforms-Android%20|%20iOS%20|%20macOS%20|%20Windows-brightgreen)

> Cross-platform VPN client suite (Android, iOS, macOS, Windows) integrating Shadowsocks-based engines, tun2socks and platform packet processors. This repo contains platform-specific apps, native engines, helper libraries and build files.

---

## 🚀 About
AppGo is a multi-platform VPN client and toolkit. It provides:
- A user-facing VPN client (Android/iOS/macOS/Windows) with UI, preferences, and purchase flow.
- A native VPN engine stack: Shadowsocks (shadowsocks-libev/Shadowsocks frameworks), tun2socks, redsocks and PacketProcessor frameworks for packet handling.
- DNS/ACL helpers (e.g., Overture) and platform integrations (Android VpnService, iOS PacketTunnel / NetworkExtension, macOS NetworkExtension, Windows service).

Why this matters:
- The project brings together cross-platform UI and robust native networking components to deliver reliable VPN/proxy functionality across major desktop and mobile platforms.

---

## 🖼️ Screenshot
<img src="ios/Share/Assets.xcassets/im_splash_1_en.imageset/im_splash_1_en.jpg" alt="AppGo splash" width="540">

---

## 📁 Project Structure (high level)
- /android — Android app (Kotlin), Gradle config, native libs (.so), plugin module  
  - android/mobile — Android application module (manifest, Kotlin sources, assets)
- /ios — iOS app (Swift/ObjC), frameworks in ios/Library, PacketTunnel provider
- /macos — macOS app (Swift/ObjC), NetworkExtension and helper libs
- /windows — Windows app (C#), service and helper binaries
- /android/plugin — plugin module for Android
- LICENSE — MIT license
- .gitignore — recommended ignores and generated files

Quick mapping:
- Android entry: android/mobile/src/main/java/com/appgo/appgopro/AppGoApplication.kt
- iOS entry: ios/AppGo/AppDelegate.swift
- macOS entry: macos/AppGo/AppDelegate.swift
- Windows entry: windows/Program.cs

---

## 🧰 Tech Stack & Key Components
- Languages: Kotlin (Android), Swift / Objective-C (iOS & macOS), C# (Windows), C for native tools.
- VPN / networking engines:
  - Shadowsocks (native libs and platform frameworks)
  - tun2socks (transparent SOCKS proxying)
  - redsocks (redirector)
  - PacketProcessor (iOS/macOS kernel-level/tunnel helpers)
  - Overture (DNS/ACL resolver)
- Libraries / frameworks:
  - iOS / macOS: Alamofire, CocoaAsyncSocket, CocoaLumberjack, Sentry
  - Android: Gradle/Kotlin tooling, JNI native libraries (.so)
  - Windows: .NET 4.5.1 (project targets), native helper executables packaged under windows/Data
- Build & packaging:
  - Android: Gradle wrapper (android/gradlew), Android SDK/NDK, Go (for parts)
  - iOS / macOS: Xcode projects and embedded frameworks (ios/Library, macos/Library)
  - Windows: Visual Studio / MSBuild (.sln and .csproj files)

---

## ⚙️ Quick Start — Build & Run (developer guide)

General note: this is a large multi-project repo. The steps below are the minimal developer quickstarts (focused on local dev builds). See platform-specific module READMEs (android/README.md) for deeper detail.

### Prerequisites (common)
- Git (repo has submodules in some forks; run git submodule update --init --recursive if needed)
- Ensure you have the platform toolchains installed for the target you intend to build.

---

### 📱 Android (Kotlin)
Requirements:
- JDK 1.8
- Android SDK (Build Tools 27+)
- Android NDK r16+ (optional if native code needs rebuild)
- Go (for some native toolchains) — set GOROOT_BOOTSTRAP if required

Build (from repository root):
1. Configure environment variables:
   - ANDROID_HOME=/path/to/android-sdk
   - optionally ANDROID_NDK_HOME=/path/to/android-ndk
   - GOROOT_BOOTSTRAP=/path/to/go
2. Build an APK (Gradle wrapper included):
   - cd android
   - ./gradlew assembleDebug
3. Install on device:
   - adb install -r mobile/build/outputs/apk/debug/mobile-debug.apk

Notes:
- Android manifest and components: android/mobile/src/main/AndroidManifest.xml
- Native libraries (.so) are under android/mobile/src/main/jniLibs/ for multiple ABIs.

---

### 🍎 iOS (Swift / Obj‑C)
Requirements:
- Xcode (matching iOS deployment target in project)
- CocoaPods / Carthage not required if frameworks are prebundled (ios/Library contains frameworks)

Build:
1. Open workspace/project:
   - Open ios/AppGo.xcworkspace or ios/AppGo.xcodeproj in Xcode.
2. Select a signing team and device, then build & run (⌘R).

Notes:
- Packet tunnel / VPN provider code in: ios/Share/Vpn and ios/Share/Vpn/PacketTunnelProvider.*
- App configuration: ios/AppGo/AppGo-Info.plist and ios/config.plist

---

### 🖥️ macOS
Requirements:
- Xcode
- Network Extension entitlements for VPN functionality

Build:
1. Open macos/AppGo.xcodeproj in Xcode.
2. Choose the App target or AppGoLauncher and run.

Notes:
- PacketProcessor/NetworkExtension integration resides in macos/Share/Vpn and macos/Library.

---

### 🪟 Windows (C#)
Requirements:
- Visual Studio (2015/2017/2019) with .NET Framework 4.5.1 or higher

Build:
1. Open windows/AppGo.sln in Visual Studio.
2. Restore NuGet packages and build the solution.
3. Run AppGo.exe from build output or install using the provided installer configuration.

Notes:
- The main entry is windows/Program.cs. The service helper is in windows/AppGoService.

---

## 🔧 Configuration & Runtime files
- Android: strings, configs and assets under android/mobile/src/main/res and android/mobile/src/main/assets (ACL lists, hosts, gfwlist, etc.).
- iOS/macOS: ios/AppGo/AppGo-Info.plist and ios/config.plist contain configuration, ATS exceptions, and URL schemes.
- Windows: windows/Data includes prebuilt native executables and drivers (tap drivers packaged as gz). Windows build references them under windows/Data.

Be careful when changing secrets/keys — some API keys/fabric keys appear in Info.plist and manifest metadata (check before public use or App Store submission).

---

## 🤝 Contributing
- Fork → branch → pull request.
- Keep changes per-platform under the relevant folder (android/, ios/, macos/, windows/).
- Code style:
  - Android: Kotlin + Gradle; follow idiomatic Kotlin and Android Studio lint rules.
  - iOS / macOS: Swift/ObjC; use Xcode's recommended style.
  - Windows: C# .NET conventions.
- Please run platform-specific linters/builds locally before PRs.
- If you add native binaries, include build steps or scripts to regenerate them.

---

## 📜 License
- This repository is licensed under the MIT License — see LICENSE.

---

## 🔭 Future Table (Roadmap)
| Priority | Area | Planned work | Notes |
|---:|---|---|---|
| 🔥 High | Stability | Harden VPN reconnection & error handling | Improve native engine restart logic across platforms |
| 🔷 Medium | Features | Per-app split tunneling & per-network profiles | Platform-specific implementation (Android VpnService, macOS NE) |
| 🟡 Low | UX | Redesign settings & onboarding | Multi-language strings already present |
| 🟢 Backlog | CI/Automation | Add cross-platform CI builds and tests | Automate Android Gradle, iOS unit tests and Windows builds |

---

## 💬 Quick links (dev)
- Android module: android/mobile
- iOS project: ios/AppGo.xcodeproj
- macOS project: macos/AppGo.xcodeproj
- Windows solution: windows/AppGo.sln
- Android README: android/README.md (contains additional Android build details)

---

If you want, I can:
- Expand any platform's Quick Start into a step‑by‑step tutorial (including provisioning, signing, and native binary rebuild).
- Generate CONTRIBUTING.md with PR template and commit message guidance.
- Produce a short architecture diagram or a CONTRIBUTOR checklist.

Thank you — happy hacking! ✨
