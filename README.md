# 火山引擎实时音视频 SDK 的 Flutter 插件包

> 此 Flutter 插件是对 [火山引擎实时音视频 SDK](https://www.volcengine.com/product/veRTC) 的包装。

## 如何使用

为了使用此插件, 请添加 `volc_engine_rtc` 到您的 `pubspec.yaml` 文件中。

### 设备权限

火山引擎实时音视频 SDK 需要获取 `相机` 和 `麦克风` 权限来开始视频通话。

#### iOS

打开 `Info.plist` 文件并且添加：

- `Privacy - Microphone Usage Description`，并且在 `Value` 列中添加描述。
- `Privacy - Camera Usage Description`，并且在 `Value` 列中添加描述。

如果启用了后台模式，则应用程序在切换到后台时仍可以运行语音呼叫。在 Xcode 中选择应用目标，单击 **Capabilities** 选项卡，启用 **Background Modes**，然后选中 **Audio, AirPlay, and Picture in Picture**。

更改 `Podfile` 来设置 火山引擎实时音视频 SDK 的仓库源

```xml
source 'https://github.com/volcengine/volcengine-specs.git'
```

#### Android

VolcEngineRTC 已经声明了必要的权限，会合并到 `AndroidManifest.xml` 中。

## 相关资源

- 如果你想了解更多官方示例，可以参考 [官方 SDK 示例](https://github.com/volcengine/VolcEngineRTC)

## 代码许可

本项目遵守 [MIT license](https://github.com/volcengine/VolcEngineRTC_Flutter_SDK/blob/master/LICENSE) 。
