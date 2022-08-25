// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:quickstart/user_live_view.dart';
import 'package:volc_engine_rtc/volc_engine_rtc.dart';

import 'constants.dart';

/// VolcEngineRTC 视频通话的主页面
/// 本示例不限制房间内最大用户数；同时最多渲染四个用户的视频数据（自己和三个远端用户视频数据）；
///
/// 包含如下简单功能：
/// - 创建引擎
/// - 设置视频发布参数
/// - 渲染本地的视频数据
/// - 创建音视频通话房间
/// - 加入音视频通话房间
/// - 切换前置/后置摄像头
/// - 打开/关闭麦克风
/// - 打开/关闭摄像头
/// - 切换听筒/扬声器
/// - 渲染远端用户的视频数据
/// - 离开房间
/// - 销毁房间
/// - 销毁引擎
///
/// 实现一个基本的音视频通话的流程如下：
/// 1.创建引擎 [RTCVideo.createRTCVideo]
/// 2.设置编码参数 [RTCVideo.setMaxVideoEncoderConfig]
/// 3.开启本地视频采集 [RTCVideo.startVideoCapture]
/// 4.设置本地视频渲染视图 [RTCViewContext.localContext]
/// 5.创建音视频通话房间 [RTCVideo.createRTCRoom]
/// 6.加入音视频通话房间 [RTCRoom.joinRoom]
/// 7.在收到远端用户视频首帧之后，设置用户的视频渲染视图 [RTCViewContext.remoteContext]
/// 8.离开音视频通话房间 [RTCRoom.leaveRoom]
/// 9.销毁房间 [RTCRoom.destroy]
/// 10.销毁引擎 [RTCVideo.destroy]
///
/// 有以下常见的注意事项：
/// 1.本示例中，我们在 [RTCVideoEventHandler.onFirstRemoteVideoFrameDecoded] 这个事件中给远端用户设置远端用户视频渲染视图，这个回调表示的是收到了远端用户的视频第一帧。当然也可以在 [RTCRoomEventHandler.onUserJoined] 回调中设置远端用户视频渲染视图
/// 2.用户成功加入房间后，SDK 会通过 [RTCRoomEventHandler.onUserJoined] 回调已经在房间的用户信息
/// 3.SDK 支持同时发布多个参数的视频流，接口是 [RTCVideo.enableSimulcastMode] 和 [RTCVideo.setVideoEncoderConfig]
/// 4.加入房间时，需要有有效的 token，加入失败时会通过 [RTCVideoEventHandler.onError] 输出对应的错误码
/// 5.用户可以通过 [RTCRoom.joinRoom] 中的 roomProfile 来获得不同场景下的性能优化。本示例是音视频通话场景，因此使用 [RoomProfile.communication]
/// 6.不需要在每次加入/退出房间时销毁引擎。本示例退出房间时销毁引擎是为了展示完整的使用流程
///
/// 详细的API文档参见: https://pub.dev/documentation/volc_engine_rtc/latest/
class RoomPage extends StatefulWidget {
  final String roomId;
  final String userId;

  const RoomPage({Key? key, required this.roomId, required this.userId})
      : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  RTCVideo? _rtcVideo;
  RTCRoom? _rtcRoom;
  final RTCVideoEventHandler _videoHandler = RTCVideoEventHandler();
  final RTCRoomEventHandler _roomHandler = RTCRoomEventHandler();

  RTCViewContext? _localRenderContext;
  RTCViewContext? _firstRemoteRenderContext;
  RTCViewContext? _secondRemoteRenderContext;
  RTCViewContext? _thirdRemoteRenderContext;

  bool _isCameraFront = true;
  bool _isSpeakerphone = true;
  bool _enableAudio = true;
  bool _enableVideo = true;

  @override
  void initState() {
    super.initState();
    _initVideoEventHandler();
    _initRoomEventHandler();
    _initVideoAndJoinRoom();
  }

  @override
  void dispose() {
    super.dispose();

    /// 销毁房间
    _rtcRoom?.destroy();

    /// 销毁引擎
    _rtcVideo?.destroy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                height: 49,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ImageButton(
                        onPressed: () {
                          _switchCamera();
                        },
                        imageName: 'switch_camera',
                        size: 26),
                    Expanded(
                        child: Text('RoomID:${widget.roomId}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18))),
                    ImageButton(
                        onPressed: () {
                          _switchAudioRoute();
                        },
                        imageName: _isSpeakerphone ? 'speaker' : 'ear_on',
                        size: 26)
                  ],
                )),
            Expanded(
                child: Container(
                    decoration: const BoxDecoration(color: Colors.grey),
                    child: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Wrap(
                          children: _buildRenderView(context, constraints));
                    }))),
            SizedBox(
                height: 49,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ImageButton(
                        onPressed: () {
                          _enableLocalAudio();
                        },
                        imageName: _enableAudio ? 'normal_audio' : 'mute_audio',
                        size: 28),
                    ImageButton(
                        onPressed: () {
                          _hangUp();
                        },
                        imageName: 'hang_up',
                        size: 36),
                    ImageButton(
                        onPressed: () {
                          _enableLocalVideo();
                        },
                        imageName: _enableVideo ? 'normal_video' : 'mute_video',
                        size: 28)
                  ],
                ))
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRenderView(
      BuildContext context, BoxConstraints constraints) {
    double height = constraints.maxHeight * 0.5;
    double width = constraints.maxWidth * 0.5;
    List<Widget> renderViewList = [];
    if (_localRenderContext != null) {
      renderViewList.add(SizedBox(
          height: height,
          width: width,
          child: UserLiveView(viewContext: _localRenderContext!)));
    }
    if (_firstRemoteRenderContext != null) {
      renderViewList.add(SizedBox(
          height: height,
          width: width,
          child: UserLiveView(viewContext: _firstRemoteRenderContext!)));
    }
    if (_secondRemoteRenderContext != null) {
      renderViewList.add(SizedBox(
          height: height,
          width: width,
          child: UserLiveView(viewContext: _secondRemoteRenderContext!)));
    }
    if (_thirdRemoteRenderContext != null) {
      renderViewList.add(SizedBox(
          height: height,
          width: width,
          child: UserLiveView(viewContext: _thirdRemoteRenderContext!)));
    }
    if (renderViewList.isEmpty) {
      renderViewList.add(const SizedBox());
    }
    return renderViewList;
  }

  void _initVideoAndJoinRoom() async {
    /// 创建引擎
    _rtcVideo = await RTCVideo.createRTCVideo(
        RTCVideoContext(appId, eventHandler: _videoHandler));

    if (_rtcVideo == null) {
      _showAlert('引擎创建失败\n请先检查是否设置正确的AppId');
      return;
    }

    /// 设置视频发布参数
    VideoEncoderConfig solution = VideoEncoderConfig(
      width: 360,
      height: 640,
      frameRate: 15,
      maxBitrate: 800,
      encoderPreference: EncoderPreference.maintainFrameRate,
    );
    _rtcVideo?.setMaxVideoEncoderConfig(solution);

    /// 设置本地视频渲染视图
    setState(() {
      _localRenderContext = RTCViewContext.localContext(uid: widget.userId);
    });

    /// 开启本地视频采集
    _rtcVideo?.startVideoCapture();

    /// 开启本地音频采集
    _rtcVideo?.startAudioCapture();

    /// 创建房间
    _rtcRoom = await _rtcVideo?.createRTCRoom(widget.roomId);

    /// 设置房间事件回调处理
    _rtcRoom?.setRTCRoomEventHandler(_roomHandler);

    /// 加入房间
    UserInfo userInfo = UserInfo(uid: widget.userId);
    RoomConfig roomConfig = RoomConfig(
        isAutoPublish: true,
        isAutoSubscribeAudio: true,
        isAutoSubscribeVideo: true);
    _rtcRoom?.joinRoom(
        token: token, userInfo: userInfo, roomConfig: roomConfig);
  }

  void _initVideoEventHandler() {
    /// SDK收到第一帧远端视频解码数据后，用户收到此回调。
    _videoHandler.onFirstRemoteVideoFrameDecoded =
        (RemoteStreamKey streamKey, VideoFrameInfo videoFrameInfo) {
      debugPrint('onFirstRemoteVideoFrameDecoded: ${streamKey.uid}');
      if (_firstRemoteRenderContext?.uid == streamKey.uid ||
          _secondRemoteRenderContext?.uid == streamKey.uid ||
          _thirdRemoteRenderContext?.uid == streamKey.uid) {
        return;
      }

      if (_firstRemoteRenderContext == null) {
        setState(() {
          _firstRemoteRenderContext = RTCViewContext.remoteContext(
              roomId: widget.roomId, uid: streamKey.uid);
        });
      } else if (_secondRemoteRenderContext == null) {
        setState(() {
          _secondRemoteRenderContext = RTCViewContext.remoteContext(
              roomId: widget.roomId, uid: streamKey.uid);
        });
      } else if (_thirdRemoteRenderContext == null) {
        setState(() {
          _thirdRemoteRenderContext = RTCViewContext.remoteContext(
              roomId: widget.roomId, uid: streamKey.uid);
        });
      } else {}
    };

    /// 警告回调，详细可以看 {https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_common_defines/WarningCode.html}
    _videoHandler.onWarning = (WarningCode code) {
      debugPrint('warningCode: $code');
    };

    /// 错误回调，详细可以看 {https://pub.dev/documentation/volc_engine_rtc/latest/api_bytertc_common_defines/ErrorCode.html}
    _videoHandler.onError = (ErrorCode code) {
      debugPrint('errorCode: $code');
      _showAlert('errorCode: $code');
    };
  }

  void _initRoomEventHandler() {
    /// 远端主播角色用户加入房间回调。
    _roomHandler.onUserJoined = (UserInfo userInfo, int elapsed) {
      debugPrint('onUserJoined: ${userInfo.uid}');
    };

    /// 远端用户离开房间回调。
    _roomHandler.onUserLeave = (String uid, UserOfflineReason reason) {
      debugPrint('onUserLeave: $uid reason: $reason');
      if (_firstRemoteRenderContext?.uid == uid) {
        setState(() {
          _firstRemoteRenderContext = null;
        });
        _rtcVideo?.removeRemoteVideo(uid: uid, roomId: widget.roomId);
      } else if (_secondRemoteRenderContext?.uid == uid) {
        setState(() {
          _secondRemoteRenderContext = null;
        });
        _rtcVideo?.removeRemoteVideo(uid: uid, roomId: widget.roomId);
      } else if (_thirdRemoteRenderContext?.uid == uid) {
        setState(() {
          _thirdRemoteRenderContext = null;
        });
        _rtcVideo?.removeRemoteVideo(uid: uid, roomId: widget.roomId);
      }
    };
  }

  void _showAlert(String warning) => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(warning),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, '知道了'),
              child: const Text('知道了'),
            ),
          ],
        ),
      );

  void _switchCamera() {
    _isCameraFront = !_isCameraFront;

    /// 切换前置/后置摄像头（默认使用前置摄像头）
    CameraId cameraId = _isCameraFront ? CameraId.front : CameraId.back;
    _rtcVideo?.switchCamera(cameraId);
  }

  void _switchAudioRoute() {
    setState(() {
      _isSpeakerphone = !_isSpeakerphone;
    });

    /// 设置使用扬声器/听筒播放音频数据
    AudioRoute audioRoute =
        _isSpeakerphone ? AudioRoute.speakerphone : AudioRoute.earpiece;
    _rtcVideo?.setDefaultAudioRoute(audioRoute);
  }

  void _enableLocalAudio() {
    setState(() {
      _enableAudio = !_enableAudio;
    });
    if (_enableAudio) {
      /// 开启本地音频发送
      _rtcRoom?.publishStream(MediaStreamType.audio);
    } else {
      /// 关闭本地音频发送
      _rtcRoom?.unpublishStream(MediaStreamType.audio);
    }
  }

  void _enableLocalVideo() {
    setState(() {
      _enableVideo = !_enableVideo;
    });
    if (_enableVideo) {
      /// 开启视频采集
      _rtcVideo?.startVideoCapture();
    } else {
      /// 关闭视频采集
      _rtcVideo?.stopVideoCapture();
    }
  }

  void _hangUp() {
    /// 离开房间
    _rtcRoom?.leaveRoom();
    Navigator.pop(context, true);
  }
}

/// 图标按钮
class ImageButton extends StatelessWidget {
  final String imageName;

  final double? size;

  final VoidCallback? onPressed;

  const ImageButton(
      {Key? key, required this.imageName, this.size, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double? iconSize = size ?? IconTheme.of(context).size;
    return GestureDetector(
        onTap: onPressed,
        child: SizedBox(
          height: iconSize,
          width: iconSize,
          child: Image.asset('assets/$imageName.png'),
        ));
  }
}
