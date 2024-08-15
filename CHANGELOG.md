# 3.58.1

## 新增特性

1. 支持内部采集信号静音控制（不改变本端硬件）。可以选择静音或取消静音麦克风采集，而不影响 SDK 音频流发布状态。参看 [`muteAudioCapture`](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/muteAudioCapture.html)
2. 在 Android 平台，在支持渲染 View 对象的基础上，新增支持渲染 Surface 对象。
3. 音乐和音效播放状态回调新增代表播放结束的枚举值 [`PlayerState`](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_audio_defines/PlayerState.html)。

# 3.57.3

## 修复问题
1. 修复多次释放渲染view偶现crash问题

# 3.57.2

## 修复问题
1. 修复了在 gradle 8 以上版本，编译失败问题。

# 3.57.1

## 新增特性
1. 转推直播配置新增服务端合流控制参数 [MixedStreamServerControlConfig](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_defines/MixedStreamServerControlConfig-class.html)，用于以下功能设置：
    + 支持在合流转推发送 SEI 时设置 PayLoadType，以适配特定播放器作为接收端时接收 SEI 信息。参看 [seiPayloadType](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_defines/MixedStreamServerControlConfig/seiPayloadType.html)、[seiPayloadUuid](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_defines/MixedStreamServerControlConfig/seiPayloadUuid.html)。
    + 支持控制 SEI 发送内容。此前服务端合流默认发送全量 SEI 信息，新版本支持单独发送音量提示 SEI，在需要高频发送音量信息的场景下，大幅减少性能开销。具体参看 API：
        - [enableVolumeIndication](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_defines/MixedStreamServerControlConfig/enableVolumeIndication.html) 设置是否开启单独发送声音提示 SEI 的功能；
        - [seiContentMode](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_defines/MixedStreamServerControlConfig/seiContentMode.html) 设置 SEI 内容；
        - [isAddVolumeValue](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_defines/MixedStreamServerControlConfig/isAddVolumeValue.html) 设置声音信息 SEI 是否包含音量值；
        - [volumeIndicationInterval](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_defines/MixedStreamServerControlConfig/volumeIndicationInterval.html) 设置声音信息提示间隔；
        - [talkVolume](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_defines/MixedStreamServerControlConfig/talkVolume.html) 设置有效音量大小。
    + 支持在房间内无用户发布流的场景下，使用占位图发起转推直播任务。参看 [pushStreamMode](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_defines/MixedStreamServerControlConfig/pushStreamMode.html)。
    + 合流推到 CDN 时支持推送纯音频流。参看 [mediaType](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_defines/MixedStreamServerControlConfig/mediaType.html)。
2. 转推直播支持设置合流后整体画布的背景图片。参看 [MixedStreamLayoutConfig.backgroundImageUrl](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_defines/MixedStreamLayoutConfig/backgroundImageUrl.html)。
3. 对远端流进行内部渲染时，支持将某一路远端流镜像渲染。参看 [setRemoteVideoMirrorType](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/setRemoteVideoMirrorType.html)。
4. 新增接口 [setVideoCaptureRotation](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/setVideoCaptureRotation.html) 支持采集画面旋转能力，适用于无重力感应的移动设备（如金融行业用于人脸采集的设备）的画面适配。注意，对于手机、平板电脑等具备重力感应的移动设备，旋转采集画面应使用 [setVideoRotationMode](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/setVideoRotationMode.html)，参看[视频采集旋转方向](https://www.volcengine.com/docs/6348/106458)。

## 功能优化
1. Android 端应用在使用 RTC SDK 进行视频内部采集时，长时间退后台（>1min）后再次进入前台时，RTC 将自动恢复视频采集，无需额外操作。
2. 在通过回调获取本地音频信息时，支持获取人声基频信息。参看 [enableAudioPropertiesReport](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/enableAudioPropertiesReport.html) 接口参数 [AudioPropertiesConfig.enableVoicePitch](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_audio_defines/AudioPropertiesConfig/enableVoicePitch.html)。
3. 调用 [setLogConfig](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/setLogConfig.html) 配置 SDK 本地日志参数时，支持自定义本地日志文件名前缀，最终的日志文件名为 前缀 + "_" + 文件创建时间 + "_rtclog".log。参看 [RTCLogConfig.logFilenamePrefix](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_rts_defines/RTCLogConfig/logFilenamePrefix.html)。
4. 基础美颜新增清晰子项，并优化美颜参数默认值。使用清晰子项需要集成 v4.4.2+ 版本的特效 SDK。各基础美颜子项的默认强度调整为：美白 0.7，磨皮 0.8，锐化 0.5，清晰 0.7。具体参看 API：
    + [enableEffectBeauty](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/enableEffectBeauty.html) 开启/关闭基础美颜；
    + [setBeautyIntensity](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/setBeautyIntensity.html) 调整基础美颜强度。

## 升级指南

### 回调变更
1. `onLocalAudioPropertiesReport` 回调参数数据结构 `AudioPropertiesInfo` 新增成员变量 [voicePitch](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_audio_defines/AudioPropertiesInfo/voicePitch.html) 返回本地用户的人声基频。
2. 在 [onLogout](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_event_handler/RTCVideoEventHandler/onLogout.html) 回调上新增 `reason` 参数，区分用户主动/被动登出。

### 类型变更
1. 在字幕内容回调 [onSubtitleMessageReceived](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_room_event_handler/RTCRoomEventHandler/onSubtitleMessageReceived.html) 的参数 `SubtitleMessage` 中新增成员变量 `language` 和 `mode`，可用于同时收到字幕原文和字幕译文。
2. [MixedStreamLayoutRegionConfig](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_defines/MixedStreamLayoutRegionConfig-class.html) 部分成员变量行为变更：转推直播单个用户画面由设置相对于整体画面的归一化比例变更为可设置像素绝对值。具体参看 `locationX`、`locationY`、`width`、`height` 成员的参数描述。

# 3.54.2

## 重要说明
应 Apple App Store 的要求，自此版本起，RTC SDK for iOS 不再支持 armv7 架构，兼容的最低版本为 iOS 11。

## 新增特性
1. 该版本起，部分功能从 SDK 中拆分出来封装成独立插件。新增 [onExtensionAccessError](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_event_handler/RTCVideoEventHandler/onExtensionAccessError.html) 回调，你可以通过该回调定位访问失败的插件，并判断是否需要集成。
2. 新增设置房间附加消息 API，支持设置如房间公告等与房间相关的业务属性。具体参看 [setRoomExtraInfo](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_room_api/RTCRoom/setRoomExtraInfo.html)。
3. 新增接口支持开启或关闭字幕，可对房间内说话人的语音进行识别，转成文字或者进行翻译。使用该功能前，你需要[开通机器翻译服务](https://www.volcengine.com/docs/4640/130262)并前往 [RTC 控制台](https://console.volcengine.com/rtc/cloudRTC?tab=subtitle)，在功能配置页面开启字幕功能。具体参看 [startSubtitle](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_room_api/RTCRoom/startSubtitle.html)。
4. 新增设置用户可见性结果回调，具体参看 [onUserVisibilityChanged](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_room_event_handler/RTCRoomEventHandler/onUserVisibilityChanged.html)
5. 新增接口 [setLogConfig](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/setLogConfig.html) 支持设置本地日志级别、存储路径、可使用的最大缓存空间。
6. 新增接口 [enableCameraAutoExposureFaceMode](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/enableCameraAutoExposureFaceMode.html) 和 [setCameraAdaptiveMinimumFrameRate](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/setCameraAdaptiveMinimumFrameRate.html)，支持关闭人脸自动曝光功能和动态采集帧率功能。
7. 新增接口 [setCellularEnhancement](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/setCellularEnhancement.html)，支持启用蜂窝网络辅助增强通信效果。
8. 新增接口 [setLocalProxy](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/setLocalProxy.html)，支持设置本地代理。

## 功能优化
1. 优化千人会议体验，开启[音频选路](https://console.volcengine.com/rtc/cloudRTC?tab=roomMode)后，支持发布端设置不参与选路，适用于要求指定用户的发言能一直被收听到的场景，例如，有固定的主持人麦位。对于每个 appId，只区分是否开启音频选路功能，不再区分房间模式。详见[千人会议和音频选路](https://www.volcengine.com/docs/6348/113547)。具体参看 API：[setAudioSelectionConfig](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_room_api/RTCRoom/setAudioSelectionConfig.html)。
2. 优化本地用户空间音频体验，支持本地用户设置自己和指定远端用户在空间音频坐标系中的位置和朝向，同时支持本地用户设置指定或全部远端用户不参与空间音频。具体参看 API：
    + 废弃 [updatePosition](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_spatial_audio_api/RTCSpatialAudio/updatePosition.html) 和 [updateSelfOrientation](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_spatial_audio_api/RTCSpatialAudio/updateSelfOrientation.html)，由新增接口 [updateSelfPosition](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_spatial_audio_api/RTCSpatialAudio/updateSelfPosition.html) 代替；
    + 废弃 [updateListenerPosition](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_spatial_audio_api/RTCSpatialAudio/updateListenerPosition.html) 和 [updateListenerOrientation](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_spatial_audio_api/RTCSpatialAudio/updateListenerOrientation.html)，由新增接口 [updateRemotePosition](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_spatial_audio_api/RTCSpatialAudio/updateRemotePosition.html) 代替；
    + 新增 [removeRemotePosition](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_spatial_audio_api/RTCSpatialAudio/removeRemotePosition.html)
    + 新增 [removeAllRemotePosition](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_spatial_audio_api/RTCSpatialAudio/removeAllRemotePosition.html)
3. 公共流功能优化， SEI 相关的信息回调功能，支持与 vp8、单流转封装功能同时使用。订阅端可以感知发布状态变化。

## 升级指南

### API 变更
1. 该版本为全部 API 增加返回值，通过返回值可以明确发现失败的 API 调用，定位失败原因。具体返回值的含义参看各 API 注释。
2. [feedback](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/feedback.html) 参数数据类型变更。
3. 合流转推直播接口/参数类型重命名，行为逻辑无变化，原接口废弃。
    + [startLiveTranscoding](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/startLiveTranscoding.html) 废弃，由 [startPushMixedStreamToCDN](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/startPushMixedStreamToCDN.html) 代替；
    + [stopLiveTranscoding](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/stopLiveTranscoding.html) 废弃，由 [stopPushStreamToCDN](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/stopPushStreamToCDN.html) 代替；
    + [updateLiveTranscoding](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/updateLiveTranscoding.html) 废弃，由 [updatePushMixedStreamToCDN](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/updatePushMixedStreamToCDN.html) 代替。
4. 将混音相关的类和接口按音效和音乐进行拆分。一般来说，对于短时间的音效，如小于 20s，可以使用音效类；对于较长的音频，可以使用音乐类。具体参看 API：
    + 废弃 [AudioMixingManager](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/audioMixingManager.html)，由 [getAudioEffectPlayer](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/getAudioEffectPlayer.html) 和 [getMediaPlayer](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/getMediaPlayer.html) 替代。
5. [startAudioRecording](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_api/RTCVideo/startAudioRecording.html) 接口行为变更。在此前版本中，此接口仅支持进房后调用。自此版本后，此接口在进房前后均可调用。进房前调用，退房之后录制任务不会自动停止；进房后调用，退房之后录制任务会自动停止。

### 回调变更
1. [onPublicStreamSEIMessageReceived](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_event_handler/RTCVideoEventHandler/onPublicStreamSEIMessageReceived.html) 回调参数 `sourceType` 的数据类型由 `SEIMessageSourceType` 变更为 `DataMessageSourceType`，并进行功能拆分：
    + [onPublicStreamSEIMessageReceived](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_event_handler/RTCVideoEventHandler/onPublicStreamSEIMessageReceived.html) 用于接收客户端插入的 SEI 消息；
    + [onPublicStreamDataMessageReceived](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_video_event_handler/RTCVideoEventHandler/onPublicStreamDataMessageReceived.html) 用于接收服务端插入的 SEI 消息和其他数据信息，例如音量信息。

### 数据类型变更
1. 公共流状态码 [PublicStreamErrorCode](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_media_defines/PublicStreamErrorCode.html) 参数数据类型变更：
    - 新增 `pullNoPushStream`，提示因发布端未开始发布流引起的订阅失败；
    - `paramError` 变更为 `pushParamError`；
    - `statusError` 变更为 `pushStateError`；
    - `internalError` 变更为 `pushInternalError`；
    - `timeOut` 变更为 `pushTimeOut`。
2. 错误码 [ErrorCode](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_media_defines/ErrorCode.html) 中 `overScreenPublishLimit` 和 `overVideoPublishLimit` 废弃，用 `overStreamPublishLimit` 替代。

# 3.51.1

## 新增特性
1. [MediaDeviceWarning](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_media_defines/MediaDeviceWarning.html) 新增啸叫检测警告 `captureDetectHowling`。以下情形将触发该警告：
    - 不支持啸叫抑制的房间模式下，检测到啸叫；
    - 支持啸叫抑制的房间模式下，检测到未被抑制的啸叫。
2. 适配 iPadOS 16 多任务台前调度（Stage Manager）功能。丰富了可以通过 [onVideoDeviceStateChanged](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onVideoDeviceStateChanged.html) 回调感知的系统摄像头状态信息，详见[通话打断和恢复](https://www.volcengine.com/docs/6348/111590)。
3. 新增接口 [setDummyCaptureImagePath](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/setDummyCaptureImagePath.html) 支持在关闭摄像头后上传静态图片填充本地推送的视频流。
4. iOS 新增接口 [setBluetoothMode](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/setBluetoothMode.html)，在纯媒体音频场景下，支持切换 iOS 设备与耳机之间的蓝牙传输协议。
5. 新增接口 [setRemoteRoomAudioPlaybackVolume](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_room_api/RTCRoom/setRemoteRoomAudioPlaybackVolume.html)，在多房间场景下，支持调节某个远端房间内的所有用户的音量。
6. 新增接口 [setNoAttenuationFlags](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_range_audio_api/RTCRangeAudio/setNoAttenuationFlags.html) 支持在启用范围语音功能时，设置相互通话不受衰减影响的小队。
7. 支持检测背景声中的音乐，并保护音乐的音质。要使用此功能，请联系技术支持人员开启。
8. 新增 Token 的发布/订阅权限即将过期的回调 [onPublishPrivilegeTokenWillExpire](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_room_event_handler/RTCRoomEventHandler/onPublishPrivilegeTokenWillExpire.html) 和 [onSubscribePrivilegeTokenWillExpire](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_room_event_handler/RTCRoomEventHandler/onSubscribePrivilegeTokenWillExpire.html)，用于提示用户及时更新 Token 相关权限，以保证正常的音视频通话。该功能默认关闭，如有需要请联系技术支持开启。
9. [VoiceReverbType](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_audio_defines/VoiceReverbType.html) 新增录音棚、虚拟立体声、空旷、3D 人声等多种混响音效。
10. 新增对本地采集的音频添加音量均衡效果和混响参数。详请参看 API 说明：
    - [setLocalVoiceEqualization](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/setLocalVoiceEqualization.html) 添加音量均衡效果；
    - [setLocalVoiceReverbParam](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/setLocalVoiceReverbParam.html) 添加混响参数；
    - [enableLocalVoiceReverb](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/enableLocalVoiceReverb.html) 启用混响参数。
11. 新增停止、暂停、恢复播放所有音频文件及混音的功能。详请参看 API 说明：
    - [stopAllAudioMixing](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_audio_mixing_api/RTCAudioMixingManager/stopAllAudioMixing.html) 停止播放所有音频文件及混音；
    - [pauseAllAudioMixing](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_audio_mixing_api/RTCAudioMixingManager/pauseAllAudioMixing.html) 暂停播放所有音频文件及混音；
    - [resumeAllAudioMixing](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_audio_mixing_api/RTCAudioMixingManager/resumeAllAudioMixing.html) 恢复播放所有音频文件及混音。
12. 新增支持会前/会中音频设备回声抑制功能检测。详请参看 API 说明：
    - [startHardwareEchoDetection](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/startHardwareEchoDetection.html) 开启通话前回声检测；
    - [stopHardwareEchoDetection](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/stopHardwareEchoDetection.html) 停止通话前回声检测。
13. 新增通过数码变焦控制摄像头画面的能力，实现画面的上、下、左、右平移以及放大、缩小。详请参看 API 说明：
    - [setVideoDigitalZoomConfig](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/setVideoDigitalZoomConfig.html) 设置本地摄像头数码变焦参数；
    - [setVideoDigitalZoomControl](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/setVideoDigitalZoomControl.html) 控制本地摄像头数码变焦，缩放或移动；
    - [startVideoDigitalZoomControl](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/startVideoDigitalZoomControl.html) 开启本地摄像头持续数码变焦，缩放或移动；
    - [stopVideoDigitalZoomControl](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/stopVideoDigitalZoomControl.html) 停止本地摄像头持续数码变焦。
14. 根据进房时选择的业务场景自动适配音频降噪算法，满足多种场景下不同的降噪需求。新增接口 [setAnsMode](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/setAnsMode.html) 支持通话过程中手动设置音频降噪模式。
15. 新增接口 [setPublicStreamAudioPlaybackVolume](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/setPublicStreamAudioPlaybackVolume.html) 支持调节远端公共音频在本地播放的音量。

## 功能优化
1. 在使用音频信息提示获取本地和远端的音量信息时，支持开启音量平滑功能，并支持获取本地混音信息。参看传入参数 [AudioPropertiesConfig](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_audio_defines/AudioPropertiesConfig-class.html) 中新增的 “smooth” 参数和 “audioReportMode” 参数。
2. [sendSEIMessage](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/sendSEIMessage.html) 新增参数 “mode”，支持 SEI 多发模式，即在 1 帧间隔内多次发送 SEI 数据时，多个 SEI 随下个视频帧同时发送。

## 升级指南

### 头文件变更
原 bytertc_common_defines.dart 文件拆分为 bytertc_media_defines.dart 及 bytertc_rts_defines.dart。

### API 变更
1. [registerFaceDetectionObserver](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/registerFaceDetectionObserver.html) 拆分为 [enableFaceDetection](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_effect_api/RTCVideoEffect/enableFaceDetection.html) 和 [disableFaceDetection](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_effect_api/RTCVideoEffect/disableFaceDetection.html)，解除人脸识别与视频特效之间的耦合，提升接口易用性。
2. [setScreenVideoEncoderConfig](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/setScreenVideoEncoderConfig.html) 参数类型由 “VideoEncoderConfig” 变更为 “ScreenVideoEncoderConfig”。
3. 视频特效相关接口由 `RTCVideo` 类迁移至 `RTCVideoEffect` 下，包括：
    - [initCVResource](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_effect_api/RTCVideoEffect/initCVResource.html) 代替旧接口 [checkVideoEffectLicense](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/checkVideoEffectLicense.html) 和 [setVideoEffectAlgoModelPath](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/setVideoEffectAlgoModelPath.html)；
    - [enableVideoEffect](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_effect_api/RTCVideoEffect/enableVideoEffect.html) 和 [disableVideoEffect](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_effect_api/RTCVideoEffect/disableVideoEffect.html) 代替旧接口 [enableVideoEffect](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/enableVideoEffect.html)；
    - [setEffectNodes](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_effect_api/RTCVideoEffect/setEffectNodes.html) 代替旧接口 [setVideoEffectNodes](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/setVideoEffectNodes.html)；
    - [updateEffectNode](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_effect_api/RTCVideoEffect/updateEffectNode.html)代替旧接口 [updateVideoEffectNode](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/updateVideoEffectNode.html)；
    - [enableVirtualBackground](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_effect_api/RTCVideoEffect/enableVirtualBackground.html) 和 [disableVirtualBackground](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_effect_api/RTCVideoEffect/disableVirtualBackground.html) 代替旧接口 [setBackgroundSticker](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/setBackgroundSticker.html)；
    - [setColorFilter](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_effect_api/RTCVideoEffect/setColorFilter.html) 代替旧接口 [setVideoEffectColorFilter](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/setVideoEffectColorFilter.html)；
    - [setColorFilterIntensity](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_effect_api/RTCVideoEffect/setColorFilterIntensity.html) 代替旧接口 [setVideoEffectColorFilterIntensity](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/setVideoEffectColorFilterIntensity.html)；
4. 接口返回值类型变化：
    - 以下接口返回值类型变更为 “int”，返回值具体含义参看 [ReturnStatus](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_media_defines/ReturnStatus.html)：`updateToken`，`setRemoteVideoConfig`，`subscribeStream`，`unsubscribeStream`，`subscribeScreen`，`unsubscribeScreen`，`setVoiceChangerType`，`setVoiceReverbType`；
    - 以下接口返回值类型变更为 “void”：`setMultiDeviceAVSync`，`setLocalVideoMirrorType`，`setVideoRotationMode`，`setAudioRoute`，`enableSimulcastMode`，`setPublishFallbackOption`，`setSubscribeFallbackOption`。
5. `getSdkVersion` 名称变更为 [getSDKVersion](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/getSDKVersion.html)。
6. [setAudioRoute](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/setAudioRoute.html) 行为变更，支持使用仅有媒体模式的设备作为音频路由设备。

### 回调变更
1. [onPublicStreamSEIMessageReceived](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onPublicStreamSEIMessageReceived.html) 新增参数 “sourceType”。
2. 删除 `RTCRangeAudioObserver` 类和相关回调。此前，在手动订阅的场景下，如果你希望使用范围语音功能，你必须根据此回调获取的衰减系数，设定音量。自此版本起，无论是手动订阅还是自动订阅，衰减效果都由 SDK 实现，无需使用此接口。
3. 废弃 [onRemoteAudioStateChanged](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onRemoteAudioStateChanged.html) 和 [onRemoteVideoStateChanged](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onRemoteVideoStateChanged.html)，无替代回调。
4. 废弃 [onLocalAudioStateChanged](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onLocalAudioStateChanged.html) 和 [onLocalVideoStateChanged](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onLocalVideoStateChanged.html)，使用 [onAudioDeviceStateChanged](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onAudioDeviceStateChanged.html) 和 [onVideoDeviceStateChanged](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onVideoDeviceStateChanged.html) 替代。

### 类型变更
1. [FaceDetectionResult](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_defines/FaceDetectionResult-class.html) 人脸检测结果新增成员变量 “frameTimestampUs”。
2. [UserMessageSendResult](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_rts_defines/UserMessageSendResult.html) 对单个用户的消息发送结果新增值 “exceedQPS”。
3. [RoomMessageSendResult](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_rts_defines/RoomMessageSendResult.html) 房间内群发消息结果新增值 “exceedQPS”。
4. 空间音频功能中表示空间坐标的 [Position](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_audio_defines/Position-class.html) 的变量 x, y, z 类型由 int 更改为 double。
5. [RoomProfile](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_media_defines/RoomProfile.html) 房间模式中默认模式 “communication” 的参数配置由与 “chatRoom” 对应变更为与 “meeting” 对应。
6. [onPushPublicStreamResult](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onPushPublicStreamResult.html) 和 [onPlayPublicStreamResult](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onPlayPublicStreamResult.html) 中的 `errorCode` 参数类型由 “int” 改为 [PublicStreamErrorCode](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_media_defines/PublicStreamErrorCode.html)。
7. [AudioRoute](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_audio_defines/AudioRoute.html) 枚举值 “unknown” 变更为 “routeDefault”。
8. [AudioScenario](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_audio_defines/AudioScenario.html) 音频路由和发布订阅状态到音量类型的映射关系改变。最新的映射关系查看数据结构的文档。

# 3.45.2

## 新增特性
1. [AudioScenario](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_audio_defines/AudioScenario.html) 音频场景类型新增 “highQualityChat” 高音质畅聊模式。
2. 新增接口 [getAudioMixingPlaybackDuration](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_audio_mixing_api/RTCAudioMixingManager/getAudioMixingPlaybackDuration.html) 支持获取混音音频文件的实际播放时长，即歌曲不受停止、跳转、倍速、卡顿影响的播放时长。
3. 新增接口 [subscribeAllStreams](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_room_api/RTCRoom/subscribeAllStreams.html) 和 [unsubscribeAllStreams](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_room_api/RTCRoom/unsubscribeAllStreams.html) 支持订阅和取消订阅所有用户，在上麦人数固定的场景中，可以快速实现麦位切换。
4. 新增接口 [setAllAudioMixingVolume](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_audio_mixing_api/RTCAudioMixingManager/setAllAudioMixingVolume.html) 支持统一设置全局混音文件音量。
5. 新增接口 [takeLocalSnapshot](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/takeLocalSnapshot.html) 和 [takeRemoteSnapshot](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/takeRemoteSnapshot.html) 支持在客户端截取本地/远端视频图像。
6. [NetworkQuality](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_common_defines/NetworkQuality.html) 媒体流网络质量新增 “down” 反映本地网络断联状态。

# 3.45.1

* 修复了一些 bug。

# 3.44.1

* Flutter RTC SDK 正式发布
