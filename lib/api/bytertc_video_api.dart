// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:async/async.dart';

import '../src/bytertc_video_impl.dart';
import 'bytertc_asr_engine_event_handler.dart';
import 'bytertc_audio_defines.dart';
import 'bytertc_audio_effect_player_api.dart';
import 'bytertc_audio_mixing_api.dart';
import 'bytertc_cdn_stream_observer.dart';
import 'bytertc_face_detection_observer.dart';
import 'bytertc_ktv_manager_api.dart';
import 'bytertc_live_transcoding_observer.dart';
import 'bytertc_media_defines.dart';
import 'bytertc_media_player_api.dart';
import 'bytertc_room_api.dart';
import 'bytertc_room_event_handler.dart';
import 'bytertc_rts_defines.dart';
import 'bytertc_sing_scoring_manager_api.dart';
import 'bytertc_video_defines.dart';
import 'bytertc_video_effect_api.dart';
import 'bytertc_video_event_handler.dart';

/// 引擎接口
abstract class RTCVideo {
  /// 创建引擎对象
  ///
  /// 如果当前线程中未创建引擎实例，那么你必须先使用此方法，以使用 RTC 提供的各种音视频能力。  <br>
  /// 如果当前线程中已创建了引擎实例，再次调用此方法时，会返回已创建的引擎实例。
  static Future<RTCVideo?> createRTCVideo(RTCVideoContext context) =>
      RTCVideoImpl.createRTCVideo(context);

  /// 获取当前 SDK 版本信息
  static Future<String?> getSDKVersion() => RTCVideoImpl.getSDKVersion();

  /// 配置 SDK 本地日志参数，包括日志级别、存储路径、日志文件最大占用的总空间、日志文件名前缀。
  ///
  /// v3.54 新增。
  ///
  /// [logConfig]：本地日志参数。
  ///
  /// 返回值：
  /// + 0：成功。
  /// + –1：失败，本方法必须在创建引擎前调用。
  /// + –2：失败，参数填写错误。
  ///
  /// 本方法必须在调用 [RTCVideo.createRTCVideo] 之前调用。
  static Future<int?> setLogConfig(RTCLogConfig logConfig) =>
      RTCVideoImpl.setLogConfig(logConfig);

  /// 获取 SDK 内各种错误码、警告码的描述文字。
  static Future<String?> getErrorDescription(int code) =>
      RTCVideoImpl.getErrorDescription(code);

  /// 销毁由 [RTCVideo.createRTCVideo] 所创建的引擎实例，并释放所有相关资源。
  ///
  /// 注意：
  /// + 请确保和需要销毁的 RTCVideo 实例相关的业务场景全部结束后，才调用此方法。
  /// + 该方法在调用之后，会销毁所有和此 RTCVideo 实例相关的内存，并且停止与媒体服务器的任何交互。
  Future<void> destroy();

  /// 设置事件回调的接收类
  void setRTCVideoEventHandler(RTCVideoEventHandler handler);

  /// 开启内部音频采集，默认为关闭状态
  ///
  /// 内部采集是指使用 RTC SDK 内置的音频采集机制进行音频采集。
  /// 调用该方法开启采集后，本地用户会收到 [RTCVideoEventHandler.onAudioDeviceStateChanged] 的回调。
  /// 可见用户进房后调用该方法，房间中的其他用户会收到 [RTCVideoEventHandler.onUserStartAudioCapture] 回调。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 若未取得当前设备的麦克风权限，调用该方法后会触发 [RTCVideoEventHandler.onAudioDeviceStateChanged] 回调，对应的错误码为 `MediaDeviceError.deviceNoPermission`。
  /// + 调用 [RTCVideo.stopAudioCapture] 可以关闭音频采集设备，否则，SDK 只会在销毁引擎的时候自动关闭设备。
  /// + 由于不同硬件设备初始化响应时间不同，频繁调用本方法和 [RTCVideo.stopAudioCapture] 可能出现短暂无声问题，建议使用 [RTCRoom.publishStream]/[RTCRoom.unpublishStream] 实现临时闭麦和重新开麦。
  /// + 无论是否发布音频数据，你都可以调用该方法开启音频采集，并且调用后方可发布音频。
  Future<int?> startAudioCapture();

  /// 关闭内部音频采集，默认为关闭状态
  ///
  /// 调用该方法后，本地用户会收到 [RTCVideoEventHandler.onAudioDeviceStateChanged] 的回调。
  /// 可见用户进房后调用该方法，房间中的其他用户会收到 [RTCVideoEventHandler.onUserStopAudioCapture] 的回调。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 调用 [RTCVideo.startAudioCapture] 可以开启音频采集设备。
  /// + 设备开启后若一直未调用该方法关闭设备，则 SDK 会在销毁引擎的时候自动关闭音频采集设备。
  Future<int?> stopAudioCapture();

  /// 设置音频场景类型
  ///
  /// 你可以根据你的应用所在场景，选择合适的音频场景类型。<br>
  /// 选择音频场景后，RTC 会自动根据客户端音频路由和发布订阅状态，适用通话音量/媒体音量。<br>
  /// 在进房前和进房后设置均可生效。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 通话音量更适合通话，会议等对信息准确度要求更高的场景。通话音量会激活系统硬件信号处理，使通话声音会更清晰。此时，音量无法降低到 0。
  /// + 媒体音量更适合娱乐场景，因其声音的表现力会更强。媒体音量下，音量最低可以降低到 0。
  Future<int?> setAudioScenario(AudioScenario audioScenario);

  /// @nodoc
  Future<int?> setAudioScene(AudioSceneType audioScene);

  /// 设置音质档位
  ///
  /// 当所选的 [RoomProfile] 中的音频参数无法满足你的场景需求时，调用本接口切换的音质档位。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 该方法在进房前后均可调用；
  /// + 支持通话过程中动态切换音质档位。
  Future<int?> setAudioProfile(AudioProfileType audioProfile);

  /// 支持根据业务场景，设置通话中的音频降噪模式。
  ///
  /// v3.51 新增。
  ///
  /// [ansMode]：降噪模式。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 该接口进房前后均可调用，可重复调用，仅最后一次调用生效。
  Future<int?> setAnsMode(AnsMode ansMode);

  /// 设置变声特效类型
  ///
  /// 返回值参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 在进房前后都可设置。
  /// + 只对单声道音频生效。
  /// + 只在包含美声特效能力的 SDK 中有效。
  /// + 与 [RTCVideo.setVoiceReverbType] 互斥，后设置的特效会覆盖先设置的特效。
  Future<int?> setVoiceChangerType(VoiceChangerType voiceChanger);

  /// 设置混响特效类型
  ///
  /// 返回值参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 在进房前后都可设置。
  /// + 只对单声道音频生效。
  /// + 只在包含美声特效能力的 SDK 中有效。
  /// + 与 [RTCVideo.setVoiceChangerType] 互斥，后设置的特效会覆盖先设置的特效。
  /// + 使用本接口前，请联系 RTC 技术支持了解更多详情。
  Future<int?> setVoiceReverbType(VoiceReverbType voiceReverb);

  /// 设置本地采集语音的均衡效果<br>
  /// 包含内部采集和外部采集，但不包含混音音频文件。
  ///
  /// [config]：语音均衡效果。
  ///
  /// 返回值：
  /// + `0`：成功；
  /// + `<0`：失败。
  ///
  /// 注意：根据奈奎斯特采样率，音频采样率必须大于等于设置的中心频率的两倍，否则，设置不生效。
  Future<int?> setLocalVoiceEqualization(VoiceEqualizationConfig config);

  /// 设置本地采集音频的混响效果<br>
  /// 包含内部采集和外部采集，但不包含混音音频文件。
  ///
  /// [config]：混响效果。
  ///
  /// 返回值：
  /// + `0`：成功；
  /// + `<0`：失败。
  ///
  /// 调用 [RTCVideo.enableLocalVoiceReverb] 开启混响效果。
  Future<int?> setLocalVoiceReverbParam(VoiceReverbConfig config);

  /// 开启本地音效混响效果
  ///
  /// 调用 [RTCVideo.setLocalVoiceReverbParam] 设置混响效果。
  Future<int?> enableLocalVoiceReverb(bool enable);

  /// 设置是否将采集到的音频信号静音，而不影响改变本端硬件采集状态。
  /// 
  /// [index] 流索引，指定调节主流/屏幕流音量，参看 [StreamIndex]。
  ///
  /// [mute] 是否静音音频采集。
  /// + True：静音（关闭麦克风）
  /// + False：（默认）开启麦克风
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 该方法用于设置是否使用静音数据替换设备采集到的音频数据进行推流，不影响 SDK 音频流的采集发布状态。
  /// + 静音后通过 [RTCVideo.setCaptureVolume] 调整音量不会取消静音状态，音量状态会保存至取消静音。
  /// + 调用 [RTCVideo.startAudioCapture] 开启音频采集前后，都可以使用此接口设置采集音量。
  Future<int?> muteAudioCapture({
    StreamIndex index = StreamIndex.main,
    required bool mute,
  });

  /// 调节音频采集音量
  ///
  /// [volume] 指采集的音量值和原始音量的比值，范围是 `[0, 400]`，单位为 %。<br>
  /// 只改变音频数据的音量信息，不涉及本端硬件的音量调节。<br>
  /// 为保证更好的通话质量，建议将 volume 值设为 `[0,100]`。
  /// + 0：静音
  /// + 100：原始音量
  /// + 400：最大可为原始音量的 4 倍(自带溢出保护)
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 无论是采集来自麦克风的音频流，还是屏幕音频流，都可以使用此接口进行音量调节。
  /// + 在开启音频采集前后，你都可以使用此接口设定采集音量。
  Future<int?> setCaptureVolume({
    StreamIndex index = StreamIndex.main,
    required int volume,
  });

  /// 调节本地播放的所有远端用户音频混音后的音量，混音内容包括远端人声、音乐、音效等。 <br>
  /// 播放音频前或播放音频时，你都可以使用此接口设定播放音量。
  ///
  /// [volume]：音频播放音量值和原始音量的比值，范围是 `[0, 400]`，单位为 %，自带溢出保护。  <br>
  /// 为保证更好的通话质量，建议将 volume 值设为 `[0,100]`。
  /// + 0：静音；
  /// + 100：原始音量；
  /// + 400：最大可为原始音量的 4 倍(自带溢出保护)。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 假设某远端用户 A 始终在被调节的目标用户范围内，当该方法与 [RTCVideo.setRemoteAudioPlaybackVolume] 或 [RTCRoom.setRemoteRoomAudioPlaybackVolume] 共同使用时，本地收听用户 A 的音量将为两次设置的音量效果的叠加。
  Future<int?> setPlaybackVolume(int volume);

  /// 启用音量提示
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 开启提示后，你可以：
  /// + 通过 [RTCVideoEventHandler.onLocalAudioPropertiesReport] 获取本地麦克风和屏幕音频流采集的音量信息。
  /// + 通过 [RTCVideoEventHandler.onRemoteAudioPropertiesReport] 获取订阅的远端用户的音量信息。
  /// + 通过 [RTCVideoEventHandler.onActiveSpeaker] 回调获取房间内的最活跃用户信息。
  Future<int?> enableAudioPropertiesReport(AudioPropertiesConfig config);

  /// 调节来自指定远端用户的音频播放音量
  ///
  /// [roomId]：远端用户所属的房间 ID。
  ///
  /// [uid]：音频来源的远端用户 ID。
  ///
  /// [volume]：音频播放音量值和原始音量的比值，范围是 `[0, 400]`，单位为 %，自带溢出保护。  <br>
  /// 只改变音频数据的音量信息，不涉及本端硬件的音量调节。<br>
  /// 为保证更好的通话质量，建议将 volume 值设为 `[0,100]`。
  /// + 0：静音；
  /// + 100：原始音量，默认值  <br>
  /// + 400：最大可为原始音量的 4 倍(自带溢出保护)
  ///
  /// 返回值参看 [ReturnStatus]。
  ///
  /// 假设某远端用户 A 始终在被调节的目标用户范围内：
  /// + 当该方法与 [RTCRoom.setRemoteRoomAudioPlaybackVolume] 共同使用时，本地收听用户 A 的音量为后调用的方法设置的音量；
  /// + 当该方法与 [RTCVideo.setPlaybackVolume] 方法共同使用时，本地收听用户 A 的音量将为两次设置的音量效果的叠加。
  Future<int?> setRemoteAudioPlaybackVolume({
    required String roomId,
    required String uid,
    required int volume,
  });

  /// 开启/关闭耳返功能。
  ///
  /// [mode] 耳返功能是否开启。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 耳返功能仅适用于由 RTC SDK 内部采集的音频。
  /// + 使用耳返功能必须佩戴耳机。为保证低延时耳返最佳体验，建议佩戴有线耳机。蓝牙耳机不支持硬件耳返。 <br>
  /// + RTC SDK 支持硬件耳返和软件耳返。一般来说，硬件耳返延时低且音质好。如果 App 在手机厂商的硬件耳返白名单内，且运行环境存在支持硬件耳返的 SDK，RTC SDK 默认启用硬件耳返。使用华为手机硬件耳返功能时，请添加[华为硬件耳返的依赖配置](https://www.volcengine.com/docs/6348/1155036#%E5%A6%82%E4%BD%95%E5%9C%A8%E5%8D%8E%E4%B8%BA%E6%89%8B%E6%9C%BA%E4%BD%BF%E7%94%A8%E7%A1%AC%E4%BB%B6%E8%80%B3%E8%BF%94%E5%8A%9F%E8%83%BD%EF%BC%9F)。
  Future<int?> setEarMonitorMode(EarMonitorMode mode);

  /// 设置耳返的音量。
  ///
  /// [volume] 是耳返的音量相对原始音量的比值，取值范围：`[0,100]`，单位：%。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// 设置耳返音量前，你必须先调用 [RTCVideo.setEarMonitorMode] 打开耳返功能。
  Future<int?> setEarMonitorVolume(int volume);

  /// 在纯媒体音频场景下,切换 iOS 设备与耳机之间的蓝牙传输协议<br>
  /// 仅 iOS 适用。
  ///
  /// [mode]：蓝牙传输协议。
  ///
  /// 以下场景你会收到 [RTCVideoEventHandler.onAudioDeviceWarning] 回调：
  /// + 当前不支持设置 HFP；
  /// + 非纯媒体音频场景，建议在调用此接口前调用 [setAudioScenario] 设置纯媒体音频场景。
  Future<int?> setBluetoothMode(BluetoothMode mode);

  /// 开启本地语音变调功能，多用于 K 歌场景
  ///
  /// 使用该方法，你可以对本地语音的音调进行升调或降调等调整。
  ///
  /// [pitch] 相对于语音原始音调的升高/降低值，取值范围 `[-12，12]`，默认值为 `0`，即不做调整。  <br>
  /// 取值范围内每相邻两个值的音高距离相差半音，正值表示升调，负值表示降调，设置的绝对值越大表示音调升高或降低越多。  <br>
  /// 超出取值范围则设置失败，并且会触发 [RTCVideoEventHandler.onWarning] 回调。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  Future<int?> setLocalVoicePitch(int pitch);

  /// 开启/关闭音量均衡功能
  ///
  /// 开启音量均衡功能后，人声的响度会调整为 -16lufs。如果已调用 [RTCMediaPlayer.setLoudness] 传入了混音音乐的原始响度，此音乐播放时，响度会调整为 -20lufs。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：该接口须在调用 [RTCMediaPlayer.start] 开始播放音频文件之前调用。
  Future<int?> enableVocalInstrumentBalance(bool enable);

  /// 打开/关闭音量闪避功能，适用于在 RTC 通话过程中会同时播放短视频或音乐的场景，如“一起看”、“在线 KTV”等
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 开启该功能后，当检测到远端人声时，本地的媒体播放音量会自动减弱，从而保证远端人声的清晰可辨；当远端人声消失时，本地媒体音量会恢复到闪避前的音量水平。
  Future<int?> enablePlaybackDucking(bool enable);

  /// 设置视频流发布端是否开启发布多路编码参数不同的视频流的模式，默认关闭。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 你应在进房前或进房后但未发布流时，调用此方法。
  /// + 开启推送多路视频流模式后，你可以调用 [RTCVideo.setVideoEncoderConfig] 为多路视频流分别设置编码参数。
  /// + 该功能关闭时，或该功能开启但未设置多路流参数时，默认只发一路视频流，该流的编码参数为：分辨率 640px × 360px，帧率 15fps。
  Future<int?> enableSimulcastMode(bool enable);

  /// 视频发布端设置期望发布的最大分辨率视频流参数，包括分辨率、帧率、码率、缩放模式、网络不佳时的回退策略等
  ///
  /// [maxSolution] 期望发布的最大分辨率视频流参数。
  ///
  /// 注意：
  /// + 你可以同时使用 [RTCVideo.enableSimulcastMode] 方法来发布多路分辨率不同的流。具体而言，若期望发布多路不同分辨率的流，你需要在发布流之前调用本方法以及 [RTCVideo.enableSimulcastMode] 方法开启多路流模式，SDK 会根据订阅端的设置智能调整发布的流数（最多发布 4 条）以及各路流的参数。其中，调用本方法设置的分辨率为各路流中的最大分辨率。具体规则参看[推送多路流](https://www.volcengine.com/docs/6348/70139)文档。
  /// + 调用该方法前，SDK 默认仅发布一条分辨率为 640px × 360px，帧率为 15fps 的视频流。
  /// + 该方法适用于摄像头采集的视频流，设置屏幕共享视频流参数参看 [RTCVideo.setScreenVideoEncoderConfig]。
  Future<int?> setMaxVideoEncoderConfig(VideoEncoderConfig maxSolution);

  /// 视频发布端设置推送多路流时各路流的参数，包括分辨率、帧率、码率、缩放模式、网络不佳时的回退策略等
  ///
  /// [channelSolutions] 要推送的多路视频流的参数，最多支持设置 3 路参数，超过 3 路时默认取前 3 路的值。<br>
  /// 当设置了多路参数时，分辨率和帧率必须是从大到小排列。需注意，所设置的分辨率是各路流的最大分辨率。
  ///
  /// 注意：
  /// + 该方法设置的多路参数是否均生效，取决于是否同时调用了 [RTCVideo.enableSimulcastMode] 开启发布多路参数不同的视频流模式。若未开启推送多路流模式，但调用本方法设置了多个分辨率，SDK 则默认发布设置的第一条流，多个分辨率的设置会在开启推送多路流模式之后生效。
  /// + 若期望推送多路不同分辨率的流，你需要在发布流之前调用本方法以及 [RTCVideo.enableSimulcastMode] 方法。
  /// + 调用该方法设置多路视频流参数前，SDK 默认仅发布一条分辨率为 640px × 360px，帧率为 15fps 的视频流。
  /// + 调用该方法设置分辨率不同的多条流后，SDK 会根据订阅端设置的期望订阅参数自动匹配发送的流，具体规则参看[推送多路流](https://www.volcengine.com/docs/6348/70139)文档。
  /// + 该方法适用于摄像头采集的视频流，设置屏幕共享视频流参数参看 [RTCVideo.setScreenVideoEncoderConfig]。
  Future<int?> setVideoEncoderConfig(List<VideoEncoderConfig> channelSolutions);

  /// 为发布的屏幕共享视频流设置期望的编码参数，包括分辨率、帧率、码率、缩放模式、网络不佳时的回退策略等
  ///
  /// [screenSolution]：屏幕共享视频流参数。
  ///
  /// 注意：
  /// + 调用该方法之前，屏幕共享视频流默认的编码参数为：分辨率 1920px × 1080px，帧率 15fps。
  /// + iOS 端使用该方法需在 [RTCVideo.startScreenCapture] 开启屏幕采集之前调用，之后调用不生效。
  Future<int?> setScreenVideoEncoderConfig(
      ScreenVideoEncoderConfig screenSolution);

  /// 设置 RTC SDK 内部采集时的视频采集参数，包括分辨率、帧率等
  ///
  /// 注意：
  /// + 本接口在引擎创建后可调用，调用后立即生效。建议在调用 [RTCVideo.startVideoCapture] 前调用本接口。
  /// + 建议同一设备上的不同引擎使用相同的视频采集参数。
  /// + 如果调用本接口前使用内部模块开始视频采集，采集参数默认为 Auto 模式。
  Future<int?> setVideoCaptureConfig(VideoCaptureConfig config);

  /// 取消设置本地视频画布
  Future<int?> removeLocalVideo([StreamIndex streamType = StreamIndex.main]);

  /// 取消设置远端视频画布
  Future<int?> removeRemoteVideo({
    required String roomId,
    required String uid,
    StreamIndex streamType = StreamIndex.main,
  });

  /// 开启内部视频采集，默认为关闭状态
  ///
  /// 调用该方法后，本地用户会收到 [RTCVideoEventHandler.onVideoDeviceStateChanged] 的回调。
  /// 可见用户进房后调用该方法，房间中的其他用户会收到 [RTCVideoEventHandler.onUserStartVideoCapture] 回调。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 若未取得当前设备的摄像头权限，调用该方法后会触发 [RTCVideoEventHandler.onVideoDeviceStateChanged] 回调。
  /// + 调用 [RTCVideo.stopVideoCapture] 可以关闭视频采集设备，否则，SDK 只会在销毁引擎的时候自动关闭设备。
  /// + 无论是否发布视频数据，你都可以调用该方法开启视频采集，并且调用后方可发布视频。
  /// + 内部视频采集使用的摄像头由 [RTCVideo.switchCamera] 接口指定。
  /// + Android 需要在 Gradle 里引入 Kotlin；iOS 需要在应用中向用户申请摄像头权限后才能开始采集。
  Future<int?> startVideoCapture();

  /// 关闭本地视频采集，默认为关闭状态
  ///
  /// 调用该方法，本地用户会收到 [RTCVideoEventHandler.onVideoDeviceStateChanged] 的回调。
  /// 可见用户进房后调用该方法，房间中的其他用户会收到 [RTCVideoEventHandler.onUserStopVideoCapture] 回调。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  ///  注意：
  /// + 调用 [RTCVideo.startVideoCapture] 可以开启视频采集设备。
  /// + 设备开启后若一直未调用该方法关闭，则 SDK 会在销毁引擎的时候自动关闭音频采集设备。
  Future<int?> stopVideoCapture();

  /// 为本地采集到的视频流开启镜像
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 切换视频源不影响镜像设置。
  /// + 屏幕视频流始终不受镜像设置影响。
  /// + 该接口调用前，各视频源的初始状态如下：
  /// <table border>
  /// <tr><th></th><th>前置摄像头</th><th>后置摄像头</th><th>桌面端摄像头</th>
  /// <tr><td>移动端</td><td>本地渲染镜像，编码传输不镜像</td><td> 本地渲染不镜像，编码传输不镜像 </td><td>/</td>
  /// <tr><td>桌面端</td><td>/</td><td>/</td><td> 本地渲染镜像，编码传输不镜像 </td>
  /// </table>
  Future<int?> setLocalVideoMirrorType(MirrorType mirrorType);

  /// 使用内部渲染时，为远端流开启镜像。
  ///
  /// v3.57 新增。
  ///
  /// [streamKey]：远端流信息，用于指定需要镜像的视频流来源及属性
  ///
  /// [mirrorType]：远端流的镜像类型
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  Future<int?> setRemoteVideoMirrorType(
      RemoteStreamKey streamKey, RemoteMirrorType mirrorType);

  /// 设置采集视频的旋转模式，默认以 App 方向为旋转参考系
  ///
  /// 接收端渲染视频时，将按照和发送端相同的方式进行旋转。
  ///
  /// [rotationMode] 视频旋转参考系为 App 方向或重力方向。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 旋转仅对内部视频采集生效，不适用于外部视频源和屏幕源。
  /// + 调用该接口时已开启视频采集，将立即生效；调用该接口时未开启视频采集，则将在采集开启后生效。
  /// + 更多信息请参考[视频采集方向](https://www.volcengine.com/docs/6348/106458)。
  Future<int?> setVideoRotationMode(VideoRotationMode rotationMode);

  /// 设置本端采集的视频帧的旋转角度
  ///
  /// v3.57 新增。
  ///
  /// 当外接摄像头倒置或者倾斜安装，且不支持重力感应时，调用本接口对采集画面角度进行调整。<br>
  /// 对于手机等支持重力感应的移动设备，需调用 [RTCVideo.setVideoRotationMode] 实现旋转。
  ///
  /// [rotation]：相机朝向角度，默认为 `rotation0(0)`，无旋转角度。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 对于内部采集的视频画面，如果已调用 [RTCVideo.setVideoRotationMode] 设置了旋转方向，会在此基础上叠加旋转角度。
  /// + 视频贴纸特效或通过 [RTCVideoEffect.enableVirtualBackground] 增加的虚拟背景，也会跟随本接口的设置进行旋转。
  /// + 本地渲染视频和发送到远端的视频都会相应旋转，但不会应用到单流转推中。如果希望在单流转推的视频中应用旋转，调用 [RTCVideo.setVideoOrientation]。
  Future<int?> setVideoCaptureRotation(VideoRotation rotation);

  /// 在自定义视频前处理及编码前，设置 RTC 链路中的视频帧朝向，默认为 Adaptive 模式
  ///
  /// 移动端开启视频特效贴纸，或使用自定义视频前处理时，建议固定视频帧朝向为 Portrait 模式。<br>
  /// 单流转推场景下，建议根据业务需要固定视频帧朝向为 Portrait 或 Landscape 模式。<br>
  /// 不同模式的具体显示效果参看[视频帧朝向](https://www.volcengine.com/docs/6348/128787)。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 设置视频帧朝向仅对内部视频采集生效，不适用于外部视频源和屏幕源。
  /// + 编码分辨率的更新与视频帧处理是异步操作，进房后切换视频帧朝向可能导致画面出现短暂的裁切异常，因此建议在进房前设置视频帧朝向，且不在进房后进行切换。
  Future<int?> setVideoOrientation(VideoOrientation orientation);

  /// 切换移动端前置/后置摄像头
  ///
  /// 调用此接口后，在本地会触发 [RTCVideoEventHandler.onVideoDeviceStateChanged] 回调。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 调用该方法前默认使用前置摄像头。
  /// + 如果你正在使用相机进行视频采集，切换操作当即生效；如果相机未启动，后续开启内部采集时，会打开设定的摄像头。
  Future<int?> switchCamera(CameraId cameraId);

  /// 获取视频特效接口。
  RTCVideoEffect get videoEffectInterface;

  /// 视频特效许可证检查
  ///
  /// [licenseFile]：许可证文件绝对路径
  ///
  /// 返回值：
  /// + 0：许可证验证成功；
  /// + 1000：未集成特效 SDK；
  /// + 1001：特效 SDK 不支持该功能；
  /// + <0：其他错误，具体参看[错误码表](https://www.volcengine.com/docs/6705/102042)。
  @Deprecated(
      'Deprecated since v3.51 and will be deleted in v3.57, use RTCVideoEffect.initCVResource instead.')
  Future<int?> checkVideoEffectLicense(String licenseFile);

  /// 创建/销毁视频特效引擎
  ///
  /// 返回值：
  /// + 0：成功；
  /// + 1000：未集成特效 SDK；
  /// + 1001：特效 SDK 不支持该功能；
  /// + <0：其他错误，具体参看[错误码表](https://www.volcengine.com/docs/6705/102042)。
  ///
  /// 注意：
  /// + 该方法须在调用 [RTCVideo.checkVideoEffectLicense] 和 [RTCVideo.setVideoEffectAlgoModelPath] 后调用。
  /// + 该方法不直接开启/关闭视频特效，你须在调用该方法后，调用 [RTCVideo.setVideoEffectNodes] 开启视频特效。
  /// + 通用场景下，特效引擎会随 RTC 引擎销毁而销毁。当你对性能有较高要求时，可在不使用特效相关功能时设该方法为 false 单独销毁特效引擎。
  @Deprecated(
      'Deprecated since v3.51 and will be deleted in v3.57, use RTCVideoEffect.enableVideoEffect and RTCVideoEffect.disableVideoEffect instead.')
  Future<int?> enableVideoEffect(bool enable);

  /// 设置视频特效算法模型路径
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  @Deprecated(
      'Deprecated since v3.51 and will be deleted in v3.57, use RTCVideoEffect.initCVResource instead.')
  Future<int?> setVideoEffectAlgoModelPath(String modelPath);

  /// 设置视频特效素材包
  ///
  /// [effectNodes] 特效素材包路径数组。
  /// 要取消当前视频特效，将此参数设置为 null。
  ///
  /// 返回值：
  /// + 0：成功；
  /// + 1000：未集成特效 SDK；
  /// + 1001：特效 SDK 不支持该功能；
  /// + <0：其他错误，具体参看[错误码表](https://www.volcengine.com/docs/6705/102042)。
  /// 注意：你须在调用 [RTCVideo.enableVideoEffect] 后调用该方法。
  @Deprecated(
      'Deprecated since v3.51 and will be deleted in v3.57, use RTCVideoEffect.setEffectNodes instead.')
  Future<int?> setVideoEffectNodes(List<String>? effectNodes);

  /// 设置特效强度
  ///
  /// [effectNode] 特效素材包路径
  ///
  /// [key] 需要设置的素材 key 名称，参看 [素材key对应说明](https://www.volcengine.com/docs/6705/102041)。
  ///
  /// [value] 需要设置的强度值，取值范围为 `[0,1]`，超出该范围设置无效。
  ///
  /// 返回值：
  /// + 0：成功；
  /// + 1000：未集成特效 SDK；
  /// + 1001：特效 SDK 不支持该功能；
  /// + <0：其他错误，具体参看[错误码表](https://www.volcengine.com/docs/6705/102042)。
  /// 注意：该接口仅适用于同时含有上述三个参数的特效资源，对于如大部分贴纸类等没有强度参数的特效，该接口调用无效。
  @Deprecated(
      'Deprecated since v3.51 and will be deleted in v3.57, use RTCVideoEffect.updateEffectNode instead.')
  Future<int?> updateVideoEffectNode({
    required String effectNode,
    required String key,
    required double value,
  });

  /// 设置颜色滤镜
  ///
  /// [resFile] 滤镜资源包绝对路径
  ///
  /// 返回值：
  /// + 0：成功；
  /// + 1000：未集成特效 SDK；
  /// + 1001：特效 SDK 不支持该功能；
  /// + <0：其他错误，具体参看[错误码表](https://www.volcengine.com/docs/6705/102042)。
  @Deprecated(
      'Deprecated since v3.51 and will be deleted in v3.57, use RTCVideoEffect.setColorFilter instead.')
  Future<int?> setVideoEffectColorFilter(String? resFile);

  /// 设置已启用的颜色滤镜强度
  ///
  /// [intensity] 滤镜强度，取值范围 `[0,1]`，超出范围时设置无效。
  ///
  /// 返回值：
  /// + 0：成功；
  /// + 1000：未集成特效 SDK；
  /// + 1001：特效 SDK 不支持该功能；
  /// + <0：其他错误，具体参看[错误码表](https://www.volcengine.com/docs/6705/102042)。
  @Deprecated(
      'Deprecated since v3.51 and will be deleted in v3.57, use RTCVideoEffect.setColorFilterIntensity instead.')
  Future<int?> setVideoEffectColorFilterIntensity(double intensity);

  /// 将摄像头采集画面中的人像背景替换为指定图片或纯色背景
  ///
  /// 若要取消背景特效，将背景贴纸特效素材路径设置为null。
  ///
  /// [modelPath] 传入背景贴纸特效素材路径。
  ///
  /// [source] 设置背景特效图片的本地路径。
  ///
  /// 返回值：
  /// + 0：成功；
  /// + 1000：未集成特效 SDK；
  /// + 1001：特效 SDK 不支持该功能；
  /// + <0：其他错误，具体参看[错误码表](https://www.volcengine.com/docs/6705/102042)。
  ///
  /// 调用此接口前需依次调用以下接口：
  /// 1. 检查视频特效许可证 [RTCVideo.checkVideoEffectLicense]；
  /// 2. 设置视频特效算法模型路径 [RTCVideo.setVideoEffectAlgoModelPath]；
  /// 3. 开启视频特效 [RTCVideo.enableVideoEffect]。
  @Deprecated(
      'Deprecated since v3.51 and will be deleted in v3.57, use RTCVideoEffect.enableVirtualBackground and RTCVideoEffect.disableVirtualBackground instead.')
  Future<int?> setBackgroundSticker({
    String? modelPath,
    VirtualBackgroundSource? source,
  });

  /// 注册人脸检测结果回调观察者
  ///
  /// 注册此观察者后，你会周期性收到 [RTCFaceDetectionObserver.onFaceDetectResult] 回调。
  ///
  /// [observer] 人脸检测结果回调观察者。
  ///
  /// [interval] 时间间隔，必须大于 0，单位：ms。实际收到回调的时间间隔大于 `interval`，小于 `interval + 视频采集帧间隔`。
  @Deprecated(
      'Deprecated since v3.51 and will be deleted in v3.57, use RTCVideoEffect.enableFaceDetection and RTCVideoEffect.disableFaceDetection instead.')
  Future<int?> registerFaceDetectionObserver({
    RTCFaceDetectionObserver? observer,
    int interval = 0,
  });

  /// 开启/关闭基础美颜
  ///
  /// 返回值
  /// + 0：开启/关闭成功。
  /// + 1000：未集成特效 SDK。
  /// + 1001：RTC SDK 版本不支持此功能。
  /// + 1002：特效 SDK 当前版本不支持此功能，建议使用特效 SDK v4.4.2+ 版本。
  /// + 1003：联系技术支持人员。
  /// + 1004：正在下载相关资源，下载完成后生效。
  /// + <0：调用失败，特效 SDK 内部错误，具体错误码请参考[错误码表](https://www.volcengine.com/docs/6705/102042)。
  ///
  /// 注意：
  /// + 本方法不能与高级视频特效接口共用。如已购买高级视频特效，建议调用 [RTCVideoEffect.enableVideoEffect] 使用高级特效、贴纸功能等。
  /// + 使用此功能需要集成特效 SDK，建议使用特效 SDK v4.4.2+ 版本。更多信息参看 [Flutter 基础美颜](https://www.volcengine.com/docs/6348/1182380)。
  /// + 调用 [RTCVideo.setBeautyIntensity] 设置基础美颜强度。若在调用本方法前没有设置美颜强度，则使用默认强度。各基础美颜模式的强度默认值分别为：美白 0.7，磨皮 0.8，锐化 0.5，清晰 0.7。
  /// + 本方法仅适用于视频源，不适用于屏幕源。
  Future<int?> enableEffectBeauty(bool enable);

  /// 调整基础美颜强度
  ///
  /// [beautyMode] 基础美颜模式。
  ///
  /// [intensity] 美颜强度，取值范围为 `[0,1]`。<br>
  /// 强度为 0 表示关闭，各基础美颜模式的强度默认值分别为：美白 0.7，磨皮 0.8，锐化 0.5，清晰 0.7。
  ///
  /// 返回值：
  /// + 0：成功；
  /// + 1000：未集成特效 SDK；
  /// + 1001：特效 SDK 不支持该功能；
  /// + <0：其他错误，具体参看[错误码表](https://www.volcengine.com/docs/6705/102042)。
  ///
  /// 注意：
  /// + 若在调用 [RTCVideo.enableEffectBeauty] 前设置美颜强度，则对应美颜功能的强度初始值会根据设置更新。
  /// + 销毁引擎后，美颜功能强度恢复默认值。
  Future<int?> setBeautyIntensity({
    required EffectBeautyMode beautyMode,
    required double intensity,
  });

  /// 设置远端视频超分模式
  ///
  /// [streamKey] 远端流信息，用于指定需要设置超分的视频流来源及属性
  ///
  /// [mode] 超分模式
  ///
  /// 返回值：
  /// + 0：kReturnStatusSuccess，SDK 调用成功，并不代表超分模式实际状态, 需要根据回调 [RTCVideoEventHandler.onRemoteVideoSuperResolutionModeChanged] 判断实际状态。
  /// + -1：kReturnStatusNativeInvalid，native library 未加载。
  /// + -2：kReturnStatusParameterErr，参数非法，指针为空或字符串为空。
  /// + -9：kReturnStatusScreenNotSupport，不支持对屏幕流开启超分。
  ///
  /// 注意：
  /// + 该方法须进房后调用。
  /// + 远端用户视频流的原始分辨率不能超过 640 × 360 px。
  /// + 支持对一路远端流开启超分，不支持对多路流开启超分。
  Future<int?> setRemoteVideoSuperResolution({
    required RemoteStreamKey streamKey,
    required VideoSuperResolutionMode mode,
  });

  /// 设置视频降噪模式
  ///
  /// [mode]：视频降噪模式，启用后能够增强视频画质，但同时会增加性能负载。
  ///
  /// 返回值：
  /// + 0：API 调用成功。 用户可以根据回调函数 [RTCVideoEventHandler.onVideoDenoiseModeChanged] 判断视频降噪是否开启。
  /// + < 0：API 调用失败。
  Future<int?> setVideoDenoiser({
    required VideoDenoiseMode mode,
  });

  /// 设置当前使用的摄像头（前置/后置）的光学变焦倍数
  ///
  /// [zoom] 变焦倍数，取值范围是 `[1, <最大变焦倍数>]`。<br>
  /// 最大变焦倍数可以通过调用 [RTCVideo.getCameraZoomMaxRatio] 获取。
  ///
  /// 注意：
  /// + 设置结果在调用 [RTCVideo.stopVideoCapture] 关闭内部采集后失效。
  /// + 你可以调用 [setVideoDigitalZoomConfig] 设置数码变焦参数，调用 [setVideoDigitalZoomControl] 进行数码变焦。
  Future<int?> setCameraZoomRatio(double zoom);

  /// 获取当前使用的摄像头（前置/后置）的最大变焦倍数
  Future<double?> getCameraZoomMaxRatio();

  /// 检测当前使用的摄像头（前置/后置），是否支持变焦（数码/光学变焦）
  Future<bool?> isCameraZoomSupported();

  /// 检测当前使用的摄像头（前置/后置），是否支持闪光灯
  Future<bool?> isCameraTorchSupported();

  /// 打开/关闭当前使用的摄像头（前置/后置）的闪光灯
  ///
  /// 注意：设置结果在调用 [RTCVideo.stopVideoCapture] 关闭内部采集后失效。
  Future<int?> setCameraTorch(TorchState torchState);

  /// 检查当前使用的摄像头是否支持手动对焦
  Future<bool?> isCameraFocusPositionSupported();

  /// 设置当前使用的摄像头的对焦点
  ///
  /// [position] 对焦点归一化二维坐标值，以本地预览画布的左上为原点，取值范围为 `[0, 1]`。
  ///
  /// 注意：
  /// + 移动设备时，自动取消对焦点设置。
  /// + 调用 [RTCVideo.stopVideoCapture] 关闭内部采集后，设置的对焦点失效。
  Future<int?> setCameraFocusPosition(Offset position);

  /// 检查当前使用的摄像头是否支持手动设置曝光点
  Future<bool?> isCameraExposurePositionSupported();

  /// 设置当前使用的摄像头的曝光点
  ///
  /// [position] 曝光点归一化二维坐标值，以本地预览画布的左上为原点，取值范围为 `[0, 1]`。
  ///
  /// 注意：
  /// + 移动设备时，自动取消曝光点设置。
  /// + 调用 [RTCVideo.stopVideoCapture] 关闭内部采集后，设置的曝光点失效。
  Future<int?> setCameraExposurePosition(Offset position);

  /// 设置当前使用的摄像头的曝光补偿
  ///
  /// [val] 曝光补偿值，取值范围 `[-1, 1]`，`0` 为系统默认值(没有曝光补偿)。
  ///
  /// 注意：调用 [RTCVideo.stopVideoCapture] 关闭内部采集后，设置的曝光补偿失效。
  Future<int?> setCameraExposureCompensation(double val);

  /// 启用或禁用内部采集时人脸自动曝光模式。此模式会改善强逆光下，脸部过暗的问题；但也会导致 ROI 以外区域过亮/过暗的问题。
  ///
  /// v3.54 新增。
  ///
  /// 返回值：
  /// + `0`：成功。
  /// + `<0`：失败。
  ///
  /// 你必须在调用 [RTCVideo.startVideoCapture] 开启采集前，调用此接口方可生效。
  Future<int?> enableCameraAutoExposureFaceMode(bool enable);

  /// 设置内部采集适用动态帧率时，帧率的最小值。
  ///
  /// v3.54 新增。
  ///
  /// [framerate]：最小值。单位为 fps。默认值是 7。<br>
  /// 动态帧率的最大帧率是通过 [RTCVideo.setVideoCaptureConfig] 设置的帧率值。当传入参数大于最大帧率时，使用固定帧率模式，帧率为最大帧率；当传入参数小于最大帧率时，使用动态帧率。
  ///
  /// 返回值：
  /// + 0：成功。
  /// + !0：失败。
  ///
  /// 注意：
  /// + 你必须在调用 [RTCVideo.startVideoCapture] 开启采集前，调用此接口方可生效。
  /// + 如果由于性能降级、静态适配等原因导致采集最大帧率变化时，已设置的最小帧率值会与新的采集最大帧率值重新比较。比较结果变化可能导致固定/动态帧率模式切换。
  Future<int?> setCameraAdaptiveMinimumFrameRate(int framerate);

  /// 通过视频帧发送 SEI 数据。
  ///
  /// 在视频通话场景下，SEI 数据会随视频帧发送；在语音通话场景下，SDK 会自动生成一路 16px × 16px 的黑帧视频流用来发送 SEI 数据。
  ///
  /// [streamIndex]：指定携带 SEI 数据的媒体流类型。<br>
  /// 语音通话场景下，该值需设为 `main`，否则 SEI 数据会被丢弃从而无法送达远端。
  ///
  /// [message]：是 SEI 消息内容，超过 4KB 的消息会被丢弃。
  ///
  /// [repeatCount]：是消息发送重复次数。取值范围是 `[0, max{29, %{视频帧率}-1}]`。推荐范围 `[2,4]`。<br>
  /// 调用此接口后，这些 SEI 数据会添加到从当前视频帧开始的连续 `%{repeat_count}+1` 个视频帧中。
  ///
  /// [mode]：SEI 发送模式。
  ///
  /// 返回值：
  /// + `>=0`：将被添加到视频帧中的 SEI 的数量
  /// + `<0`：发送失败
  ///
  /// 注意：
  /// + SEI 数据会随视频帧发送。每秒发送的 SEI 消息数量建议不超过当前的视频帧率。在语音通话场景下，SDK 会自动生成一路 16px × 16px 的黑帧视频流用来发送 SEI 数据，帧率为 15 fps。
  /// + 语音通话场景中，仅支持在内部采集模式下调用该接口发送 SEI 数据。
  /// + 视频通话场景中，如果自定义采集的原视频帧中已添加了 SEI 数据，则调用此方法不生效。
  /// + 视频帧仅携带前后 2s 内收到的 SEI 数据；语音通话场景下，若调用此接口后 1min 内未有 SEI 数据发送，则 SDK 会自动取消发布视频黑帧。
  /// + 消息发送成功后，远端会收到 [RTCVideoEventHandler.onSEIMessageReceived] 回调。
  /// + 语音通话切换至视频通话时，会停止使用黑帧发送 SEI 数据，自动转为用采集到的正常视频帧发送 SEI 数据。
  Future<int?> sendSEIMessage({
    StreamIndex streamIndex = StreamIndex.main,
    required Uint8List message,
    required int repeatCount,
    SEICountPerFrame mode = SEICountPerFrame.single,
  });

  /// 公共流视频帧发送 SEI 数据
  ///
  /// [streamIndex]：指定携带 SEI 数据的媒体流类型。<br>
  ///
  /// [channelId]： SEI 消息传输通道，取值范围 [0 - 255]。通过此参数，你可以为不同接受方设置不同的 ChannelID，这样不同接收方可以根据回调中的 ChannelID 选择应关注的 SEI 信息。
  ///
  /// [message]：SEI 消息长度，建议每帧 SEI 数据总长度长度不超过 4 KB。
  ///
  /// [repeatCount]：是消息发送重复次数。取值范围是 `[0, max{29, %{视频帧率}-1}]`。推荐范围 `[2,4]`。<br>
  /// 调用此接口后，这些 SEI 数据会添加到从当前视频帧开始的连续 `%{repeat_count}+1` 个视频帧中。
  ///
  /// [mode]：SEI 发送模式。
  ///
  /// 返回值：
  /// + `>0`：将被添加到视频帧中的 SEI 的数量
  /// + `=0`：当前发送队列已满，无法发送
  /// + `<0`：发送失败
  ///
  /// 注意：
  /// + 每秒发送的 SEI 消息数量建议不超过当前的视频帧率。
  /// + 视频通话场景中，如果自定义采集的原视频帧中已添加了 SEI 数据，则调用此方法不生效。
  /// + 视频帧仅携带前后 2s 内收到的 SEI 数据；语音通话场景下，若调用此接口后 1min 内未有 SEI 数据发送，则 SDK 会自动取消发布视频黑帧。
  /// + 消息发送成功后，远端会收到 [RTCVideoEventHandler.onPublicStreamSEIMessageReceivedWithChannel] 回调。
  /// + 调用失败时，本地及远端都不会收到回调。
  Future<int?> sendPublicStreamSEIMessage(
      {StreamIndex streamIndex,
      required int channelId,
      required Uint8List message,
      required int repeatCount,
      SEICountPerFrame mode = SEICountPerFrame.single});

  /// 设置本地摄像头数码变焦参数，包括缩放倍数，移动步长。
  ///
  /// v3.51 新增。
  ///
  /// [type]：数码变焦参数类型，缩放系数或移动步长。必填。
  ///
  /// [size]：缩放系数或移动步长，保留到小数点后三位。默认值为 0。必填。<br>
  /// 选择不同 `type` 时有不同的取值范围。当计算后的结果超过缩放和移动边界时，取临界值：
  /// + `focusOffset`：缩放系数增量，范围为 `[0, 7]`。例如，设置为 0.5 时，如果调用 [setVideoDigitalZoomControl] 选择 `cameraZoomIn`，则缩放系数增加 0.5。缩放系数范围 `[1，8]`，默认为 `1`，原始大小。
  /// + `moveOffset`：移动百分比，范围为 `[0, 0.5]`，默认为 0，不移动。如果调用 [setVideoDigitalZoomControl] 选择的是左右移动，则移动距离为 size x 原始视频宽度；如果选择的是上下移动，则移动距离为 size x 原始视频高度。例如，视频帧边长为 1080 px，设置为 0.5 时，实际移动距离为 0.5 x 1080 px = 540 px。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 每次调用本接口只能设置一种参数。如果缩放系数和移动步长都需要设置，分别调用本接口传入相应参数。
  /// + 由于移动步长的默认值为 `0`，在调用 [setVideoDigitalZoomControl] 或 [startVideoDigitalZoomControl] 进行数码变焦操作前，应先调用本接口。
  Future<int?> setVideoDigitalZoomConfig({
    required ZoomConfigType type,
    double size,
  });

  /// 控制本地摄像头数码变焦，缩放或移动一次。设置对本地预览画面和发布到远端的视频都生效。
  ///
  /// v3.51 新增。
  ///
  /// [direction]：数码变焦操作类型。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 由于默认步长为 `0`，调用该方法前需通过 [setVideoDigitalZoomConfig] 设置参数。
  /// + 调用该方法进行移动前，应先使用本方法或 [startVideoDigitalZoomControl] 进行放大，否则无法移动。
  /// + 当数码变焦操作超出范围时，将置为临界值。例如，移动到了图片边界、放大到了 8 倍、缩小到原图大小。
  /// + 如果你希望实现持续数码变焦操作，调用 [startVideoDigitalZoomControl]。
  /// + 你还可以对摄像头进行光学变焦控制，参看 [setCameraZoomRatio]。
  Future<int?> setVideoDigitalZoomControl(ZoomDirectionType direction);

  /// 开启本地摄像头持续数码变焦，缩放或移动。设置对本地预览画面和发布到远端的视频都生效。
  ///
  /// v3.51 新增。
  ///
  /// [direction]：数码变焦操作类型。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 由于默认步长为 `0`，调用该方法前需通过 [setVideoDigitalZoomConfig] 设置参数。
  /// + 调用该方法进行移动前，应先使用本方法或 [setVideoDigitalZoomControl] 进行放大，否则无法移动。
  /// + 当数码变焦操作超出范围时，将置为临界值并停止操作。例如，移动到了图片边界、放大到了 8 倍、缩小到原图大小。
  /// + 你也可以调用 [stopVideoDigitalZoomControl] 手动停止控制。
  /// + 如果你希望实现单次数码变焦操作，调用 [setVideoDigitalZoomControl]。
  /// + 你还可以对摄像头进行光学变焦控制，参看 [setCameraZoomRatio]。
  Future<int?> startVideoDigitalZoomControl(ZoomDirectionType direction);

  /// 停止本地摄像头持续数码变焦。
  ///
  /// v3.51 新增。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 关于开始数码变焦，参看 [startVideoDigitalZoomControl]。
  Future<int?> stopVideoDigitalZoomControl();

  /// 强制切换当前的音频播放路由
  ///
  /// 默认使用 [setDefaultAudioRoute] 中设置的音频路由。<br>
  /// 音频播放路由发生变化时，会收到 [RTCVideoEventHandler.onAudioRouteChanged] 回调。
  ///
  /// [audioRoute]：音频播放路由。<br>
  /// 对 Android 设备，不同的音频设备连接状态下，可切换的音频设备情况不同。参见[移动端设置音频路由](https://www.volcengine.com/docs/6348/117836)。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 你必须调用 [setAudioScenario] 将音频场景切换为 `communication` 后，再调用本接口。
  /// + 对于绝大多数音频场景，使用 [setDefaultAudioRoute] 设置默认音频路由，并借助 RTC SDK 的音频路由自动切换逻辑即可完成。切换逻辑参见[移动端设置音频路由](https://www.volcengine.com/docs/6348/117836)。你应仅在例外的场景下，使用此接口，比如在接入外接音频设备时，手动切换音频路由。
  /// + 不同音频场景中，音频路由和发布订阅状态到音量类型的映射关系详见 [AudioScenario]。
  Future<int?> setAudioRoute(AudioRoute audioRoute);

  /// 将默认的音频播放设备设置为听筒或扬声器
  ///
  /// 返回值：
  /// + `0`：方法调用成功。立即生效。当所有音频外设移除后，音频路由将被切换到默认设备。
  /// + `<0`：方法调用失败。指定除扬声器和听筒以外的设备将会失败。
  ///
  /// 注意：
  /// + 进房前后都可以调用。
  /// + 音频路由切换逻辑参看[音频路由](https://www.volcengine.com/docs/6348/117836)。
  Future<int?> setDefaultAudioRoute(AudioRoute audioRoute);

  /// 获取当前使用的音频播放路由
  ///
  /// 设置音频路由，详见 [RTCVideo.setAudioRoute]。
  Future<AudioRoute> getAudioRoute();

  /// 启用匹配外置声卡的音频处理模式
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 当采用外接声卡进行音频采集时，建议开启此模式，以获得更好的音质。
  /// + 开启此模式时，仅支持耳机播放。如果需要使用扬声器或者外置音箱播放，关闭此模式。
  Future<int?> enableExternalSoundCard(bool enable);

  /// 新增转推直播任务，并设置合流的图片、视频视图布局和音频属性
  ///
  /// 同一个任务中转推多路直播流时，SDK 会先将多路流合成一路流，然后再进行转推。
  ///
  /// [taskId] 转推直播任务 ID。<br>
  /// 你可以在同一房间内发起多个转推直播任务，并用不同的任务 ID 加以区。当你需要发起多个转推直播任务时，应使用多个 ID；当你仅需发起一个转推直播任务时，建议使用空字符串。
  ///
  /// [transcoding] 转推直播配置参数。
  ///
  /// [observer] 端云一体转推直播观察者。<br>
  /// 通过注册 observer 接收转推直播相关的回调。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 调用该方法后，关于启动结果和推流过程中的错误，会收到 [RTCLiveTranscodingObserver.onStreamMixingEvent] 回调。
  /// + 调用 [RTCVideo.stopLiveTranscoding] 停止转推直播。
  @Deprecated('Deprecated since v3.54, use startPushMixedStreamToCDN instead')
  Future<int?> startLiveTranscoding({
    required String taskId,
    required LiveTranscoding transcoding,
    required RTCLiveTranscodingObserver observer,
  });

  /// 停止转推直播
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  @Deprecated('Deprecated since v3.54, use stopPushStreamToCDN instead')
  Future<int?> stopLiveTranscoding(String taskId);

  /// 更新转推直播参数
  ///
  /// [transcoding] 转推直播配置参数。除特殊说明外，均支持过程中更新。调用时，结构体中没有传入值的属性，会被更新为默认值。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  @Deprecated('Deprecated since v3.54, use updatePushMixedStreamToCDN instead')
  Future<int?> updateLiveTranscoding({
    required String taskId,
    required LiveTranscoding transcoding,
  });

  /// 新增合流转推直播任务，并设置合流的图片、视频视图布局和音频属性。
  ///
  /// v3.54 新增。
  ///
  /// 同一个任务中转推多路直播流时，SDK 会先将多路流合成一路流，然后再进行转推。
  ///
  /// [taskId]：转推直播任务 ID，长度不超过 126 字节。<br>
  /// 你可以在同一房间内发起多个转推直播任务，并用不同的任务 ID 加以区分。当你需要发起多个转推直播任务时，应使用多个 ID；当你仅需发起一个转推直播任务时，建议使用空字符串。
  ///
  /// [mixedConfig]：推直播配置参数。
  ///
  /// [observer]：端云一体转推直播观察者。通过注册 observer 接收转推直播相关的回调。
  ///
  /// 返回值：
  /// + 0：成功；
  /// + !0：失败。具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 调用该方法后，关于启动结果和推流过程中的错误，会收到 [RTCMixedStreamObserver.onMixingEvent] 回调。
  /// + 调用 [RTCVideo.stopPushStreamToCDN] 停止转推直播。
  Future<int?> startPushMixedStreamToCDN({
    required String taskId,
    required MixedStreamConfig mixedConfig,
    RTCMixedStreamObserver? observer,
  });

  /// 更新合流转推直播参数，会收到 [RTCMixedStreamObserver.onMixingEvent] 回调。
  ///
  /// v3.54 新增。
  ///
  /// 使用 [RTCVideo.startPushMixedStreamToCDN] 启用转推直播功能后，使用此方法更新功能配置参数。
  ///
  /// [taskId]：转推直播任务 ID。指定想要更新参数设置的转推直播任务。
  ///
  /// [mixedConfig]：转推直播配置参数。除特殊说明外，均支持过程中更新。<br>
  /// 调用时，结构体中没有传入值的属性，会被更新为默认值。
  ///
  /// 返回值：
  /// + 0：成功；
  /// + !0：失败。具体原因参看 [ReturnStatus]
  Future<int?> updatePushMixedStreamToCDN({
    required String taskId,
    required MixedStreamConfig mixedConfig,
  });

  /// 新增单流转推直播任务
  ///
  /// [taskId] 任务 ID。<br>
  /// 你可以发起多个转推直播任务，并用不同的任务 ID 加以区分。当你需要发起多个转推直播任务时，应使用多个 ID；当你仅需发起一个转推直播任务时，建议使用空字符串。
  ///
  /// [param] 转推直播配置参数。
  ///
  /// [observer] 单流转推直播观察者。<br>
  /// 通过注册 observer 接收单流转推直播相关的回调。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 调用该方法后，关于启动结果和推流过程中的错误，会收到 [RTCPushSingleStreamToCDNObserver.onStreamPushEvent] 回调。
  /// + 调用 [RTCVideo.stopPushStreamToCDN] 停止任务。
  Future<int?> startPushSingleStreamToCDN({
    required String taskId,
    required PushSingleStreamParam param,
    required RTCPushSingleStreamToCDNObserver observer,
  });

  /// 停止单流转推直播任务
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  Future<int?> stopPushStreamToCDN(String taskId);

  /// 发布一路公共流
  ///
  /// 公共流是指不属于任何房间，也不属于任何用户的媒体流。使用同一 `appID` 的用户，可以调用 [RTCVideo.startPlayPublicStream] 获取和播放指定的公共流。
  ///
  /// [publicStreamId] 公共流 ID
  ///
  /// [publicStreamParam] 公共流参数。<br>
  /// 一路公共流可以包含多路房间内的媒体流，按照指定的布局方式进行聚合。<br>
  /// 如果指定的媒体流还未发布，则公共流将在指定流开始发布后实时更新。
  ///
  /// 返回值：
  /// + 0：成功。同时将收到 [RTCVideoEventHandler.onPushPublicStreamResult] 回调。
  /// + !0：失败。当参数不合法或参数为空，调用失败。
  ///
  /// 注意：
  /// + 同一用户使用同一公共流 ID 多次调用本接口无效。如果你希望更新公共流参数，调用 [RTCVideo.updatePublicStreamParam] 接口。
  /// + 不同用户使用同一公共流 ID 多次调用本接口时，RTC 将使用最后一次调用时传入的参数更新公共流。
  /// + 使用不同的 ID 多次调用本接口可以发布多路公共流。
  /// + 调用 [RTCVideo.stopPushPublicStream] 停止推公共流。
  /// + 使用发布公共流功能前请联系技术支持人员开通
  /// + 关于公共流功能的介绍，详见[发布和订阅公共流](https://www.volcengine.com/docs/6348/108930)
  Future<int?> startPushPublicStream({
    required String publicStreamId,
    required PublicStreaming publicStreamParam,
  });

  /// 停止发布公共流
  Future<int?> stopPushPublicStream(String publicStreamId);

  /// 更新发布的公共流参数
  Future<int?> updatePublicStreamParam({
    required String publicStreamId,
    required PublicStreaming publicStreamParam,
  });

  /// 订阅指定公共流
  ///
  /// 无论用户是否在房间内，都可以调用本接口获取和播放指定的公共流。<br>
  /// 如果指定流暂未发布，则本地客户端将在其开始发布后接收到流数据。
  ///
  /// 返回值：
  /// + 0：成功。同时将收到 [RTCVideoEventHandler.onPlayPublicStreamResult] 回调。
  /// + !0：失败。当参数不合法或参数为空，调用失败。
  ///
  /// 注意：
  /// + 在调用本接口之前，建议先绑定渲染视图。
  /// + 调用本接口后，可以通过 [RTCVideoEventHandler.onFirstPublicStreamVideoFrameDecoded] 和 [RTCVideoEventHandler.onFirstPublicStreamAudioFrame] 回调公共流的视频和音频首帧解码情况。
  /// + 调用本接口后，可以通过 [RTCVideoEventHandler.onPublicStreamSEIMessageReceived] 回调公共流中包含的 SEI 信息。
  /// + 调用 [RTCVideo.stopPlayPublicStream] 取消订阅公共流。
  Future<int?> startPlayPublicStream(String publicStreamId);

  /// 取消订阅指定公共流
  Future<int?> stopPlayPublicStream(String publicStreamId);

  /// 取消设置公共流视频画布
  Future<int?> removePublicStreamVideo(String publicStreamId);

  /// 调节公共流的音频播放音量。
  ///
  /// v3.51 新增。
  ///
  /// [publicStreamId]：公共流 ID。
  ///
  /// [volume]：音频播放音量值和原始音量值的比值，该比值的范围是 `[0, 400]`，单位为 %，且自带溢出保护。为保证更好的音频质量，建议设定在 `[0, 100]` 之间，其中 100 为系统默认值。
  ///
  /// 返回值：
  /// + 0：成功调用。
  /// + -2：参数错误。
  Future<int?> setPublicStreamAudioPlaybackVolume({
    required String publicStreamId,
    required int volume,
  });

  /// 设置业务标识参数。
  ///
  /// 可通过 [businessId] 区分不同的业务场景（角色/策略等）。businessId 由客户自定义，相当于一个“标签”，可以分担和细化现在 AppId 的逻辑划分的功能。
  ///
  /// 返回值：
  /// + 0： 成功
  /// + -2: parameterErr，参数错误。
  ///
  /// 注意：
  /// + businessId 只是一个标签，颗粒度需要用户自定义。
  /// + 该方法需要在进房前调用
  Future<int?> setBusinessId(String businessId);

  /// 将用户反馈的问题上报到 RTC
  ///
  /// [types] 是预设的问题类型集合，可多选。
  /// [info] 是预设问题以外的其他问题的具体描述
  ///
  /// 返回值：
  /// + 0：上报成功
  /// + -1：上报失败，还没加入过房间
  /// + -2：上报失败，数据解析错误
  /// + -3：上报失败，字段缺失
  ///
  /// 注意：如果用户上报时在房间内，那么问题会定位到用户当前所在的一个或多个房间；如果用户上报时不在房间内，那么问题会定位到引擎此前退出的房间。
  Future<int?> feedback({
    required List<ProblemFeedbackOption> types,
    ProblemFeedbackInfo? info,
  });

  /// 设置发布的音视频流回退选项
  ///
  /// 你可以调用该接口设置网络不佳或设备性能不足时从大流起进行降级处理，以保证通话质量。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// + 该方法仅在调用 [RTCVideo.enableSimulcastMode] 开启了发送多路视频流的情况下生效。
  /// + 你必须在进房前设置，进房后设置或更改设置无效。
  /// + 调用该方法后，如因性能或网络不佳产生发布性能回退或恢复，本端会提前收到 [RTCVideoEventHandler.onPerformanceAlarms] 回调发出的告警，以便采集设备配合调整。
  /// + 设置回退选项后，本端发布的音视频流发生回退或从回退中恢复时，订阅该音视频流的客户端会收到 [RTCVideoEventHandler.onSimulcastSubscribeFallback]，通知该情况。
  /// + 你可以调用客户端 API 或者在服务端下发策略设置回退。当使用服务端下发配置实现时，下发配置优先级高于客户端 API。
  Future<int?> setPublishFallbackOption(PublishFallbackOption option);

  /// 设置订阅的音视频流回退选项
  ///
  /// 你可调用该接口设置网络不佳或设备性能不足时允许订阅流进行降级或只订阅音频流，以保证通话流畅。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// + 你必须在进房前设置，进房后设置或更改设置无效。
  /// + 设置回退选项后，本端订阅的音视频流发生回退或从回退中恢复时,会收到 [RTCVideoEventHandler.onSimulcastSubscribeFallback]。
  /// + 你可以调用客户端 API 或者在服务端下发策略设置回退。当使用服务端下发配置实现时，下发配置优先级高于客户端 API。
  Future<int?> setSubscribeFallbackOption(SubscribeFallbackOption option);

  /// 设置指定远端用户在回退中的优先级
  ///
  /// + 该方法与 [RTCVideo.setSubscribeFallbackOption] 搭配使用。
  /// + 如果开启了订阅流回退选项，弱网或性能不足时会优先保证收到的高优先级用户的流的质量。
  /// + 该方法在进房前后都可以使用，可以修改远端用户的优先级。
  Future<int?> setRemoteUserPriority({
    required String roomId,
    required String uid,
    required RemoteUserPriority priority,
  });

  /// 设置传输时使用内置加密的方式
  ///
  /// [key] 是加密密钥，长度限制为 36 位，超出部分将会被截断
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：该方法必须在进房之前调用，可重复调用，以最后调用的参数作为生效参数。
  Future<int?> setEncryptInfo({
    required EncryptType aesType,
    required String key,
  });

  /// 创建房间实例。
  ///
  /// 调用此方法仅返回一个房间实例，你仍需调用 [RTCRoom.joinRoom] 才能真正地创建/加入房间。
  /// 多次调用此方法可以创建多个 [RTCRoom] 实例。分别调用各 RTCRoom 实例中的 [RTCRoom.joinRoom] 方法，同时加入多个房间。
  /// 多房间模式下，用户可以同时订阅各房间的音视频流。
  ///
  /// [roomId] 标识通话房间的房间 ID。该字符串符合正则表达式：`[a-zA-Z0-9_@\-\.]{1,128}`。
  ///
  /// 返回值：
  /// 创建的 [RTCRoom] 房间实例。
  ///
  /// 注意：
  /// + 如果需要加入的房间已存在，你仍需先调用本方法来获取 RTCRoom 实例，再调用 [RTCRoom.joinRoom] 加入房间。
  /// + 请勿使用同样的 roomId 创建多个房间，否则后创建的房间实例会替换先创建的房间实例。
  /// + 如果你需要在多个房间发布音视频流，无须创建多房间，直接调用 [RTCRoom.startForwardStreamToRooms]。
  Future<RTCRoom?> createRTCRoom(String roomId);

  /// 使用 RTC SDK 内部采集模块开始采集屏幕音频流和（或）视频流
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 屏幕共享相关接口仅适用于 iOS 12 及以上版本。
  /// + 对于 iOS，当从控制中心发起屏幕采集时无需调用本方法。
  /// + 采集后，你还需要调用 [RTCRoom.publishScreen] 发布采集到的屏幕音视频。
  /// + 开启屏幕音频/视频采集成功后，本地用户会收到 [RTCVideoEventHandler.onVideoDeviceStateChanged] 和 [RTCVideoEventHandler.onAudioDeviceStateChanged] 的回调。
  /// + 要关闭屏幕音视频内部采集，调用 [RTCVideo.stopScreenCapture]。
  Future<int?> startScreenCapture(ScreenMediaType type);

  /// 开启屏幕采集后，更新采集的媒体类型
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  Future<int?> updateScreenCapture(ScreenMediaType type);

  /// 屏幕共享时，停止屏幕流采集
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  Future<int?> stopScreenCapture();

  /// 仅适用于 iOS，向屏幕共享 Extension 发送自定义消息
  ///
  /// 注意：需在开启屏幕采集之后调用该方法
  Future<int?> sendScreenCaptureExtensionMessage(Uint8List message);

  /// 设置运行时的参数
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  Future<int?> setRuntimeParameters(Map<String, dynamic> params);

  /// 开启自动语音识别服务
  ///
  /// 该方法将识别后的用户语音转化成文字，并通过 [RTCASREngineEventHandler.onMessage] 回调。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  Future<int?> startASR({
    required RTCASRConfig asrConfig,
    required RTCASREngineEventHandler handler,
  });

  /// 关闭语音识别服务
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  Future<int?> stopASR();

  /// 将通话过程中的音视频数据录制到本地的文件中
  ///
  /// 返回值：
  /// + 0：正常
  /// + -1：参数设置异常
  /// + -2：当前版本 SDK 不支持该特性，请联系技术支持人员
  ///
  /// 注意：
  /// + 调用该方法后，你会收到 [RTCVideoEventHandler.onRecordingStateUpdate]
  /// + 如果录制正常，会每秒收到 [RTCVideoEventHandler.onRecordingProgressUpdate]
  Future<int?> startFileRecording({
    StreamIndex streamIndex = StreamIndex.main,
    required RecordingConfig config,
    required RecordingType recordingType,
  });

  /// 停止本地录制
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 调用 [RTCVideo.startFileRecording] 开启本地录制后，你必须调用该方法停止录制。
  /// + 调用该方法后，会收到 [RTCVideoEventHandler.onRecordingStateUpdate] 提示录制结果。
  Future<int?> stopFileRecording([StreamIndex streamIndex = StreamIndex.main]);

  /// 开启录制语音通话，生成本地文件。
  ///
  /// 在进房前后开启录制，如果未打开麦克风采集，录制任务正常进行，只是不会将数据写入生成的本地文件；只有调用 [startAudioCapture] 接口打开麦克风采集后，才会将录制数据写入本地文件。
  ///
  /// 返回值：方法调用结果
  /// + 0：正常
  /// + -2：参数设置异常
  /// + -3：当前版本 SDK 不支持该特性，请联系技术支持人员
  ///
  /// 注意：
  /// + 录制包含各种音频效果。但不包含混音的背景音乐。
  /// + 加入房间前后均可调用。在进房前调用该方法，退房之后，录制任务不会自动停止，需调用 [stopAudioRecording] 关闭录制。在进房后调用该方法，退房之后，录制任务会自动被停止。如果加入了多个房间，录制的文件中会包含各个房间的音频。
  /// + 调用该方法后，你会收到 [RTCVideoEventHandler.onAudioRecordingStateUpdate] 回调。
  Future<int?> startAudioRecording(AudioRecordingConfig config);

  /// 停止音频文件录制
  ///
  /// 返回值：方法调用结果
  /// + 0：正常；
  /// + -3：当前版本 SDK 不支持该特性，请联系技术支持人员。
  ///
  /// 调用 [startAudioRecording] 开启本地录制后，你必须调用该方法停止录制。
  Future<int?> stopAudioRecording();

  /// 创建混音管理接口实例
  @Deprecated(
      'Deprecated since v3.54, use RTCVideo.getAudioEffectPlayer and RTCVideo.getMediaPlayer instead')
  RTCAudioMixingManager get audioMixingManager;

  /// 创建音效播放器实例。
  ///
  /// v3.54 新增。
  ///
  /// 返回值：音效播放器实例。
  FutureOr<RTCAudioEffectPlayer?> getAudioEffectPlayer();

  /// 创建音乐播放器实例。
  ///
  /// v3.54 新增。
  ///
  /// [playerId]：音乐播放器实例 id。取值范围为 `[0, 3]`。最多同时存在4个实例，超出取值范围时返回 nullptr。
  ///
  /// 返回值：音乐播放器实例。
  FutureOr<RTCMediaPlayer?> getMediaPlayer(int playerId);

  /// 登录以发送房间外消息和向业务服务器发送消息
  ///
  /// 用户登录必须携带 [token]，用于鉴权验证。  <br>
  /// 登录 Token 与加入房间时必须携带的 Token 不同。<br>
  /// 测试时可使用控制台生成临时 Token，`roomId` 填任意值或置空，正式上线需要使用密钥 SDK 在你的服务端生成并下发 Token。
  ///
  /// [uid] 必须在 AppID 维度下唯一。
  ///
  /// 返回值：
  /// + `0`：成功
  /// + `-1`：失败。无效参数
  /// + `-2`：无效调用。用户已经登录。成功登录后再次调用本接口将收到此返回值
  /// + `-3`：失败。引擎为空。调用 [RTCVideo.createRTCVideo] 创建引擎实例后再调用本接口。
  ///
  /// 注意：
  /// + 登录后，如果想要登出，调用 [RTCVideo.logout]
  /// + 登录后，会收到 [RTCVideoEventHandler.onLoginResult]
  Future<int?> login({
    required String token,
    required String uid,
  });

  /// 登出
  ///
  /// 调用本接口登出后，无法调用房间外消息以及端到服务器消息相关的方法或收到相关回调。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 登出后，会收到 [RTCVideoEventHandler.onLogout]
  Future<int?> logout();

  /// 更新用户用于登录的 Token
  ///
  /// Token 有一定的有效期，当 Token 过期时，需调用此方法更新登录的 Token 信息。 <br>
  /// 调用 [RTCVideo.login] 登录时，如果使用了过期的 Token，将导致登录失败，并会收到 [RTCVideoEventHandler.onLoginResult]。此时需要重新获取 Token，并调用此方法更新 Token。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 如果 Token 无效导致登录失败，则调用此方法更新 Token 后，SDK 会自动重新登录，而不需要再次调用 [RTCVideo.login]。
  /// + Token 过期时，如果已经成功登录，则不会受到影响。Token 过期的错误会在下一次使用过期 Token 登录时，或因本地网络状况不佳导致断网重新登录时通知给用户。
  Future<int?> updateLoginToken(String token);

  /// 设置应用服务器参数
  ///
  /// 客户端调用 [RTCVideo.sendServerMessage] 或 [RTCVideo.sendServerBinaryMessage] 发送消息给业务服务器之前，必须设置有效签名和业务服务器地址。
  ///
  /// [signature] 是动态签名，应用服务器可使用该签名验证消息来源。<br>
  /// 签名需自行定义，可传入任意非空字符串，建议将 uid 等信息编码为签名。<br>
  /// 设置的签名会以 post 形式发送至通过本方法中 url 参数设置的应用服务器地址。
  ///
  /// [url] 是业务服务器的地址。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// + 必须先调用 [RTCVideo.login] 登录后，才能调用本接口。
  /// + 调用本接口后，会收到 [RTCVideoEventHandler.onServerParamsSetResult]。
  Future<int?> setServerParams({
    required String signature,
    required String url,
  });

  /// 发送消息前，查询指定远端用户或本地用户的登录状态
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// + 必须调用 [RTCVideo.login] 登录后，才能调用本接口。
  /// + 调用本接口后，会收到 [RTCVideoEventHandler.onGetPeerOnlineStatus]
  /// + 在发送房间外消息之前，用户可以通过本接口了解对端用户是否登录，从而决定是否发送消息。也可以通过本接口查询自己查看自己的登录状态。
  Future<int?> getPeerOnlineStatus(String peerUid);

  /// 给房间外指定的用户发送文本消息
  ///
  /// [message] 长度不超过 64KB。
  ///
  /// + 在发送房间外文本消息前，必须先调用 [RTCVideo.login] 登录。
  /// + 调用本接口发送文本信息后，会收到 [RTCVideoEventHandler.onUserMessageSendResultOutsideRoom]。
  /// + 若消息发送成功，则 [uid] 所指定的用户会收到 [RTCVideoEventHandler.onUserMessageReceivedOutsideRoom]。
  Future<int?> sendUserMessageOutsideRoom({
    required String uid,
    required String message,
    required MessageConfig config,
  });

  /// 给房间外指定的用户发送二进制消息
  ///
  /// [message] 长度不超过 46KB。
  ///
  /// + 在发送房间外二进制消息前，必须先调用 [RTCVideo.login] 登录。
  /// + 调用本接口发送文本信息后，会收到 [RTCVideoEventHandler.onUserMessageSendResultOutsideRoom]。
  /// + 若消息发送成功，则 [uid] 所指定的用户会收到 [RTCVideoEventHandler.onUserBinaryMessageReceivedOutsideRoom]。
  Future<int?> sendUserBinaryMessageOutsideRoom({
    required String uid,
    required Uint8List message,
    required MessageConfig config,
  });

  /// 客户端给业务服务器发送文本消息
  ///
  /// [message] 长度不超过 64 KB。
  ///
  /// + 在向应用服务器发送文本消息前，必须先调用 [RTCVideo.login] 登录，随后调用 [RTCVideo.setServerParams] 设置业务服务器。
  /// + 调用本接口发送文本信息后，会收到 [RTCVideoEventHandler.onServerMessageSendResult]。
  /// + 若消息发送成功，则应用服务器会收到此消息。
  Future<int?> sendServerMessage(String message);

  /// 客户端给业务服务器发送二进制消息
  ///
  /// [message] 长度不超过 46KB。
  ///
  /// + 在向应用服务器发送二进制消息前，必须先调用 [RTCVideo.login] 登录，随后调用 [RTCVideo.setServerParams] 设置业务服务器。
  /// + 调用本接口发送文本信息后，会收到 [RTCVideoEventHandler.onServerMessageSendResult]。
  /// + 若消息发送成功，则业务服务器会收到此消息。
  Future<int?> sendServerBinaryMessage(Uint8List message);

  /// 开启通话前网络探测
  ///
  /// [isTestUplink] 是否探测上行带宽
  ///
  /// [expectedUplinkBitrate] 设置期望上行带宽，单位：kbps。范围为 `{0, [100-10000]}`，其中， `0` 表示由 SDK 指定最高码率。
  ///
  /// [isTestDownlink] 是否探测下行带宽
  ///
  /// [expectedDownlinkBitrate] 设置期望下行带宽，单位：kbps。范围为 `{0, [100-10000]}`，其中， `0` 表示由 SDK 指定最高码率。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 成功调用本接口后，会在 3s 内收到一次 [RTCVideoEventHandler.onNetworkDetectionResult] 回调，此后每 2s 收到一次该回调，通知探测结果；
  /// + 若探测停止，则会收到一次 [RTCVideoEventHandler.onNetworkDetectionStopped] 通知探测停止。
  Future<int?> startNetworkDetection({
    required bool isTestUplink,
    required int expectedUplinkBitrate,
    required bool isTestDownlink,
    required int expectedDownlinkBitrate,
  });

  /// 停止通话前网络探测
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 调用本接口后，会收到 [RTCVideoEventHandler.onNetworkDetectionStopped] 回调通知探测停止。
  Future<int?> stopNetworkDetection();

  /// 在屏幕共享时，设置屏幕音频流和麦克风采集到的音频流的混流方式
  ///
  /// 通过 [index] 指定混流方式：
  /// + `main`：将屏幕音频流和麦克风采集到的音频流混流
  /// + `screen`：默认值，将屏幕音频流和麦克风采集到的音频流分为两路音频流
  ///
  /// 你应该在 [RTCRoom.publishScreen] 之前，调用此方法，否则你将收到 [RTCVideoEventHandler.onWarning] 报错。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  Future<int?> setScreenAudioStreamIndex(StreamIndex index);

  /// 发送音频流同步信息
  ///
  /// 将消息通过音频流发送到远端，并实现与音频流同步。
  ///
  /// [data] 长度必须是 `[1, 16]` 字节。
  ///
  /// 返回值：
  /// + `>=0`：消息发送成功。返回成功发送的次数。
  /// + `-1`：消息发送失败。消息长度大于 255 字节。
  /// + `-2`：消息发送失败。传入的消息内容为空。
  /// + `-3`：消息发送失败。通过屏幕流进行消息同步时，此屏幕流还未发布。
  /// + `-4`：消息发送失败。通过用麦克风采集到的音频流进行消息同步时，此音频流还未发布，详见错误码 [ErrorCode]。
  ///
  /// + 该接口调用成功后，远端用户会收到 [RTCVideoEventHandler.onStreamSyncInfoReceived]。
  /// + 调用本接口的频率建议不超过 50 次每秒。
  Future<int?> sendStreamSyncInfo({
    required Uint8List data,
    required StreamSyncInfoConfig config,
  });

  /// 控制本地音频流播放状态：播放/不播放
  ///
  /// 本方法仅控制本地收到音频流的播放状态，并不影响本地音频播放设备。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  @Deprecated(
      'Deprecated since v3.51 and will be deleted in v3.57, use RTCVideo.setPlaybackVolume instead.')
  Future<int?> muteAudioPlayback(bool muteState);

  /// 开启音视频回路测试
  ///
  /// 在进房前，用户可调用该接口对音视频通话全链路进行检测，包括对音视频设备以及用户上下行网络的检测，从而帮助用户判断是否可以正常发布和接收音视频流。  <br>
  /// 开始检测后，SDK 会录制你声音或视频。如果你在设置的延时范围内收到了回放，则视为音视频回路测试正常。
  ///
  /// [delayTime] 为音视频延迟播放的时间间隔，用于指定在开始检测多长时间后期望收到回放。取值范围为 `[2,10]`，单位为秒，默认为 2 秒。
  ///
  /// 返回值：方法调用结果
  /// + 0：成功
  /// + -1：失败，当前用户已经在检测中
  /// + -3：失败，音视频均未采集
  /// + -4：失败，参数异常
  /// + -5：失败，已经存在相同 roomId 的房间
  ///
  /// 注意：
  /// + 调用该方法开始音视频回路检测后，你可以调用 [RTCVideo.stopEchoTest] 立即结束测试，也可等待测试 60s 后自动结束，以更换设备进行下一次测试，或进房。
  /// + 在该方法之前调用的所有跟设备控制、流控制相关的方法均在开始检测时失效，在结束检测后恢复生效。
  /// + 在调用 [RTCVideo.startEchoTest] 和 [RTCVideo.stopEchoTest] 之间调用的所有跟设备采集、流控制、进房相关的方法均不生效，并会收到 [RTCVideoEventHandler.onWarning] 回调。
  /// + 音视频回路检测的结果会通过 [RTCVideoEventHandler.onEchoTestResult] 回调通知。
  Future<int?> startEchoTest({
    required EchoTestConfig config,
    required int delayTime,
  });

  /// 停止音视频回路测试
  ///
  /// 注意：
  /// + 调用 [RTCVideo.startEchoTest] 开启音视频回路检测后，你必须调用该方法停止检测。
  /// + 音视频回路检测结束后，所有对系统设备及音视频流的控制均会恢复到开始检测前的状态。
  Future<int?> stopEchoTest();

  /// 在指定视频流上添加水印
  ///
  /// [imagePath] 为水印图片路径，支持本地文件绝对路径、Asset 资源路径（/assets/xx.png）、URI 地址（content://），长度限制为 512 字节。  <br>
  /// 水印图片为 PNG 或 JPG 格式。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 调用 [RTCVideo.clearVideoWatermark] 移除指定视频流的水印。
  /// + 同一路流只能设置一个水印，新设置的水印会代替上一次的设置。你可以多次调用本方法来设置不同流的水印。
  /// + 进入房间前后均可调用此方法。
  /// + 若开启本地预览镜像，或开启本地预览和编码传输镜像，则远端水印均不镜像；在开启本地预览水印时，本端水印会镜像。
  /// + 开启大小流后，水印对大小流均生效，且针对小流进行等比例缩小。
  Future<int?> setVideoWatermark({
    StreamIndex streamIndex = StreamIndex.main,
    required String imagePath,
    required WatermarkConfig watermarkConfig,
  });

  /// 移除指定视频流的水印
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  Future<int?> clearVideoWatermark(
      [StreamIndex streamIndex = StreamIndex.main]);

  /// 截取本地视频画面
  ///
  /// [streamIndex]：截图的视频流的属性
  ///
  /// [filePath]：本地截图保存路径
  ///
  /// 方法调用成功则收到 [LocalSnapshot] 对象，调用失败则返回值如下：
  /// + -100：调用异常；
  /// + -101：未返回 taskId；
  /// + -102：文件写入失败；
  /// + -103：图片格式错误。
  ///
  /// 注意：对截取的画面，包含本地视频处理的全部效果，包含旋转，镜像，美颜等。
  CancelableOperation<LocalSnapshot> takeLocalSnapshot(
    StreamIndex streamIndex,
    String filePath,
  );

  /// 截取远端视频画面
  ///
  /// [streamKey]：截图的远端视频流信息
  ///
  /// [filePath]：远端截图保存路径
  ///
  /// 方法调用成功则收到 [RemoteSnapshot] 对象，调用失败则返回值如下：
  /// + -100：调用异常；
  /// + -101：未返回 taskId；
  /// + -102：文件写入失败；
  /// + -103：图片格式错误。
  CancelableOperation<RemoteSnapshot> takeRemoteSnapshot(
    RemoteStreamKey streamKey,
    String filePath,
  );

  /// 开启云代理
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 在加入房间前调用此接口。
  /// + 在开启云代理后，进行通话前网络探测。
  /// + 开启云代理后，并成功链接云代理服务器后，会收到 [RTCVideoEventHandler.onCloudProxyConnected]。
  /// + 要关闭云代理，调用 [RTCVideo.stopCloudProxy]。
  Future<int?> startCloudProxy(List<CloudProxyInfo> cloudProxiesInfo);

  /// 关闭云代理
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  Future<int?> stopCloudProxy();

  /// 创建 K 歌评分管理接口
  FutureOr<RTCSingScoringManager?> getSingScoringManager();

  /// 摄像头处于关闭状态时，使用静态图片填充本地推送的视频流。
  ///
  /// 可重复调用该接口来更新图片。若要停止发送图片，可传入空字符串或启用内部摄像头采集。
  ///
  /// [filePath]：设置静态图片的路径。
  /// + 支持本地文件绝对路径，不支持网络链接，Android 端还支持 Asset 资源路径（/assets/xx.png），长度限制为 512 字节。
  /// + 静态图片支持类型为 JPEG/JPG、PNG、BMP。
  /// + 若图片宽高比与设置的编码宽高比不一致，图片会被等比缩放，黑边填充空白区域。推流帧率与码率与设置的编码参数一致。
  ///
  /// 返回值：方法调用结果
  /// + 0：成功
  /// + -1：失败
  ///
  /// 注意：
  /// + 本地预览无法看到静态图片。
  /// + 进入房间前后均可调用此方法。在多房间场景中，静态图片仅在发布的房间中生效。
  /// + 针对该静态图片，滤镜和镜像效果不生效，水印效果生效。
  /// + 只有主流能设置静态图片，屏幕流不支持设置。
  /// + 开启大小流后，静态图片对大小流均生效，且针对小流进行等比例缩小。
  Future<int?> setDummyCaptureImagePath(String filePath);

  /// 通过 NTP 协议，获取网络时间
  ///
  /// 注意：
  /// + 第一次调用此接口会启动网络时间同步功能，并返回 `0`。同步完成后，会收到 [RTCVideoEventHandler.onNetworkTimeSynchronized]，此后，再次调用此 API，即可获取准确的网络时间。
  /// + 在合唱场景下，合唱参与者应在相同的网络时间播放背景音乐。
  Future<NetworkTimeInfo?> getNetworkTimeInfo();

  /// 在听众端，设置订阅的所有远端音频流精准对齐后播放
  ///
  /// [streamKey]：作为对齐基准的远端音频流。<br>
  /// 一般选择主唱的音频流。<br>
  /// 你必须在收到 [RTCRoomEventHandler.onUserPublishStream]，确认此音频流已发布后，调用此 API。
  ///
  /// [mode]：是否对齐，默认不对齐。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 你必须在实时合唱场景下使用此功能。在加入房间时，所有人应设置 [RoomProfile] 为 `chorus`。
  /// + 订阅的所有远端流必须通过 [RTCMediaPlayer.start] 开启了背景音乐混音，并将 [AudioMixingConfig] 中的 `syncProgressToRecordFrame` 设置为 `true`。
  /// + 如果订阅的某个音频流延迟过大，可能无法实现精准对齐。
  /// + 合唱的参与者不应调用此 API，因为调用此 API 会增加延迟。如果希望从听众变为合唱参与者，应关闭对齐功能。
  Future<int?> setAudioAlignmentProperty({
    required RemoteStreamKey streamKey,
    required AudioAlignmentMode mode,
  });

  /// @nodoc('For internal use')
  /// 调用实验性 API<br>
  /// 调用后，可能会触发 [RTCVideoEventHandler.onInvokeExperimentalAPI]。
  ///
  /// [param]：JSON 字符串，形如：
  ///
  /// ```{
  ///   "api_name":"startPublish",
  ///   "params":{
  ///     "streamID":"",
  ///     "observer":"",
  ///     "uri":"",
  ///     "option":""
  ///   }
  /// }
  /// ```
  Future<int?> invokeExperimentalAPI(String param);

  /// 创建 KTV 管理接口
  FutureOr<RTCKTVManager?> getKTVManager();

  /// 开启通话前回声检测
  ///
  /// v3.51 新增。
  ///
  /// [testAudioFilePath]：用于回声检测的音频文件的绝对路径，路径字符串使用 UTF-8 编码格式，支持以下音频格式：mp3，aac，m4a，3gp，wav。<br>
  /// 音频文件不为静音文件，推荐时长为 10 ～ 20 秒。
  ///
  /// 方法调用结果：
  /// + 0：成功。
  /// + -1：失败。上一次检测未结束，请先调用 [stopHardwareEchoDetection] 停止检测后重新调用本接口。
  /// + -2：失败。路径不合法或音频文件格式不支持。
  ///
  /// 注意：
  /// + 只有当 [RoomProfile] 为 `meeting` 和 `meetingroom` 时支持开启本功能。
  /// + 开启检测前，你需要向用户获取音频设备的使用权限。
  /// + 开启检测前，请确保音频设备没有被静音，采集和播放音量正常。
  /// + 调用本接口后监听 [RTCVideoEventHandler.onHardwareEchoDetectionResult] 获取检测结果。
  /// + 检测期间，进程将独占音频设备，无法使用 [startEchoTest]。
  /// + 调用 [stopHardwareEchoDetection] 停止检测，释放对音频设备的占用。
  Future<int?> startHardwareEchoDetection(String testAudioFilePath);

  /// 停止通话前回声检测
  ///
  /// v3.51 新增。
  ///
  /// 方法调用结果：
  /// + 0：成功。
  /// + -1：失败。
  ///
  /// 注意：
  /// + 关于开启通话前回声检测，参看 [startHardwareEchoDetection]。
  /// + 建议在收到 [RTCVideoEventHandler.onHardwareEchoDetectionResult] 通知的检测结果后，调用本接口停止检测。
  /// + 在用户进入房间前结束回声检测，释放对音频设备的占用，以免影响正常通话。
  Future<int?> stopHardwareEchoDetection();

  /// 启用蜂窝网络辅助增强，改善通话质量。
  ///
  /// v3.54 新增。
  ///
  /// 返回值：
  /// + 0：成功。
  /// + !0：失败，具体原因参看 [ReturnStatus]。
  ///
  /// 此功能默认不开启。
  Future<int?> setCellularEnhancement(MediaTypeEnhancementConfig config);

  /// 设置本地代理。
  ///
  /// v3.54 新增。
  ///
  /// [configurations]：本地代理配置参数。<br>
  /// 你可以根据自己的需要选择同时设置 Http 隧道 和 Socks5 两类代理，或者单独设置其中一类代理。如果你同时设置了 Http 隧道 和 Socks5 两类代理，此时，媒体和信令采用 Socks5 代理， Http 请求采用 Http 隧道代理；如果只设置 Http 隧道 或 Socks5 一类代理，媒体、信令和 Http 请求均采用已设置的代理。 <br>
  /// 调用此接口设置本地代理后，若想清空当前已有的代理设置，可再次调用此接口，选择不设置任何代理即可清空。
  ///
  /// 注意：
  /// + 该方法需要在进房前调用。
  /// + 调用该方法设置本地代理后，SDK 会触发 [RTCVideoEventHandler.onLocalProxyStateChanged]，返回代理连接的状态。
  Future<int?> setLocalProxy(List<LocalProxyConfiguration>? configurations);
}
