# VolcEngineRTC SDK for Flutter

[中文](https://github.com/volcengine/VolcEngineRTC_Flutter_SDK/blob/master/README.zh_CN.md)

> This Flutter plugin is a wrapper for [VolcEngineRTC SDK](https://www.volcengine.com/product/veRTC).

## Usage

To use this plugin, add `volc_engine_rtc` as a dependency in your `pubspec.yaml` file.

### Device Permission

VolcEngineRTC SDK requires `camera` and `microphone` permission to start video call.

#### iOS

Open the `Info.plist` and add:

- `Privacy - Microphone Usage Description`, and add some description into the `Value` column.
- `Privacy - Camera Usage Description`, and add some description into the `Value` column.

Your application can still run the voice call when it is switched to the background if the background mode is enabled. Select the app target in Xcode, click the **Capabilities** tab, enable **Background Modes**, and check **Audio, AirPlay, and Picture in Picture**.

* modify `Podfile` to set VolcEngineRTC source

```xml
source 'https://github.com/volcengine/volcengine-specs.git'
```

#### Android

VolcEngineRTC has declared the necessary permissions, which will be merged into the `AndroidManifest.xml`.

## License

This project is licensed under the [MIT license](https://github.com/volcengine/VolcEngineRTC_Flutter_SDK/blob/master/LICENSE).
