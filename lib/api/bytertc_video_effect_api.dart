// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_face_detection_observer.dart';
import 'bytertc_video_defines.dart';

/// 高级视频特效。
abstract class RTCVideoEffect {
  /// 检查视频特效证书，设置算法模型路径，并初始化特效模块。
  ///
  /// [licenseFile]：证书文件的绝对路径，用于鉴权。
  ///
  /// [modelPath]：算法模型绝对路径，即存放特效 SDK 所有算法模型的目录。
  ///
  /// 返回值：
  /// + 0: 调用成功。
  /// + –1000: 未集成特效 SDK。
  /// + –1002: 特效 SDK 版本不兼容。
  /// + < 0: 调用失败，错误码对应具体描述参看 [错误码表](https://www.volcengine.com/docs/6705/102042)。
  Future<int?> initCVResource(String licenseFile, String modelPath);

  /// 开启高级美颜、滤镜等视频特效。
  ///
  /// 返回值：
  /// + 0: 调用成功。
  /// + –1000: 未集成特效 SDK。
  /// + –1001: 特效 SDK 不支持该功能。
  /// + –1002: 特效 SDK 版本不兼容。
  /// + < 0: 调用失败，错误码对应具体描述参看 [错误码表](https://www.volcengine.com/docs/6705/102042)。
  ///
  /// 注意：
  /// + 调用本方法前，必须先调用 [RTCVideoEffect.initCVResource] 进行初始化。
  /// + 调用该方法后，特效不直接生效，你还需调用 [RTCVideoEffect.setEffectNodes] 设置视频特效素材包或调用调用 [RTCVideoEffect.setColorFilter] 设置滤镜。
  /// + 调用 [RTCVideoEffect.disableVideoEffect] 关闭视频特效。
  Future<int?> enableVideoEffect();

  /// 关闭视频特效。
  ///
  /// 返回值：
  /// + 0: 调用成功。
  /// + –1000: 未集成特效 SDK。
  /// + –1001: 特效 SDK 不支持该功能。
  /// + –1002: 特效 SDK 版本不兼容。
  /// + < 0: 调用失败，错误码对应具体描述参看 [错误码表](https://www.volcengine.com/docs/6705/102042)。
  ///
  /// 注意：调用 [RTCVideoEffect.enableVideoEffect] 开启视频特效。
  Future<int?> disableVideoEffect();

  /// 设置视频特效素材包。
  ///
  /// [effectNodes]：特效素材包绝对路径数组。<br>
  /// 要取消当前视频特效，将此参数设置为 null。
  ///
  /// 返回值：
  /// + 0: 调用成功。
  /// + –1000: 未集成特效 SDK。
  /// + –1001: 特效 SDK 不支持该功能。
  /// + –1002: 特效 SDK 版本不兼容。
  /// + < 0: 调用失败，错误码对应具体描述参看 [错误码表](https://www.volcengine.com/docs/6705/102042)。
  ///
  /// 注意：调用本方法前，必须先调用 [RTCVideoEffect.enableVideoEffect] 开启视频特效。
  Future<int?> setEffectNodes(List<String>? effectNodes);

  /// 设置特效强度。
  ///
  /// [effectNode]：特效素材包绝对路径，参考[素材包结构说明](https://www.volcengine.com/docs/6705/102039)。
  ///
  /// [key]：需要设置的素材 key 名称，参考[素材 key 对应说明](https://www.volcengine.com/docs/6705/102041)。
  ///
  /// [value]：特效强度值，取值范围 `[0,1]`，超出范围时设置无效。
  ///
  /// 返回值：
  /// + 0: 调用成功。
  /// + –1000: 未集成特效 SDK。
  /// + –1001: 特效 SDK 不支持该功能。
  /// + –1002: 特效 SDK 版本不兼容。
  /// + < 0: 调用失败，错误码对应具体描述参看 [错误码表](https://www.volcengine.com/docs/6705/102042)。
  Future<int?> updateEffectNode({
    required String effectNode,
    required String key,
    required double value,
  });

  /// 设置颜色滤镜。
  ///
  /// [resFile]：滤镜资源包绝对路径。
  ///
  /// 返回值：
  /// + 0: 调用成功。
  /// + –1000: 未集成特效 SDK。
  /// + –1001: 特效 SDK 不支持该功能。
  /// + –1002: 特效 SDK 版本不兼容。
  /// + < 0: 调用失败，错误码对应具体描述参看 [错误码表](https://www.volcengine.com/docs/6705/102042)。
  ///
  /// 注意：调用 [RTCVideoEffect.setColorFilterIntensity] 设置已启用颜色滤镜的强度。设置强度为 0 时即关闭颜色滤镜。
  Future<int?> setColorFilter(String? resFile);

  /// 设置已启用颜色滤镜的强度。
  ///
  /// [intensity]：滤镜强度。取值范围 `[0,1]`，超出范围时设置无效。<br>
  /// 当设置滤镜强度为 0 时即关闭颜色滤镜。
  ///
  /// 返回值：
  /// + 0: 调用成功。
  /// + –1000: 未集成特效 SDK。
  /// + –1001: 特效 SDK 不支持该功能。
  /// + –1002: 特效 SDK 版本不兼容。
  /// + < 0: 调用失败，错误码对应具体描述参看 [错误码表](https://www.volcengine.com/docs/6705/102042)。
  Future<int?> setColorFilterIntensity(double intensity);

  /// 将摄像头采集画面中的人像背景替换为指定图片或纯色背景。
  ///
  /// [modelPath]：背景贴纸特效素材绝对路径。
  ///
  /// [source]：背景贴纸对象。
  ///
  /// 返回值：
  /// + 0: 调用成功。
  /// + –1000: 未集成特效 SDK。
  /// + –1001: 特效 SDK 不支持该功能。
  /// + –1002: 特效 SDK 版本不兼容。
  /// + < 0: 调用失败，错误码对应具体描述参看 [错误码表](https://www.volcengine.com/docs/6705/102042)。
  ///
  /// 注意：
  /// + 调用本方法前，必须先调用 [RTCVideoEffect.initCVResource] 进行初始化。
  /// + 调用 [RTCVideoEffect.disableVirtualBackground] 关闭虚拟背景。
  Future<int?> enableVirtualBackground({
    required String modelPath,
    required VirtualBackgroundSource source,
  });

  /// 关闭虚拟背景。
  ///
  /// 返回值：
  /// + 0: 调用成功。
  /// + –1000: 未集成特效 SDK。
  /// + –1001: 特效 SDK 不支持该功能。
  /// + –1002: 特效 SDK 版本不兼容。
  /// + < 0: 调用失败，错误码对应具体描述参看 [错误码表](https://www.volcengine.com/docs/6705/102042)。
  ///
  /// 注意：调用 [RTCVideoEffect.enableVirtualBackground] 开启虚拟背景后，可以调用此接口关闭虚拟背景。
  Future<int?> disableVirtualBackground();

  /// 注册人脸检测结果回调观察者。
  ///
  /// 注册此观察者后，你会周期性收到 [RTCFaceDetectionObserver.onFaceDetectResult] 回调。
  ///
  /// [observer]：人脸检测结果回调观察者。
  ///
  /// [interval]：时间间隔，必须大于 0。单位：ms。实际收到回调的时间间隔大于 `interval`，小于 `interval+视频采集帧间隔`。
  ///
  /// 返回值：
  /// + 0: 调用成功。
  /// + –1000: 未集成特效 SDK。
  /// + –1001: 特效 SDK 不支持该功能。
  /// + –1002: 特效 SDK 版本不兼容。
  /// + -1004: 初始化中，初始化完成后启动此功能。
  /// + < 0: 调用失败，错误码对应具体描述参看 [错误码表](https://www.volcengine.com/docs/6705/102042)。
  Future<int?> enableFaceDetection({
    required RTCFaceDetectionObserver observer,
    required String modelPath,
    int interval = 0,
  });

  /// 关闭人脸识别功能
  ///
  /// 返回值：
  /// + 0: 调用成功。
  /// + –1000: 未集成特效 SDK。
  /// + –1001: 特效 SDK 不支持该功能。
  /// + –1002: 特效 SDK 版本不兼容。
  /// + < 0: 调用失败，错误码对应具体描述参看 [错误码表](https://www.volcengine.com/docs/6705/102042)。
  Future<int?> disableFaceDetection();
}
