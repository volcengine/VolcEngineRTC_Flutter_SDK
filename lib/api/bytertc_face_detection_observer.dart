// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_event_define.dart';
import 'bytertc_video_effect_api.dart';

/// 人脸检测结果回调观察者
class RTCFaceDetectionObserver {
  /// 特效 SDK 进行人脸检测结果的回调
  ///
  /// 调用 [RTCVideoEffect.enableFaceDetection] 注册了 [RTCFaceDetectionObserver]，并使用 RTC SDK 中包含的特效 SDK 进行视频特效处理时，你会收到此回调。
  OnFaceDetectResultType? onFaceDetectResult;

  /// @nodoc
  RTCFaceDetectionObserver({
    this.onFaceDetectResult,
  });
}
