// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_event_define.dart';

/// 语音识别服务使用状态回调
class RTCASREngineEventHandler {
  /// 语音识别服务开启成功。
  EmptyCallbackType? onSuccess;

  /// 语音转文字成功，该回调返回识别后的全量消息。
  ///
  /// 若识别过程中发生了网络连接中断，则重连后回调的信息中只包含重连后识别的文字消息，不再包含上一次连接后识别的消息。
  OnMessageType? onMessage;

  /// 语音识别服务内部发生错误事件。
  OnErrorMsgType? onErrorMsg;

  /// @nodoc
  RTCASREngineEventHandler({
    this.onSuccess,
    this.onMessage,
    this.onErrorMsg,
  });
}
