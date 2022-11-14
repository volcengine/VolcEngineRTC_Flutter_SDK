// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../api/bytertc_render_view.dart';
import 'base/bytertc_enum_convert.dart';

class RTCSurfaceViewState extends State<RTCSurfaceView> {
  static final Map<int, MethodChannel> _channels = {};

  int? _id;

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: AndroidView(
          viewType: 'ByteRTCSurfaceView',
          onPlatformViewCreated: _onPlatformViewCreated,
          hitTestBehavior: PlatformViewHitTestBehavior.transparent,
          creationParams: {
            'canvasType': widget.context.canvasType.value,
            'roomId': widget.context.roomId,
            'uid': widget.context.uid,
            'streamType': widget.context.streamType.value,
            'renderMode': widget.renderMode.value,
            'backgroundColor': widget.backgroundColor,
            'zOrderOnTop': widget.zOrderOnTop,
            'zOrderMediaOverlay': widget.zOrderMediaOverlay,
          },
          creationParamsCodec: const StandardMessageCodec(),
          gestureRecognizers: widget.gestureRecognizers,
        ),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: UiKitView(
          viewType: 'ByteRTCSurfaceView',
          onPlatformViewCreated: _onPlatformViewCreated,
          hitTestBehavior: PlatformViewHitTestBehavior.transparent,
          creationParams: {
            'canvasType': widget.context.canvasType.value,
            'roomId': widget.context.roomId,
            'uid': widget.context.uid,
            'streamType': widget.context.streamType.value,
            'renderMode': widget.renderMode.value,
            'backgroundColor': widget.backgroundColor,
          },
          creationParamsCodec: const StandardMessageCodec(),
          gestureRecognizers: widget.gestureRecognizers,
        ),
      );
    }
    return Text('$defaultTargetPlatform is not yet supported by the plugin');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(RTCSurfaceView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.context.uid != widget.context.uid ||
        oldWidget.context.roomId != widget.context.roomId ||
        oldWidget.context.canvasType != widget.context.canvasType ||
        oldWidget.context.streamType != widget.context.streamType) {
      _setVideoCanvas();
    } else if (oldWidget.renderMode != widget.renderMode ||
        oldWidget.backgroundColor != widget.backgroundColor) {
      _updateVideoCanvas();
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      if (oldWidget.zOrderOnTop != widget.zOrderOnTop) {
        _setZOrderOnTop();
      }
      if (oldWidget.zOrderMediaOverlay != widget.zOrderMediaOverlay) {
        _setZOrderMediaOverlay();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _channels.remove(_id);
  }

  Map<String, dynamic> videoParams() {
    return <String, dynamic>{
      'roomId': widget.context.roomId,
      'uid': widget.context.uid,
      'streamType': widget.context.streamType.value,
      'renderMode': widget.renderMode.value,
      'backgroundColor': widget.backgroundColor,
    };
  }

  void _setVideoCanvas() {
    switch (widget.context.canvasType) {
      case VideoCanvasType.local:
        _setLocalVideo();
        break;
      case VideoCanvasType.remote:
        _setRemoteVideo();
        break;
      case VideoCanvasType.publicStream:
        _setPublicVideo();
        break;
      case VideoCanvasType.echoTest:
        _setEchoTestVideo();
        break;
    }
  }

  void _updateVideoCanvas() {
    switch (widget.context.canvasType) {
      case VideoCanvasType.local:
        _updateLocalVideo();
        break;
      case VideoCanvasType.remote:
        _updateRemoteVideo();
        break;
      case VideoCanvasType.publicStream:
        _setPublicVideo();
        break;
      case VideoCanvasType.echoTest:
        _setEchoTestVideo();
        break;
    }
  }

  void _setLocalVideo() {
    _channels[_id]?.invokeMethod('setupLocalVideo', videoParams());
  }

  void _setRemoteVideo() {
    _channels[_id]?.invokeMethod('setupRemoteVideo', videoParams());
  }

  void _setPublicVideo() {
    _channels[_id]?.invokeMethod('setupPublicStreamVideo', videoParams());
  }

  void _setEchoTestVideo() {
    _channels[_id]?.invokeMethod('setupEchoTestVideo', videoParams());
  }

  void _updateLocalVideo() {
    _channels[_id]?.invokeMethod('updateLocalVideo', videoParams());
  }

  void _updateRemoteVideo() {
    _channels[_id]?.invokeMethod('updateRemoteVideo', videoParams());
  }

  void _setZOrderOnTop() {
    _channels[_id]?.invokeMethod('setZOrderOnTop', {
      'onTop': widget.zOrderOnTop,
    });
  }

  void _setZOrderMediaOverlay() {
    _channels[_id]?.invokeMethod('setZOrderMediaOverlay', {
      'isMediaOverlay': widget.zOrderMediaOverlay,
    });
  }

  void _onPlatformViewCreated(int id) async {
    _id = id;
    if (!_channels.containsKey(id)) {
      _channels[id] = MethodChannel('com.bytedance.ve_rtc_surfaceView$id');
    }
    widget.onPlatformViewCreated?.call(id);
  }
}
