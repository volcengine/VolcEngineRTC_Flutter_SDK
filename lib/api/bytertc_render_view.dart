// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../src/bytertc_render_view_impl.dart';
import 'bytertc_common_defines.dart';
import 'bytertc_video_defines.dart';

/// 画布类型
enum VideoCanvasType {
  /// 用于渲染本地视频的画布
  local,

  /// 用于渲染远端视频的画布
  remote,

  /// 用于渲染公共视频流的画布
  publicStream,

  /// 回路测试时渲染本地视频的画布
  echoTest,
}

/// 用于 [RTCSurfaceView] 初始化
class RTCViewContext {
  /// 画布类型
  final VideoCanvasType canvasType;

  /// 需要被渲染的用户所在的房间 ID
  final String roomId;

  /// 需要被渲染的用户的 ID
  final String uid;

  /// 流属性，包括主流和屏幕共享流
  final StreamIndex streamType;

  /// 设置渲染本地视频的画布
  ///
  /// 应用程序通过调用此接口将画布和本地视频流绑定。<br>
  /// 在应用程序开发中，通常在初始化后调用该方法进行本地视频设置，然后再加入房间，退出房间后绑定仍然有效。<br>
  /// 调用 [RTCVideo.removeLocalVideo] 可解除绑定。
  RTCViewContext.localContext({
    required this.uid,
    this.streamType = StreamIndex.main,
  })  : canvasType = VideoCanvasType.local,
        roomId = '';

  /// 设置渲染远端视频的画布
  ///
  /// 应用程序通过调用此接口将画布和远端视频流绑定。退出房间后绑定仍然有效。<br>
  /// 调用 [RTCVideo.removeRemoteVideo] 解除绑定。
  RTCViewContext.remoteContext({
    required this.roomId,
    required this.uid,
    this.streamType = StreamIndex.main,
  }) : canvasType = VideoCanvasType.remote;

  /// 设置渲染公共视频流的画布
  ///
  /// 应用程序通过调用此接口将画布和公共视频流绑定。退出房间后绑定仍然有效。<br>
  /// 调用 [RTCVideo.removePublicStreamVideo] 解除绑定。
  RTCViewContext.publicStreamContext(String publicStreamId)
      : canvasType = VideoCanvasType.publicStream,
        roomId = '',
        uid = publicStreamId,
        streamType = StreamIndex.main;

  /// 设置渲染通话前回路测试视频流的画布
  RTCViewContext.echoTestContext()
      : canvasType = VideoCanvasType.echoTest,
        roomId = '',
        uid = '',
        streamType = StreamIndex.main;
}

/// 视频渲染设置。
///
/// 若使用 Flutter 3.0.0 及以上版本开发 Android 应用，建议使用 Android 6.0 及以上设备，否则会出现图层显示错误。
///
/// 不同平台对应不同对象：
/// + Android: [TextureView](https://developer.android.com/reference/android/view/TextureView).
/// + iOS: [UIView](https://developer.apple.com/documentation/uikit/uiview).
class RTCSurfaceView extends StatefulWidget {
  /// 传入 context 用于实例初始化
  final RTCViewContext context;

  /// 视频渲染模式
  final VideoRenderMode renderMode;

  /// 用于填充画布空白部分的背景颜色
  ///
  /// 取值范围是 `[0x0000000, 0xFFFFFFFF]`，默认值是 `0x00000000`。
  final int backgroundColor;

  /// 暂不可用
  ///
  /// 设置 `SurfaceView` 的 Surface 是否放置在本身所在窗口的最顶部。 <br>
  /// 具体参看 [setZOrderOnTop](https://developer.android.com/reference/android/view/SurfaceView#setZOrderOnTop(boolean))。仅适用于 Android。
  final bool zOrderOnTop;

  /// 暂不可用
  ///
  /// 设置 `SurfaceView` 的 Surface 是否放置在另一个常规 `SurfaceView` 的顶部。<br>
  /// 具体参看 [setZOrderMediaOverlay](https://developer.android.com/reference/android/view/SurfaceView#setZOrderMediaOverlay(boolean))。仅适用于 Android。
  final bool zOrderMediaOverlay;

  /// `PlatformView` 被创建时，收到此回调
  final PlatformViewCreatedCallback? onPlatformViewCreated;

  /// 应将哪些手势传给 `PlatformView`
  ///
  /// + iOS 参看 [gestureRecognizers property](https://api.flutter.dev/flutter/widgets/UiKitView/gestureRecognizers.html)。
  /// + Android 参看 [gestureRecognizers property](https://api.flutter.dev/flutter/widgets/AndroidView/gestureRecognizers.html)。
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  const RTCSurfaceView({
    Key? key,
    required this.context,
    this.renderMode = VideoRenderMode.hidden,
    this.backgroundColor = 0,
    this.zOrderOnTop = false,
    this.zOrderMediaOverlay = false,
    this.onPlatformViewCreated,
    this.gestureRecognizers,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => RTCSurfaceViewState();
}
