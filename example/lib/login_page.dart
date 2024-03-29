// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:volc_engine_rtc_example/room_page.dart';
import 'package:volc_engine_rtc/volc_engine_rtc.dart';

import 'constants.dart';
import 'localizations.dart';

/// VolcEngineRTC 音视频通话入口页面
///
/// 包含如下简单功能：
/// - 该页面用来跳转至音视频通话主页面
/// - 校验房间名和用户名
/// - 展示当前 SDK 使用的版本号 [RTCVideo.getSdkVersion]
///
/// 有以下常见的注意事项：
/// 1.Android SDK必要的权限有：外部内存读写、摄像头权限、麦克风权限，其余完整的权限参见{@link android/app/src/main/AndroidManifest.xml}。
/// 没有这些权限不会导致崩溃，但是会影响SDK的正常使用。
/// 2.SDK 对房间名、用户名的限制是：非空且最大长度不超过128位的数字、大小写字母、@ . _ -
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _roomIdTextController = TextEditingController();
  final TextEditingController _userIDTextController = TextEditingController();
  final FocusNode _roomIDFocusNode = FocusNode();
  final FocusNode _userIDFocusNode = FocusNode();

  String _version = Localizator.version;

  @override
  void initState() {
    super.initState();
    _requestPermission();

    /// 获取当前SDK的版本号
    RTCVideo.getSDKVersion().then((value) {
      setState(() {
        _version = Localizator.version + (value ?? "");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      Align(
          alignment: const Alignment(0, -0.25),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  focusNode: _roomIDFocusNode,
                  controller: _roomIdTextController,
                  decoration: InputDecoration(labelText: Localizator.roomIDDec),
                ),
                TextField(
                  focusNode: _userIDFocusNode,
                  controller: _userIDTextController,
                  decoration: InputDecoration(labelText: Localizator.userIDDec),
                ),
                ElevatedButton(
                  child: Text(
                    Localizator.joinRoom,
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    _joinRoom();
                  },
                )
              ],
            ),
          )),
      Positioned(
          left: 20,
          right: 20,
          bottom: 0,
          child: Text(
            _version,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black, fontSize: 18),
          ))
    ])));
  }

  void _requestPermission() async {
    await [Permission.camera, Permission.microphone].request();
  }

  void _joinRoom() {
    String roomId = _roomIdTextController.text;
    String userId = _userIDTextController.text;
    if (roomId.isEmpty) {
      _showAlert(Localizator.emptyRoomIdTip);
      return;
    }
    if (userId.isEmpty) {
      _showAlert(Localizator.emptyUserIdTip);
      return;
    }
    if (_checkValidity(roomId) == false) {
      _showAlert(Localizator.illegalRoomIdTip);
      return;
    }
    if (_checkValidity(userId) == false) {
      _showAlert(Localizator.illegalUserIdTip);
      return;
    }
    _roomIDFocusNode.unfocus();
    _userIDFocusNode.unfocus();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RoomPage(roomId: roomId, userId: userId);
    }));
  }

  bool _checkValidity(String string) => RegExp(inputRegexp).hasMatch(string);

  void _showAlert(String warning) => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: Text(warning),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(Localizator.ok),
            ),
          ],
        ),
      );
}
