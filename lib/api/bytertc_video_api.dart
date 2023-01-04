// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'dart:typed_data';
import 'dart:ui';

import '../src/bytertc_video_impl.dart';
import 'bytertc_asr_engine_event_handler.dart';
import 'bytertc_audio_defines.dart';
import 'bytertc_audio_mixing_api.dart';
import 'bytertc_common_defines.dart';
import 'bytertc_face_detection_observer.dart';
import 'bytertc_live_transcoding_observer.dart';
import 'bytertc_push_single_stream_to_cdn_observer.dart';
import 'bytertc_room_api.dart';
import 'bytertc_video_defines.dart';
import 'bytertc_video_event_handler.dart';

/// 引擎接口
abstract class RTCVideo {
  /// 创建引擎对象
  ///
  /// 如果当前线程中未创建引擎实例，那么你必须先使用此方法，以使用 RTC 提供的各种音视频能力。  <br>
  /// 如果当前线程中已创建了引擎实例，再次调用此方法时，会返回已创建的引擎实例。
  static Future<RTCVideo?> createRTCVideo(RTCVideoContext context) {
    return RTCVideoImpl.createRTCVideo(context);
  }

  /// 获取当前 SDK 版本信息
  static Future<String?> getSdkVersion() {
    return RTCVideoImpl.getSdkVersion();
  }

  /// 获取 SDK 内各种错误码、警告码的描述文字。
  static Future<String?> getErrorDescription(int code) {
    return RTCVideoImpl.getErrorDescription(code);
  }

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
  /// 注意：
  /// + 若未取得当前设备的麦克风权限，调用该方法后会触发 [RTCVideoEventHandler.onWarning] 回调。
  /// + 调用 [RTCVideo.stopAudioCapture] 可以关闭音频采集设备，否则，SDK 只会在销毁引擎的时候自动关闭设备。
  /// + 由于不同硬件设备初始化响应时间不同，频繁调用本方法和 [RTCVideo.stopAudioCapture] 可能出现短暂无声问题，建议使用 [RTCRoom.publishStream]/[RTCRoom.unpublishStream] 实现临时闭麦和重新开麦。
  /// + 无论是否发布音频数据，你都可以调用该方法开启音频采集，并且调用后方可发布音频。
  Future<void> startAudioCapture();

  /// 关闭内部音频采集，默认为关闭状态
  ///
  /// 调用该方法后，本地用户会收到 [RTCVideoEventHandler.onAudioDeviceStateChanged] 的回调。
  /// 可见用户进房后调用该方法，房间中的其他用户会收到 [RTCVideoEventHandler.onUserStopAudioCapture] 的回调。
  ///
  /// 注意：
  /// + 调用 [RTCVideo.startAudioCapture] 可以开启音频采集设备。
  /// + 设备开启后若一直未调用该方法关闭设备，则 SDK 会在销毁引擎的时候自动关闭音频采集设备。
  Future<void> stopAudioCapture();

  /// 设置音频场景类型
  ///
  /// 你可以根据你的应用所在场景，选择合适的音频场景类型。<br>
  /// 选择音频场景后，RTC 会自动根据客户端音频路由和发布订阅状态，适用通话音量/媒体音量。<br>
  /// 在进房前和进房后设置均可生效。
  ///
  /// 注意：
  /// + 通话音量更适合通话，会议等对信息准确度要求更高的场景。通话音量会激活系统硬件信号处理，使通话声音会更清晰。此时，音量无法降低到 0。
  /// + 媒体音量更适合娱乐场景，因其声音的表现力会更强。媒体音量下，音量最低可以降低到 0。
  Future<void> setAudioScenario(AudioScenario audioScenario);

  /// 设置音质档位
  ///
  /// 当所选的 [ChannelProfile] 中的音频参数无法满足你的场景需求时，调用本接口切换的音质档位。
  ///
  /// 注意：
  /// + 该方法在进房前后均可调用；
  /// + 支持通话过程中动态切换音质档位。
  Future<void> setAudioProfile(AudioProfileType audioProfile);

  /// 设置变声特效类型
  ///
  /// + 在进房前后都可设置。
  /// + 只对单声道音频生效。
  /// + 只在包含美声特效能力的 SDK 中有效。
  /// + 与 [RTCVideo.setVoiceReverbType] 互斥，后设置的特效会覆盖先设置的特效。
  Future<void> setVoiceChangerType(VoiceChangerType voiceChanger);

  /// 设置混响特效类型
  ///
  /// + 在进房前后都可设置。
  /// + 只对单声道音频生效。
  /// + 只在包含美声特效能力的 SDK 中有效。
  /// + 与 [RTCVideo.setVoiceChangerType] 互斥，后设置的特效会覆盖先设置的特效。
  Future<void> setVoiceReverbType(VoiceReverbType voiceReverb);

  /// 调节音频采集音量
  ///
  /// [volume] 指采集的音量值和原始音量的比值，范围是 [0, 400]，单位为 %。<br>
  /// 为保证更好的通话质量，建议将 volume 值设为 [0,100]。
  /// + 0：静音
  /// + 100：原始音量
  /// + 400: 最大可为原始音量的 4 倍(自带溢出保护)
  ///
  /// 注意：
  /// + 无论是采集来自麦克风的音频流，还是屏幕音频流，都可以使用此接口进行音量调节。
  /// + 在开启音频采集前后，你都可以使用此接口设定采集音量。
  Future<void> setCaptureVolume({
    StreamIndex index = StreamIndex.main,
    required int volume,
  });

  /// 调节本地播放的所有远端用户混音后的音量
  ///
  /// [volume] 指播放的音量值和原始音量的比值，范围是 [0, 400]，单位为 %。<br>
  /// 为保证更好的通话质量，建议将 volume 值设为 [0,100]。
  /// + 0：静音
  /// + 100：原始音量
  /// + 400: 最大可为原始音量的 4 倍(自带溢出保护)
  ///
  /// 播放音频前或播放音频时，你都可以使用此接口设定播放音量。
  Future<void> setPlaybackVolume(int volume);

  /// 启用音量提示
  ///
  /// 开启提示后，你可以：
  /// + 通过 [RTCVideoEventHandler.onLocalAudioPropertiesReport] 获取本地麦克风和屏幕音频流采集的音量信息。
  /// + 通过 [RTCVideoEventHandler.onRemoteAudioPropertiesReport] 获取订阅的远端用户的音量信息。
  /// + 通过 [RTCVideoEventHandler.onActiveSpeaker] 回调获取房间内的最活跃用户信息。
  Future<void> enableAudioPropertiesReport(AudioPropertiesConfig config);

  /// 调节来自指定远端用户的音频播放音量
  ///
  /// [roomId] 远端用户所在的房间 ID
  ///
  /// [uid] 音频来源的远端用户 ID
  ///
  /// [volume] 是播放音量和原始音量的比值，范围是 `[0, 400]`，单位是 %，默认值为 100。<br>
  /// 为保证更好的通话质量，建议将 volume 值设为 [0,100]。
  /// + 0: 静音
  /// + 100: 原始音量
  /// + 400: 最大可为原始音量的 4 倍(自带溢出保护)
  Future<void> setRemoteAudioPlaybackVolume({
    required String roomId,
    required String uid,
    required int volume,
  });

  /// 开启/关闭耳返功能。
  ///
  /// [mode] 耳返功能是否开启。
  ///
  /// 注意：
  /// + 耳返功能仅适用于由 RTC SDK 内部采集的音频。
  /// + 使用耳返功能必须佩戴耳机。为保证低延时耳返最佳体验，建议佩戴有线耳机。蓝牙耳机不支持硬件耳返。 <br>
  /// + RTC SDK 支持硬件耳返和软件耳返。一般来说，硬件耳返延时低且音质好。如果 App 在手机厂商的硬件耳返白名单内，且运行环境存在支持硬件耳返的 SDK，RTC SDK 默认启用硬件耳返。使用华为手机硬件耳返功能时，请添加[华为硬件耳返的依赖配置](https://www.volcengine.com/docs/6348/113523)。
  Future<void> setEarMonitorMode(EarMonitorMode mode);

  /// 设置耳返的音量。
  ///
  /// [volume] 是耳返的音量相对原始音量的比值，取值范围：`[0,100]`，单位：%。
  ///
  /// 注意：
  /// 设置耳返音量前，你必须先调用 [RTCVideo.setEarMonitorMode] 打开耳返功能。
  Future<void> setEarMonitorVolume(int volume);

  /// 开启本地语音变调功能，多用于 K 歌场景
  ///
  /// 使用该方法，你可以对本地语音的音调进行升调或降调等调整。
  ///
  /// [pitch] 相对于语音原始音调的升高/降低值，取值范围[-12，12]，默认值为 0，即不做调整。  <br>
  /// 取值范围内每相邻两个值的音高距离相差半音，正值表示升调，负值表示降调，设置的绝对值越大表示音调升高或降低越多。  <br>
  /// 超出取值范围则设置失败，并且会触发 [RTCVideoEventHandler.onWarning] 回调。
  Future<void> setLocalVoicePitch(int pitch);

  /// 开启/关闭音量均衡功能
  ///
  /// 开启音量均衡功能后，人声的响度会调整为 -16lufs。如果已调用 [RTCAudioMixingManager.setAudioMixingLoudness] 传入了混音音乐的原始响度，此音乐播放时，响度会调整为 -20lufs。
  ///
  /// 注意：该接口须在调用 [RTCAudioMixingManager.startAudioMixing] 开始播放音频文件之前调用。
  Future<void> enableVocalInstrumentBalance(bool enable);

  /// 打开/关闭音量闪避功能，适用于“一起看”等场景
  ///
  /// 开启该功能后，当检测到远端人声时，本地的媒体播放音量会自动减弱，从而保证远端人声的清晰可辨；当远端人声消失时，本地媒体音量会恢复到闪避前的音量水平。
  Future<void> enablePlaybackDucking(bool enable);

  /// 设置视频流发布端是否开启发布多路编码参数不同的视频流的模式，默认关闭
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
  /// + 若调用该方法设置了期望发布的最大分辨率的流参数之前，已调用 [RTCVideo.enableSimulcastMode] 开启发布多路视频流的模式，SDK 会根据订阅端的设置自动调整发布的流数以及各路流的参数，其中最大分辨率为设置的分辨率，流数最多 4 条，具体参看[推送多路流](https://www.volcengine.com/docs/6348/70139)文档；否则仅发布该条最大分辨率的视频流。
  /// + 调用该方法设置多路视频流参数前，SDK 默认仅发布一条分辨率为 640px × 360px，帧率为 15fps 的视频流。
  /// + 该方法适用于摄像头采集的视频流，设置屏幕共享视频流参数参看 [RTCVideo.setScreenVideoEncoderConfig]。
  Future<int?> setMaxVideoEncoderConfig(VideoEncoderConfig maxSolution);

  /// 视频发布端设置推送多路流时各路流的参数，包括分辨率、帧率、码率、缩放模式、网络不佳时的回退策略等
  ///
  /// [channelSolutions] 要推送的多路视频流的参数，最多支持设置 3 路参数，超过 3 路时默认取前 3 路的值。<br>
  /// 当设置了多路参数时，分辨率和帧率必须是从大到小排列。需注意，所设置的分辨率是各路流的最大分辨率。
  ///
  /// 注意：
  /// + 该方法是否生效取决于是否同时调用了 [RTCVideo.enableSimulcastMode] 开启发布多路参数不同的视频流模式。若未开启推送多路流模式，但调用本方法设置了多个分辨率，SDK 默认发布分辨率最大的一条流，多个分辨率的设置会在开启推送多路流模式之后生效。
  /// + 调用该方法设置多路视频流参数前，SDK 默认仅发布一条分辨率为 640px × 360px，帧率为 15fps 的视频流。
  /// + 调用该方法设置分辨率不同的多条流后，SDK 会根据订阅端设置的期望订阅参数自动匹配发送的流，具体规则参看[推送多路流](https://www.volcengine.com/docs/6348/70139)文档。
  /// + 该方法适用于摄像头采集的视频流，设置屏幕共享视频流参数参看 [RTCVideo.setScreenVideoEncoderConfig]。
  Future<int?> setVideoEncoderConfig(List<VideoEncoderConfig> channelSolutions);

  /// 为发布的屏幕共享视频流设置期望的编码参数，包括分辨率、帧率、码率、缩放模式、网络不佳时的回退策略等
  ///
  /// 调用该方法之前，屏幕共享视频流默认的编码参数为：分辨率 1920px × 1080px，帧率 15fps。
  Future<int?> setScreenVideoEncoderConfig(VideoEncoderConfig screenSolution);

  /// 设置 RTC SDK 内部采集时的视频采集参数，包括分辨率、帧率等
  ///
  /// 注意：
  /// + 本接口在引擎创建后可调用，调用后立即生效。建议在调用 [RTCVideo.startVideoCapture] 前调用本接口。
  /// + 建议同一设备上的不同引擎使用相同的视频采集参数。
  /// + 如果调用本接口前使用内部模块开始视频采集，采集参数默认为 Auto 模式。
  Future<int?> setVideoCaptureConfig(VideoCaptureConfig config);

  /// 取消设置本地视频画布
  Future<int?> removeLocalVideo({
    StreamIndex streamType = StreamIndex.main,
  });

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
  /// 注意：
  /// + 若未取得当前设备的摄像头权限，调用该方法后会触发 [RTCVideoEventHandler.onVideoDeviceStateChanged] 回调。
  /// + 调用 [RTCVideo.stopVideoCapture] 可以关闭视频采集设备，否则，SDK 只会在销毁引擎的时候自动关闭设备。
  /// + 无论是否发布视频数据，你都可以调用该方法开启视频采集，并且调用后方可发布视频。
  /// + 内部视频采集使用的摄像头由 [RTCVideo.switchCamera] 接口指定。
  /// + Android 需要在 Gradle 里引入 Kotlin；iOS 需要在应用中向用户申请摄像头权限后才能开始采集。
  Future<void> startVideoCapture();

  /// 关闭本地视频采集，默认为关闭状态
  ///
  /// 调用该方法，本地用户会收到 [RTCVideoEventHandler.onVideoDeviceStateChanged] 的回调。
  /// 可见用户进房后调用该方法，房间中的其他用户会收到 [RTCVideoEventHandler.onUserStopVideoCapture] 回调。
  ///
  ///  注意：
  /// + 调用 [RTCVideo.startVideoCapture] 可以开启视频采集设备。
  /// + 设备开启后若一直未调用该方法关闭，则 SDK 会在销毁引擎的时候自动关闭音频采集设备。
  Future<void> stopVideoCapture();

  /// 为本地采集到的视频流开启镜像
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

  /// 设置采集视频的旋转模式，默认以 App 方向为旋转参考系
  ///
  /// 接收端渲染视频时，将按照和发送端相同的方式进行旋转。
  ///
  /// [rotationMode] 视频旋转参考系为 App 方向或重力方向。
  ///
  /// 注意：
  /// + 旋转仅对内部视频采集生效，不适用于外部视频源和屏幕源。
  /// + 调用该接口时已开启视频采集，将立即生效；调用该接口时未开启视频采集，则将在采集开启后生效。
  /// + 更多信息请参考[视频采集方向](https://www.volcengine.com/docs/6348/106458)。
  Future<int?> setVideoRotationMode(VideoRotationMode rotationMode);

  /// 在自定义视频前处理及编码前，设置 RTC 链路中的视频帧朝向，默认为 Adaptive 模式
  ///
  /// 移动端开启视频特效贴纸，或使用自定义视频前处理时，建议固定视频帧朝向为 Portrait 模式。<br>
  /// 单流转推场景下，建议根据业务需要固定视频帧朝向为 Portrait 或 Landscape 模式。<br>
  /// 不同模式的具体显示效果参看[视频帧朝向](https://www.volcengine.com/docs/6348/128787)。
  ///
  /// 注意：
  /// + 设置视频帧朝向仅对内部视频采集生效，不适用于外部视频源和屏幕源。
  /// + 编码分辨率的更新与视频帧处理是异步操作，进房后切换视频帧朝向可能导致画面出现短暂的裁切异常，因此建议在进房前设置视频帧朝向，且不在进房后进行切换。
  Future<void> setVideoOrientation(VideoOrientation orientation);

  /// 切换移动端前置/后置摄像头
  ///
  /// 调用此接口后，在本地会触发 [RTCVideo.onVideoDeviceStateChanged] 回调。
  ///
  /// 注意：
  /// + 调用该方法前默认使用前置摄像头。
  /// + 如果你正在使用相机进行视频采集，切换操作当即生效；如果相机未启动，后续开启内部采集时，会打开设定的摄像头。
  Future<void> switchCamera(CameraId cameraId);

  /// 视频特效许可证检查
  ///
  /// [licenseFile]：许可证文件绝对路径
  ///
  /// 返回值：
  /// + 0: 许可证验证成功；
  /// + 1000: 未集成特效 SDK；
  /// + 1001: 特效 SDK 不支持该功能；
  /// + <0: 其他错误，具体参看[错误码表](https://www.volcengine.com/docs/5889/61813)。
  Future<int?> checkVideoEffectLicense(String licenseFile);

  /// 创建/销毁视频特效引擎
  ///
  /// 返回值：
  /// + 0: 成功；
  /// + 1000: 未集成特效 SDK；
  /// + 1001: 特效 SDK 不支持该功能；
  /// + <0: 其他错误，具体参看[错误码表](https://www.volcengine.com/docs/5889/61813)。
  ///
  /// 注意：
  /// + 该方法须在调用 [RTCVideo.checkVideoEffectLicense] 和 [RTCVideo.setVideoEffectAlgoModelPath] 后调用。
  /// + 该方法不直接开启/关闭视频特效，你须在调用该方法后，调用 [RTCVideo.setVideoEffectNodes] 开启视频特效。
  /// + 通用场景下，特效引擎会随 RTC 引擎销毁而销毁。当你对性能有较高要求时，可在不使用特效相关功能时设该方法为 false 单独销毁特效引擎。
  Future<int?> enableVideoEffect(bool enable);

  /// 设置视频特效算法模型路径
  Future<void> setVideoEffectAlgoModelPath(String modelPath);

  /// 设置视频特效素材包
  ///
  /// [effectNodes] 特效素材包路径数组。
  /// 要取消当前视频特效，将此参数设置为 null。
  ///
  /// 返回值：
  /// + 0: 成功；
  /// + 1000: 未集成特效 SDK；
  /// + 1001: 特效 SDK 不支持该功能；
  /// + <0: 其他错误，具体参看[错误码表](https://www.volcengine.com/docs/5889/61813)。
  /// 注意：你须在调用 [RTCVideo.enableVideoEffect] 后调用该方法。
  Future<int?> setVideoEffectNodes(List<String>? effectNodes);

  /// 设置特效强度
  ///
  /// [effectNode] 特效素材包路径
  ///
  /// [key] 需要设置的素材 key 名称，参看 [素材key对应说明](https://www.volcengine.com/docs/6705/102041)。
  ///
  /// [value] 需要设置的强度值，取值范围为 [0,1]，超出该范围设置无效。
  ///
  /// 返回值：
  /// + 0: 成功；
  /// + 1000: 未集成特效 SDK；
  /// + 1001: 特效 SDK 不支持该功能；
  /// + <0: 其他错误，具体参看[错误码表](https://www.volcengine.com/docs/5889/61813)。
  /// 注意：该接口仅适用于同时含有上述三个参数的特效资源，对于如大部分贴纸类等没有强度参数的特效，该接口调用无效。
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
  /// + 0: 成功；
  /// + 1000: 未集成特效 SDK；
  /// + 1001: 特效 SDK 不支持该功能；
  /// + <0: 其他错误，具体参看[错误码表](https://www.volcengine.com/docs/5889/61813)。
  Future<int?> setVideoEffectColorFilter(String? resFile);

  /// 设置已启用的颜色滤镜强度
  ///
  /// [intensity] 滤镜强度，取值范围 [0,1]，超出范围时设置无效。
  ///
  /// 返回值：
  /// + 0: 成功；
  /// + 1000: 未集成特效 SDK；
  /// + 1001: 特效 SDK 不支持该功能；
  /// + <0: 其他错误，具体参看[错误码表](https://www.volcengine.com/docs/5889/61813)。
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
  /// + 0: 成功；
  /// + 1000: 未集成特效 SDK；
  /// + 1001: 特效 SDK 不支持该功能；
  /// + <0: 其他错误，具体参看[错误码表](https://www.volcengine.com/docs/5889/61813)。
  ///
  /// 调用此接口前需依次调用以下接口：
  /// 1. 检查视频特效许可证 [RTCVideo.checkVideoEffectLicense]；
  /// 2. 设置视频特效算法模型路径 [RTCVideo.setVideoEffectAlgoModelPath]；
  /// 3. 开启视频特效 [RTCVideo.enableVideoEffect]。
  Future<int?> setBackgroundSticker({
    String? modelPath,
    VirtualBackgroundSource? source,
  });

  /// 开启/关闭基础美颜
  ///
  /// 返回值
  /// + 0: 开启/关闭成功。
  /// + 1000: 未集成特效 SDK。
  /// + 1001: RTC SDK 版本不支持此功能。
  /// + 1002: 特效 SDK 当前版本不支持此功能，建议使用特效 SDK V4.3.1 版本。
  /// + 1003: 联系技术支持人员。
  /// + 1004: 正在下载相关资源，下载完成后生效。
  /// + <0: 调用失败，特效 SDK 内部错误，具体错误码请参考[错误码表](https://www.volcengine.com/docs/5889/61813)。
  ///
  /// 注意：
  /// + 本方法不能与高级视频特效接口共用。如已购买高级视频特效，建议调用 [RTCVideo.enableVideoEffect] 使用高级特效、贴纸功能等。
  /// + 使用此功能需要集成特效 SDK，建议使用特效 SDK V4.3.1+ 版本。
  /// + 调用 [RTCVideo.setBeautyIntensity] 设置基础美颜强度。若在调用本方法前没有设置美颜强度，则初始美白、磨皮、锐化强度均为 0.5。
  /// + 本方法仅适用于视频源，不适用于屏幕源。
  Future<int?> enableEffectBeauty(bool enable);

  /// 调整基础美颜强度
  ///
  /// [beautyMode] 基础美颜模式。
  ///
  /// [intensity] 美颜强度，取值范围为 [0,1]。<br>
  /// 强度为 0 表示关闭，默认强度为 0.5。
  ///
  /// 返回值：
  /// + 0: 成功；
  /// + 1000: 未集成特效 SDK；
  /// + 1001: 特效 SDK 不支持该功能；
  /// + <0: 其他错误，具体参看[错误码表](https://www.volcengine.com/docs/5889/61813)。
  ///
  /// 注意：
  /// + 若在调用 [RTCVideo.senableEffectBeauty] 前设置美颜强度，则对应美颜功能的强度初始值会根据设置更新。
  /// + 销毁引擎后，美颜功能强度恢复默认值。
  Future<int?> setBeautyIntensity({
    required EffectBeautyMode beautyMode,
    required double intensity,
  });

  /// 注册人脸检测结果回调观察者
  ///
  /// 注册此观察者后，你会周期性收到 [RTCFaceDetectionObserver.onFaceDetectResult] 回调。
  ///
  /// [observer] 人脸检测结果回调观察者。
  ///
  /// [interval] 时间间隔，必须大于 0，单位：ms。实际收到回调的时间间隔大于 `interval`，小于 `interval + 视频采集帧间隔`。
  Future<int?> registerFaceDetectionObserver({
    RTCFaceDetectionObserver? observer,
    int interval = 0,
  });

  /// 设置当前使用的摄像头（前置/后置）的变焦倍数
  ///
  /// [zoom] 变焦倍数，取值范围是 [1, <最大变焦倍数>]。<br>
  /// 最大变焦倍数可以通过调用 [RTCVideo.getCameraZoomMaxRatio] 获取。
  ///
  /// 注意：设置结果在调用 [RTCVideo.stopVideoCapture] 关闭内部采集后失效。
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
  /// [position] 对焦点归一化二维坐标值，以本地预览画布的左上为原点，取值范围为 [0, 1]。
  ///
  /// 注意：
  /// + 移动设备时，自动取消对焦点设置。
  /// + 调用 [RTCVideo.stopVideoCapture] 关闭内部采集后，设置的对焦点失效。
  Future<int?> setCameraFocusPosition(Offset position);

  /// 检查当前使用的摄像头是否支持手动设置曝光点
  Future<bool?> isCameraExposurePositionSupported();

  /// 设置当前使用的摄像头的曝光点
  ///
  /// [position] 曝光点归一化二维坐标值，以本地预览画布的左上为原点，取值范围为 [0, 1]。
  ///
  /// 注意：
  /// + 移动设备时，自动取消曝光点设置。
  /// + 调用 [RTCVideo.stopVideoCapture] 关闭内部采集后，设置的曝光点失效。
  Future<int?> setCameraExposurePosition(Offset position);

  /// 设置当前使用的摄像头的曝光补偿
  ///
  /// [val] 曝光补偿值，取值范围 [-1, 1]，0 为系统默认值(没有曝光补偿)。
  ///
  /// 注意：调用 [RTCVideo.stopVideoCapture] 关闭内部采集后，设置的曝光补偿失效。
  Future<int?> setCameraExposureCompensation(double val);

  /// 通过视频帧发送 SEI 数据。
  ///
  /// 在视频通话场景下，SEI 数据会随视频帧发送；在语音通话场景下，SDK 会自动生成一路 16px × 16px 的黑帧视频流用来发送 SEI 数据。
  ///
  /// [streamIndex] 指定携带 SEI 数据的媒体流类型。<br>
  /// 语音通话场景下，该值需设为 `main`，否则 SEI 数据会被丢弃从而无法送达远端。
  ///
  /// [message] 是 SEI 消息内容，长度不超过 4KB。
  ///
  /// [repeatCount] 是消息发送重复次数，取值范围是 `[0, 30]`。<br>
  /// 调用此接口后，SEI 数据会添加到当前视频帧开始的连续 `repeatCount` 个视频帧中。
  ///
  /// 返回值：
  /// + `>=0`: 将被添加到视频帧中的 SEI 的数量
  /// + `<0`: 发送失败
  ///
  /// 注意：
  /// + 语音通话场景中，仅支持在内部采集模式下调用该接口发送 SEI 数据，且调用频率需为 15/repeatCount FPS。
  /// + 视频帧仅携带前后 2s 内收到的 SEI 数据；语音通话场景下，若调用此接口后 1min 内未有 SEI 数据发送，则 SDK 会自动取消发布视频黑帧。
  /// + 消息发送成功后，远端会收到 [RTCVideoEventHandler.onSEIMessageReceived] 回调。
  /// + 语音通话切换至视频通话时，会停止 SEI 数据发送，你需再次调用该接口方可恢复发送。
  Future<int?> sendSEIMessage({
    StreamIndex streamIndex = StreamIndex.main,
    required Uint8List message,
    required int repeatCount,
  });

  /// 设置当前音频播放路由。
  ///
  /// 默认使用 [RTCVideo.setDefaultAudioRoute] 中设置的音频路由。
  /// 音频播放路由发生变化时，会收到 [RTCVideoEventHandler.onAudioRouteChanged]。
  ///
  /// [audioRoute] 音频播放路由，不支持设为 `Unknown`。
  ///
  /// 注意：
  /// + 你需要调用 [RTCVideo.setAudioScenario] 将音频场景切换为 `communication` 后再调用本接口。
  /// + 连接有线或者蓝牙音频播放设备后，音频路由将自动切换至此设备。
  /// + 移除后，音频设备会自动切换回原设备。
  /// + 不同音频场景中，音频路由和发布订阅状态到音量类型的映射关系详见 [AudioScenarioType]。
  Future<int?> setAudioRoute(AudioRoute audioRoute);

  /// 将默认的音频播放设备设置为听筒或扬声器
  ///
  /// 返回值：
  /// + 0: 方法调用成功。立即生效。当所有音频外设移除后，音频路由将被切换到默认设备。
  /// + < 0: 方法调用失败。指定除扬声器和听筒以外的设备将会失败。
  ///
  /// 注意：
  /// + 进房前后都可以调用。
  /// + 更多注意事项参见[音频路由](https://www.volcengine.com/docs/6348/117836)。
  Future<int?> setDefaultAudioRoute(AudioRoute audioRoute);

  /// 获取当前使用的音频播放路由
  ///
  /// 设置音频路由，详见 [RTCVideo.setAudioRoute]。
  Future<AudioRoute> getAudioRoute();

  /// 启用匹配外置声卡的音频处理模式
  ///
  /// 注意：
  /// + 当采用外接声卡进行音频采集时，建议开启此模式，以获得更好的音质。
  /// + 开启此模式时，仅支持耳机播放。如果需要使用扬声器或者外置音箱播放，关闭此模式。
  Future<void> enableExternalSoundCard(bool enable);

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
  /// 注意：
  /// + 调用该方法后，关于启动结果和推流过程中的错误，会收到 [RTCLiveTranscodingObserver.onStreamMixingEvent] 回调。
  /// + 调用 [RTCVideo.stopLiveTranscoding] 停止转推直播。
  Future<void> startLiveTranscoding({
    required String taskId,
    required LiveTranscoding transcoding,
    required RTCLiveTranscodingObserver observer,
  });

  /// 停止转推直播
  Future<void> stopLiveTranscoding(String taskId);

  /// 更新转推直播参数
  Future<void> updateLiveTranscoding({
    required String taskId,
    required LiveTranscoding transcoding,
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
  /// 注意：
  /// + 调用该方法后，关于启动结果和推流过程中的错误，会收到 [RTCPushSingleStreamToCDNObserver.onStreamPushEvent] 回调。
  /// + 调用 [RTCVideo.stopPushStreamToCDN] 停止任务。
  Future<void> startPushSingleStreamToCDN({
    required String taskId,
    required PushSingleStreamParam param,
    required RTCPushSingleStreamToCDNObserver observer,
  });

  /// 停止单流转推直播任务
  Future<void> stopPushStreamToCDN(String taskId);

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
  /// 0: 成功。同时将收到 [RTCVideoEventHandler.onPushPublicStreamResult] 回调。
  /// + !0: 失败。当参数不合法或参数为空，调用失败。
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

  ///订阅指定公共流
  ///
  /// 无论用户是否在房间内，都可以调用本接口获取和播放指定的公共流。<br>
  /// 如果指定流暂未发布，则本地客户端将在其开始发布后接收到流数据。
  ///
  /// 返回值：
  /// + 0: 成功。同时将收到 [RTCVideoEventHandler.onPlayPublicStreamResult] 回调。
  /// + !0: 失败。当参数不合法或参数为空，调用失败。
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

  /// 设置业务标识参数。
  ///
  /// 可通过 [businessId] 区分不同的业务场景（角色/策略等）。businessId 由客户自定义，相当于一个“标签”，可以分担和细化现在 AppId 的逻辑划分的功能。
  ///
  /// 返回值：
  /// + 0： 成功
  /// + < 0： 失败
  /// + -6001： 用户已经在房间中。
  /// + -6002： 输入非法，合法字符包括所有小写字母、大写字母和数字，除此外还包括四个独立字符，分别是：英文句号，短横线，下划线和 @ 。
  ///
  /// 注意：
  /// + businessId 只是一个标签，颗粒度需要用户自定义。
  /// + 该方法需要在进房前调用
  Future<void> setBusinessId(String businessId);

  /// 将用户反馈的问题上报到 RTC
  ///
  /// [types] 是预设的问题类型集合，可多选。
  /// [problemDesc] 是预设问题以外的其他问题的具体描述
  ///
  /// 返回值：
  /// + 0: 上报成功
  /// + -1: 上报失败，还没加入过房间
  /// + -2: 上报失败，数据解析错误
  /// + -3: 上报失败，字段缺失
  ///
  /// 注意：如果用户上报时在房间内，那么问题会定位到用户当前所在的一个或多个房间；如果用户上报时不在房间内，那么问题会定位到引擎此前退出的房间。
  Future<int?> feedback({
    required List<ProblemFeedback> types,
    required String problemDesc,
  });

  /// 设置发布的音视频流回退选项
  ///
  /// 你可以调用该接口设置网络不佳或设备性能不足时从大流起进行降级处理，以保证通话质量。
  ///
  /// + 该方法仅在调用 [RTCVideo.enableSimulcastMode] 开启了发送多路视频流的情况下生效。
  /// + 你必须在进房前设置，进房后设置或更改设置无效。
  /// + 设置回退选项后，本端发布的音视频流发生回退或从回退中恢复时，订阅该音视频流的客户端会收到 [RTCVideoEventHandler.onSimulcastSubscribeFallback]。
  /// + 你可以调用客户端 API 或者在服务端下发策略设置回退。当使用服务端下发配置实现时，下发配置优先级高于客户端 API。
  Future<int?> setPublishFallbackOption(PublishFallbackOption option);

  /// 设置订阅的音视频流回退选项
  ///
  /// 你可调用该接口设置网络不佳或设备性能不足时允许订阅流进行降级或只订阅音频流，以保证通话流畅。
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
  /// 注意：该方法必须在进房之前调用，可重复调用，以最后调用的参数作为生效参数。
  Future<void> setEncryptInfo({
    required EncryptType aesType,
    required String key,
  });

  /// 创建房间实例。
  ///
  /// 调用此方法仅返回一个房间实例，你仍需调用 [RTCRoom.joinRoom] 才能真正地创建/加入房间。
  /// 多次调用此方法可以创建多个 [RTCRoom] 实例。分别调用各 RTCRoom 实例中的 [RTCRoom.joinRoom] 方法，同时加入多个房间。
  /// 多房间模式下，用户可以同时订阅各房间的音视频流。
  ///
  /// [roomId] 标识通话房间的房间 ID，最大长度为 128 字节的非空字符串。支持的字符集范围为:
  /// + 26 个大写字母 A ~ Z；
  /// + 26 个小写字母 a ~ z；
  /// + 10 个数字 0 ~ 9；
  /// + 下划线 "_", at 符 "@", 减号 "-"。
  ///
  /// 返回值：
  /// 创建的 [RTCRoom] 房间实例。
  ///
  /// 注意：
  /// + 如果需要加入的房间已存在，你仍需先调用本方法来获取 RTCRoom 实例，再调用 [RTCRoom.joinRoom] 加入房间。
  /// + 多房间模式下，创建多个房间实例需要使用不同的 roomId，否则会导致创建房间失败。
  /// + 如果你需要在多个房间发布音视频流，无须创建多房间，直接调用 [RTCRoom.startForwardStreamToRooms]。
  Future<RTCRoom?> createRTCRoom(String roomId);

  /// 使用 RTC SDK 内部采集模块开始采集屏幕音频流和（或）视频流
  ///
  /// 注意:
  /// + 采集后，你还需要调用 [RTCRoom.publishScreen] 发布采集到的屏幕音视频。
  /// + 开启屏幕音频/视频采集成功后，本地用户会收到 [RTCVideoEventHandler.onVideoDeviceStateChanged] 和 [RTCVideoEventHandler.onAudioDeviceStateChanged] 的回调。
  /// + 要关闭屏幕音视频内部采集，调用 [RTCVideo.stopScreenCapture]。
  Future<void> startScreenCapture(ScreenMediaType type);

  /// 开启屏幕采集后，更新采集的媒体类型
  Future<void> updateScreenCapture(ScreenMediaType type);

  /// 屏幕共享时，停止屏幕流采集
  Future<void> stopScreenCapture();

  /// 仅适用于 iOS，向屏幕共享 Extension 发送自定义消息
  ///
  /// 注意：需在开启屏幕采集之后调用该方法
  Future<void> sendScreenCaptureExtensionMessage(Uint8List message);

  /// 设置运行时的参数
  Future<void> setRuntimeParameters(Map<String, dynamic> params);

  /// 开启自动语音识别服务
  ///
  /// 该方法将识别后的用户语音转化成文字，并通过 [RTCASREngineEventHandler.onMessage] 回调。
  Future<void> startASR({
    required RTCASRConfig asrConfig,
    required RTCASREngineEventHandler handler,
  });

  /// 关闭语音识别服务
  Future<void> stopASR();

  /// 将通话过程中的音视频数据录制到本地的文件中
  ///
  /// 返回值：
  /// 0: 正常<br>
  /// -1: 参数设置异常<br>
  /// -2: 当前版本 SDK 不支持该特性，请联系技术支持人员
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
  /// 注意：
  /// + 调用 [RTCVideo.startFileRecording] 开启本地录制后，你必须调用该方法停止录制。
  /// + 调用该方法后，会收到 [RTCVideoEventHandler.onRecordingStateUpdate] 提示录制结果。
  Future<void> stopFileRecording({
    StreamIndex streamIndex = StreamIndex.main,
  });

  /// 创建混音管理接口实例
  RTCAudioMixingManager get audioMixingManager;

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
  /// 登出后，会收到 [RTCVideoEventHandler.onLogout]
  Future<void> logout();

  /// 更新用户用于登录的 Token
  ///
  /// Token 有一定的有效期，当 Token 过期时，需调用此方法更新登录的 Token 信息。 <br>
  /// 调用 [RTCVideo.login] 登录时，如果使用了过期的 Token，将导致登录失败，并会收到 [RTCVideoEventHandler.onLoginResult]。此时需要重新获取 Token，并调用此方法更新 Token。
  ///
  /// 注意：
  /// + 如果 Token 无效导致登录失败，则调用此方法更新 Token 后，SDK 会自动重新登录，而不需要再次调用 [RTCVideo.login]。
  /// + Token 过期时，如果已经成功登录，则不会受到影响。Token 过期的错误会在下一次使用过期 Token 登录时，或因本地网络状况不佳导致断网重新登录时通知给用户。
  Future<void> updateLoginToken(String token);

  /// 设置应用服务器参数
  ///
  /// 客户端调用 [RTCVideo.sendServerMessage] 或 [RTCVideo.sendServerBinaryMessage] 发送消息给业务服务器之前，必须设置有效签名和业务服务器地址。
  ///
  /// [signature] 是动态签名。业务服务器会使用该签名对请求进行鉴权验证。
  ///
  /// [url] 是业务服务器的地址
  ///
  /// + 必须先调用 [RTCVideo.login] 登录后，才能调用本接口。
  /// + 调用本接口后，会收到 [RTCVideoEventHandler.onServerParamsSetResult]。
  Future<void> setServerParams({
    required String signature,
    required String url,
  });

  /// 发送消息前，查询指定远端用户或本地用户的登录状态
  ///
  /// + 必须调用 [RTCVideo.login] 登录后，才能调用本接口。
  /// + 调用本接口后，会收到 [RTCVideoEventHandler.onGetPeerOnlineStatus]
  /// + 在发送房间外消息之前，用户可以通过本接口了解对端用户是否登录，从而决定是否发送消息。也可以通过本接口查询自己查看自己的登录状态。
  Future<void> getPeerOnlineStatus(String peerUid);

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
  /// [expectedUplinkBitrate] 设置期望上行带宽，单位：kbps<br>范围为 {0, [100-10000]}，其中， `0` 表示由 SDK 指定最高码率。
  ///
  /// [isTestDownlink] 是否探测下行带宽
  ///
  /// [expectedDownlinkBitrate] 设置期望下行带宽，单位：kbps<br>范围为 {0, [100-10000]}，其中， `0` 表示由 SDK 指定最高码率。
  ///
  /// 注意：
  /// + 成功调用本接口后，会在 3s 内收到一次 [RTCVideoEventHandler.onNetworkDetectionResult] 回调，此后每 2s 收到一次该回调，通知探测结果；
  /// + 若探测停止，则会收到一次 [RTCVideoEventHandler.onNetworkDetectionStopped] 通知探测停止。
  Future<NetworkDetectionStartReturn> startNetworkDetection({
    required bool isTestUplink,
    required int expectedUplinkBitrate,
    required bool isTestDownlink,
    required int expectedDownlinkBitrate,
  });

  /// 停止通话前网络探测
  ///
  /// 调用本接口后，会收到 [RTCVideoEventHandler.onNetworkDetectionStopped] 回调通知探测停止。
  Future<void> stopNetworkDetection();

  /// 在屏幕共享时，设置屏幕音频流和麦克风采集到的音频流的混流方式
  ///
  /// 通过 [index] 指定混流方式：
  /// + `main`: 将屏幕音频流和麦克风采集到的音频流混流
  /// + `screen`: 默认值，将屏幕音频流和麦克风采集到的音频流分为两路音频流
  ///
  /// 你应该在 [RTCRoom.publishScreen] 之前，调用此方法，否则你将收到 [RTCVideoEventHandler.onWarning] 报错。
  Future<void> setScreenAudioStreamIndex(StreamIndex index);

  /// 发送音频流同步信息
  ///
  /// 将消息通过音频流发送到远端，并实现与音频流同步。
  ///
  /// [data] 长度必须是 `[1, 16]` 字节。
  ///
  /// 返回值：
  /// + `>=0`: 消息发送成功。返回成功发送的次数。
  /// + `-1`: 消息发送失败。消息长度大于 255 字节。
  /// + `-2`: 消息发送失败。传入的消息内容为空。
  /// + `-3`: 消息发送失败。通过屏幕流进行消息同步时，此屏幕流还未发布。
  /// + `-4`: 消息发送失败。通过用麦克风采集到的音频流进行消息同步时，此音频流还未发布，详见错误码 [ErrorCode]。
  ///
  /// 该接口调用成功后，远端用户会收到 [RTCVideoEventHandler.onStreamSyncInfoReceived]。
  Future<int?> sendStreamSyncInfo({
    required Uint8List data,
    required StreamSyncInfoConfig config,
  });

  /// 控制本地音频流播放状态：播放/不播放
  ///
  /// 本方法仅控制本地收到音频流的播放状态，并不影响本地音频播放设备。
  Future<void> muteAudioPlayback(bool muteState);

  /// 在指定视频流上添加水印
  ///
  /// [imagePath] 为水印图片路径，支持本地文件绝对路径、Asset 资源路径（/assets/xx.png）、URI 地址（content://），长度限制为 512 字节。  <br>
  /// 水印图片为 PNG 或 JPG 格式。
  ///
  /// 注意：
  /// + 调用 [RTCVideo.clearVideoWatermark] 移除指定视频流的水印。
  /// + 同一路流只能设置一个水印，新设置的水印会代替上一次的设置。你可以多次调用本方法来设置不同流的水印。
  /// + 进入房间前后均可调用此方法。
  /// + 若开启本地预览镜像，或开启本地预览和编码传输镜像，则远端水印均不镜像；在开启本地预览水印时，本端水印会镜像。
  /// + 开启大小流后，水印对大小流均生效，且针对小流进行等比例缩小。
  Future<void> setVideoWatermark({
    StreamIndex streamIndex = StreamIndex.main,
    required String imagePath,
    required WatermarkConfig watermarkConfig,
  });

  /// 移除指定视频流的水印
  Future<void> clearVideoWatermark(
      {StreamIndex streamIndex = StreamIndex.main});

  /// 开启云代理
  ///
  /// 注意：
  /// + 在加入房间前调用此接口。
  /// + 在开启云代理后，进行通话前网络探测。
  /// + 开启云代理后，并成功链接云代理服务器后，会收到 [RTCVideoEventHandler.onCloudProxyConnected]。
  /// + 要关闭云代理，调用 [RTCVideo.stopCloudProxy]。
  Future<void> startCloudProxy(List<CloudProxyInfo> cloudProxiesInfo);

  /// 关闭云代理
  Future<void> stopCloudProxy();

  /// 开启音视频回路测试
  ///
  /// 在进房前，用户可调用该接口对音视频通话全链路进行检测，包括对音视频设备以及用户上下行网络的检测，从而帮助用户判断是否可以正常发布和接收音视频流。  <br>
  /// 开始检测后，SDK 会录制你声音或视频。如果你在设置的延时范围内收到了回放，则视为音视频回路测试正常。
  ///
  /// [delayTime] 为音视频延迟播放的时间间隔，用于指定在开始检测多长时间后期望收到回放。取值范围为 [2,10]，单位为秒，默认为 2 秒。
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
  /// + 在调用 [RTCVIdeo.startEchoTest] 和 [RTCVIdeo.stopEchoTest] 之间调用的所有跟设备采集、流控制、进房相关的方法均不生效，并会收到 [RTCVideoEventHandler.onWarning] 回调。
  /// + 音视频回路检测的结果会通过 [RTCVideoEventHandler.onEchoTestResult] 回调通知。
  Future<int?> startEchoTest({
    required EchoTestConfig config,
    required int delayTime,
  });

  /// 停止音视频回路测试
  ///
  /// 注意：
  /// + 调用 [RTCVIdeo.startEchoTest] 开启音视频回路检测后，你必须调用该方法停止检测。
  /// + 音视频回路检测结束后，所有对系统设备及音视频流的控制均会恢复到开始检测前的状态。
  Future<int?> stopEchoTest();
}
