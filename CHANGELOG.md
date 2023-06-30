## 3.51.1
### 新增特性
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

### 功能优化
1. 在使用音频信息提示获取本地和远端的音量信息时，支持开启音量平滑功能，并支持获取本地混音信息。参看传入参数 [AudioPropertiesConfig](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_audio_defines/AudioPropertiesConfig-class.html) 中新增的 “smooth” 参数和 “audioReportMode” 参数。
2. [sendSEIMessage](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/sendSEIMessage.html) 新增参数 “mode”，支持 SEI 多发模式，即在 1 帧间隔内多次发送 SEI 数据时，多个 SEI 随下个视频帧同时发送。

### 升级指南
#### 头文件变更
原 bytertc_common_defines.dart 文件拆分为 bytertc_media_defines.dart 及 bytertc_rts_defines.dart
#### API 变更
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

#### 回调变更
1. [onPublicStreamSEIMessageReceived](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onPublicStreamSEIMessageReceived.html) 新增参数 “sourceType”。
2. 删除 `RTCRangeAudioObserver` 类和相关回调。此前，在手动订阅的场景下，如果你希望使用范围语音功能，你必须根据此回调获取的衰减系数，设定音量。自此版本起，无论是手动订阅还是自动订阅，衰减效果都由 SDK 实现，无需使用此接口。
3. 废弃 [onRemoteAudioStateChanged](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onRemoteAudioStateChanged.html) 和 [onRemoteVideoStateChanged](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onRemoteVideoStateChanged.html)，无替代回调。
4. 废弃 [onLocalAudioStateChanged](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onLocalAudioStateChanged.html) 和 [onLocalVideoStateChanged](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onLocalVideoStateChanged.html)，使用 [onAudioDeviceStateChanged](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onAudioDeviceStateChanged.html) 和 [onVideoDeviceStateChanged](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onVideoDeviceStateChanged.html) 替代。

#### 类型变更
1. [FaceDetectionResult](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_defines/FaceDetectionResult-class.html) 人脸检测结果新增成员变量 “frameTimestampUs”。
2. [UserMessageSendResult](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_rts_defines/UserMessageSendResult.html) 对单个用户的消息发送结果新增值 “exceedQPS”。
3. [RoomMessageSendResult](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_rts_defines/RoomMessageSendResult.html) 房间内群发消息结果新增值 “exceedQPS”。
4. 空间音频功能中表示空间坐标的 [Position](https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_audio_defines/Position-class.html) 的变量 x, y, z 类型由 int 更改为 double。
5. [RoomProfile](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_media_defines/RoomProfile.html) 房间模式中默认模式 “communication” 的参数配置由与 “chatRoom” 对应变更为与 “meeting” 对应。
6. [onPushPublicStreamResult](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onPushPublicStreamResult.html) 和 [onPlayPublicStreamResult](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_event_handler/RTCVideoEventHandler/onPlayPublicStreamResult.html) 中的 `errorCode` 参数类型由 “int” 改为 [PublicStreamErrorCode](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_media_defines/PublicStreamErrorCode.html)。
7. [AudioRoute](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_audio_defines/AudioRoute.html) 枚举值 “unknown” 变更为 “routeDefault”。
8. [AudioScenario](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_audio_defines/AudioScenario.html) 音频路由和发布订阅状态到音量类型的映射关系改变。最新的映射关系查看数据结构的文档。

## 3.45.2
### 新增特性
1. [AudioScenario](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_audio_defines/AudioScenario.html) 音频场景类型新增 “highQualityChat” 高音质畅聊模式。
2. 新增接口 [getAudioMixingPlaybackDuration](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_audio_mixing_api/RTCAudioMixingManager/getAudioMixingPlaybackDuration.html) 支持获取混音音频文件的实际播放时长，即歌曲不受停止、跳转、倍速、卡顿影响的播放时长。
3. 新增接口 [subscribeAllStreams](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_room_api/RTCRoom/subscribeAllStreams.html) 和 [unsubscribeAllStreams](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_room_api/RTCRoom/unsubscribeAllStreams.html) 支持订阅和取消订阅所有用户，在上麦人数固定的场景中，可以快速实现麦位切换。
4. 新增接口 [setAllAudioMixingVolume](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_audio_mixing_api/RTCAudioMixingManager/setAllAudioMixingVolume.html) 支持统一设置全局混音文件音量。
5. 新增接口 [takeLocalSnapshot](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/takeLocalSnapshot.html) 和 [takeRemoteSnapshot](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_video_api/RTCVideo/takeRemoteSnapshot.html) 支持在客户端截取本地/远端视频图像。
6. [NetworkQuality](https://pub.dev/documentation/volc_engine_rtc/3.51.1/api_bytertc_common_defines/NetworkQuality.html) 媒体流网络质量新增 “down” 反映本地网络断联状态。

## 3.45.1

* 修复了一些 bug。

## 3.44.1

* Flutter RTC SDK 正式发布
