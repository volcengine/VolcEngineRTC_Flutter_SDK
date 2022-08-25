// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'package:flutter/material.dart';
import 'package:volc_engine_rtc/api/bytertc_render_view.dart';

class UserLiveView extends StatefulWidget {
  final RTCViewContext viewContext;

  const UserLiveView({Key? key, required this.viewContext}) : super(key: key);

  @override
  State<UserLiveView> createState() => _UserLiveViewState();
}

class _UserLiveViewState extends State<UserLiveView> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      /// 根据 [RTCViewContext] 创建视频渲染视图 [RTCSurfaceView]
      Expanded(child: RTCSurfaceView(context: widget.viewContext)),
      SizedBox(
          height: 30,
          child: Center(
              child: Text(widget.viewContext.uid,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis)))
    ]);
  }
}
