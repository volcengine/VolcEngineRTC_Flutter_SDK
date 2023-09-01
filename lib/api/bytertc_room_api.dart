// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_media_defines.dart';
import 'bytertc_range_audio_api.dart';
import 'bytertc_room_event_handler.dart';
import 'bytertc_rts_defines.dart';
import 'dart:typed_data';

import 'bytertc_spatial_audio_api.dart';
import 'bytertc_video_api.dart';
import 'bytertc_video_defines.dart';
import 'bytertc_video_event_handler.dart';

/// 房间接口
abstract class RTCRoom {
  /// 获取房间 ID
  String get roomId;

  /// 退出并销毁调用 [RTCVideo.createRTCRoom] 所创建的房间实例。
  Future<void> destroy();

  /// 设置事件句柄
  ///
  /// 通过设置事件句柄可以监听房间的回调事件。
  void setRTCRoomEventHandler(RTCRoomEventHandler eventHandler);

  /// 加入房间
  ///
  /// 多房间场景下，调用 [RTCVideo.createRTCRoom] 创建房间后，调用此方法加入房间，同房间内其他用户进行音视频通话。
  ///
  /// [token] 动态密钥，用于对进房用户进行鉴权验证。  <br>
  /// 测试时可使用控制台生成临时 token，正式上线需要使用密钥 SDK 在你的服务端生成并下发 token。Token 有效期及生成方式参看[使用 Token 完成鉴权](https://www.volcengine.com/docs/6348/70121)。  <br>
  /// 使用不同 AppID 的 App 是不能互通的，请务必保证生成 token 使用的 AppID 和创建引擎时使用的 AppID 相同，否则会导致加入房间失败。具体失败原因会通过 [RTCRoomEventHandler.onRoomStateChanged] 回调告知。
  ///
  /// [userInfo] 用户信息。
  ///
  /// [roomConfig] 房间参数配置，设置房间模式以及是否自动发布或订阅流。
  ///
  /// 返回值：方法调用结果
  /// + 0：成功。
  /// + -1：失败，userInfo 包含了无效的参数。
  /// + -2：失败，已经在房间内。接口调用成功后，只要收到返回值为 0，且未调用 [RTCRoom.leaveRoom] 成功，则再次调用进房接口时，无论填写的房间 ID 和用户 ID 是否重复，均触发此返回值。
  /// + -3：失败，room 为空。
  ///
  /// 注意：
  /// + 同一个 App ID 的同一个房间内，每个用户的用户 ID 必须唯一。如果两个用户的用户 ID 相同，则后进房的用户会将先进房的用户踢出房间，并且先进房的用户会收到 [RTCVideoEventHandler.onError] 回调通知，错误类型详见 [ErrorCode] 中的 duplicateLogin。
  /// + 本地用户调用此方法加入房间成功后，会收到 [RTCRoomEventHandler.onRoomStateChanged] 回调通知。若本地用户同时为可见用户，加入房间时远端用户会收到 [RTCRoomEventHandler.onUserJoined] 回调通知。关于可见性设置参看 [RTCRoom.setUserVisibility]。
  /// + 用户加入房间成功后，在本地网络状况不佳的情况下，SDK 可能会与服务器失去连接，并触发 [RTCVideoEventHandler.onConnectionStateChanged] 回调。此时 SDK 会自动重试，直到成功重连。重连成功后，本地会收到 [RTCRoomEventHandler.onRoomStateChanged] 回调通知；若加入房间的是可见用户，则远端用户会收到 [RTCRoomEventHandler.onUserJoined] 回调通知。
  Future<int?> joinRoom({
    required String token,
    required UserInfo userInfo,
    required RoomConfig roomConfig,
  });

  /// 设置用户可见性。未调用该接口前，本地用户默认对他人可见。
  ///
  /// 通过 [enable] 设置用户可见性和用户在房间内的行为：
  /// + true: 可以被房间中的其他用户感知，且可以在房间内发布和订阅音视频流；
  /// + false: 无法被房间中的其他用户感知，且只能在房间内订阅音视频流。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 该方法在加入房间前后均可调用。
  /// + 在房间内调用此方法，房间内其他用户会收到相应的回调通知：
  ///   - 从 false 切换至 true 时，房间内其他用户会收到 [RTCRoomEventHandler.onUserJoined]
  ///   - 从 true 切换至 false 时，房间内其他用户会收到 [RTCRoomEventHandler.onUserLeave]
  /// + 若调用该方法将可见性设为 false，此时尝试发布流会收到 [RTCVideoEventHandler.onWarning]
  Future<int?> setUserVisibility(bool enable);

  /// 设置发流端音画同步
  ///
  /// 当同一用户同时使用两个通话设备分别采集发送音频和视频时，有可能会因两个设备所处的网络环境不一致而导致发布的流不同步，此时你可以在视频发送端调用该接口，SDK 会根据音频流的时间戳自动校准视频流，以保证接收端听到音频和看到视频在时间上的同步性。
  ///
  /// [audioUid] 传入音频发送端的用户 ID，将该参数设为空则可解除当前音视频的同步关系。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 该方法在进房前后均可调用。
  /// + 进行音画同步的音频发布用户 ID 和视频发布用户 ID 须在同一个 RTC 房间内。
  /// + 调用该接口后音画同步状态发生改变时，你会收到 [RTCRoomEventHandler.onAVSyncStateChange] 回调。
  /// + 同一 RTC 房间内允许存在多个音视频同步关系，但需注意单个音频源不支持与多个视频源同时同步。
  /// + 如需更换同步音频源，再次调用该接口传入新的 `audioUid` 即可；如需更换同步视频源，需先解除当前的同步关系，后在新视频源端开启同步。
  Future<int?> setMultiDeviceAVSync(String audioUid);

  /// 离开房间
  ///
  /// 用户调用此方法离开房间，结束通话过程，释放所有通话相关的资源。<br>
  /// 无论当前是否在房间内，都可以调用此方法。重复调用此方法没有负面影响。<br>
  /// 此方法是异步操作，调用返回时并没有真正退出房间。真正退出房间后，本地会收到 [RTCRoomEventHandler.onLeaveRoom] 回调通知。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 可见用户离开房间后，房间内其他用户会收到 [RTCRoomEventHandler.onUserLeave] 回调通知。
  /// + 如果调用此方法后立即销毁引擎，SDK 将无法触发 [RTCRoomEventHandler.onLeaveRoom] 回调。
  Future<int?> leaveRoom();

  /// 更新 Token
  ///
  /// Token 中同时包含进房、发布和订阅权限，各权限有一定的有效期，并且到期前 30 秒会触发回调，提示用户更新 Token 相关权限。此时需要重新获取 Token，并调用此方法更新 Token，以保证通话的正常进行。
  ///
  /// [token] 重新获取的有效 Token。<br>
  /// 如果传入的 Token 无效，回调错误码为 [ErrorCode] 中的 `updateTokenWithInvalidToken` 提示传入的 Token 无效。
  ///
  /// 返回值参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 3.50（不含）以前的版本中，Token 中的发布和订阅权限为保留参数，无实际控制权限；3.50 及以后版本开放 Token 发布订阅控制权限，如需通过 Token 控制连麦权限，请联系技术支持团队开通白名单后支持。
  /// + 请勿同时调用 [RTCRoom.updateToken] 和 [RTCRoom.joinRoom] 方法更新 Token。若因 Token 过期或无效导致加入房间失败或已被移出房间，你应该在获取新的有效 Token 后调用 [RTCRoom.joinRoom] 重新加入房间。
  Future<int?> updateToken(String token);

  /// 设置期望订阅的远端视频流的参数
  ///
  /// [uid] 传入期望配置订阅参数的远端视频流发布用户的 ID。
  ///
  /// [videoConfig] 传入期望配置的远端视频流参数。
  ///
  /// 返回值参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 该方法仅在发布端调用 [RTCVideo.enableSimulcastMode] 开启了发送多路视频流的情况下生效，此时订阅端将收到来自发布端与期望设置的参数最相近的一路流；否则订阅端只会收到一路参数为分辨率 640px × 360px、帧率 15fps 的视频流。
  /// + 若发布端开启了推送多路流功能，但订阅端不对流参数进行设置，则默认接受发送端设置的分辨率最大的一路视频流。
  /// + 该方法需在进房后调用，若想进房前设置，你需调用 [RTCRoom.joinRoom]，并对 `roomConfig` 中的 `remoteVideoConfig` 进行设置。
  /// + SDK 会根据发布端和所有订阅端的设置灵活调整视频流的参数，具体调整策略详见[推送多路流](https://www.volcengine.com/docs/6348/70139)文档。
  Future<int?> setRemoteVideoConfig({
    required String uid,
    required RemoteVideoConfig videoConfig,
  });

  /// 在当前所在房间内发布本地通过摄像头/麦克风采集的媒体流
  ///
  /// [type] 媒体流类型，用于指定发布音频/视频
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 如果你已经在用户进房时通过调用 [RTCRoom.joinRoom] 成功选择了自动发布，则无需再调用本接口。
  /// + 调用 [RTCRoom.setUserVisibility] 方法将自身设置为不可见后无法调用该方法，需将自身切换至可见后方可调用该方法发布摄像头音视频流。
  /// + 如果你需要发布屏幕共享流，调用 [RTCRoom.publishScreen]。
  /// + 如果你需要向多个房间发布流，调用 [RTCRoom.startForwardStreamToRooms]。
  /// + 调用此方法后，房间中的所有远端用户会收到 [RTCRoomEventHandler.onUserPublishStream] 回调通知，其中成功收到了音频流的远端用户会收到 [RTCVideoEventHandler.onFirstRemoteAudioFrame] 回调，订阅了视频流的远端用户会收到 [RTCVideoEventHandler.onFirstRemoteVideoFrameDecoded] 回调。
  /// + 调用 [RTCRoom.unpublishStream] 取消发布。
  Future<int?> publishStream(MediaStreamType type);

  /// 停止将本地摄像头/麦克风采集的媒体流发布到当前所在房间中
  ///
  /// [type] 媒体流类型，用于取消指定发布音频/视频
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 调用 [RTCRoom.publishStream] 手动发布摄像头音视频流后，你需调用此接口停止发布。
  /// + 调用此方法停止发布音视频流后，房间中的其他用户将会收到 [RTCRoomEventHandler.onUserUnpublishStream] 回调通知。
  Future<int?> unpublishStream(MediaStreamType type);

  /// 在当前所在房间内发布本地屏幕共享音视频流
  ///
  /// [type] 媒体流类型，用于指定发布音频/视频
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 如果你已经在用户进房时通过调用 [RTCRoom.joinRoom] 成功选择了自动发布，则无需再调用本接口。
  /// + 调用 [RTCRoom.setUserVisibility] 方法将自身设置为不可见后无法调用该方法，需将自身切换至可见后方可调用该方法发布屏幕流。
  /// + 调用该方法后，房间中的所有远端用户会收到 [RTCRoomEventHandler.onUserPublishScreen] 回调，其中成功收到音频流的远端用户会收到 [RTCVideoEventHandler.onFirstRemoteAudioFrame] 回调，订阅了视频流的远端用户会收到 [RTCVideoEventHandler.onFirstRemoteVideoFrameDecoded] 回调。
  /// + 调用该方法后，本地用户会收到 [RTCVideoEventHandler.onScreenVideoFrameSendStateChanged]。
  /// + 如果你需要向多个房间发布流，调用 [RTCRoom.startForwardStreamToRooms]。
  /// + 调用 [RTCRoom.unpublishScreen] 取消发布。
  Future<int?> publishScreen(MediaStreamType type);

  /// 停止将本地屏幕共享音视频流发布到当前所在房间中
  ///
  /// [type] 媒体流类型，用于指定取消发布音频/视频。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 调用 [RTCRoom.publishScreen] 发布屏幕流后，你需调用此接口停止发布。
  /// + 调用此方法停止发布屏幕音视频流后，房间中的其他用户将会收到 [RTCRoomEventHandler.onUserUnpublishScreen] 回调。
  Future<int?> unpublishScreen(MediaStreamType type);

  /// 订阅房间内指定的通过摄像头/麦克风采集的媒体流，或更新对指定远端用户的订阅选项
  ///
  /// [uid] 传入指定订阅的远端发布音视频流的用户 ID。
  ///
  /// [type] 传入媒体流类型，用于指定订阅音频/视频。
  ///
  /// 返回值参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 该方法可以用于首次订阅某远端用户，也可用于更新已订阅远端用户的媒体流类型。
  /// + 你必须先通过 [RTCRoomEventHandler.onUserPublishStream] 回调获取当前房间里的远端摄像头音视频流信息，然后调用本方法按需订阅。
  /// + 成功订阅远端用户的媒体流后，订阅关系将持续到调用 [RTCRoom.unsubscribeStream] 取消订阅或本端用户退房。
  /// + 关于其他调用异常，你会收到 [RTCRoomEventHandler.onStreamStateChanged] 回调通知，具体异常原因参看 [ErrorCode]。
  Future<int?> subscribeStream({
    required String uid,
    required MediaStreamType type,
  });

  /// 订阅房间内所有通过摄像头/麦克风采集的媒体流，或更新订阅选项
  ///
  /// [type] 媒体流类型，用于指定取消订阅音频/视频。
  ///
  /// 注意:
  /// + 多次调用订阅接口时，将根据末次调用接口和传入的参数，更新订阅配置。
  /// + 大会模式下，如果房间内的媒体流超过上限，建议通过调用 [subscribeStream] 逐一指定需要订阅的媒体流。
  /// + 调用该方法后，你会收到 [RTCRoomEventHandler.onStreamSubscribed] 通知方法调用结果。
  /// + 成功订阅远端用户的媒体流后，订阅关系将持续到调用 [unsubscribeStream] 取消订阅或本端用户退房。
  /// + 关于其他调用异常，你会收到 [RTCRoomEventHandler.onStreamStateChanged] 回调通知，具体异常原因参看 [ErrorCode]。
  Future<int?> subscribeAllStreams(MediaStreamType type);

  /// 取消订阅房间内指定的通过摄像头/麦克风采集的媒体流
  ///
  /// 该方法对自动订阅和手动订阅模式均适用。
  ///
  /// [uid] 指定取消订阅的远端发布音视频流的用户 ID。
  ///
  /// [type] 传入媒体流类型，用于指定取消订阅音频/视频。
  ///
  /// 返回值参看 [ReturnStatus]。
  ///
  /// 关于其他调用异常，你会收到 [RTCRoomEventHandler.onStreamStateChanged] 回调通知，具体失败原因参看 [ErrorCode]。
  Future<int?> unsubscribeStream({
    required String uid,
    required MediaStreamType type,
  });

  /// 取消订阅房间内所有的通过摄像头/麦克风采集的媒体流。
  ///
  /// 自动订阅和手动订阅的流都可以通过本方法取消订阅。
  ///
  /// [type] 媒体流类型，用于指定取消订阅音频/视频
  ///
  /// 注意:
  /// + 调用该方法后，你会收到 [RTCRoomEventHandler.onStreamSubscribed] 通知方法调用结果。
  /// + 关于其他调用异常，你会收到 [RTCRoomEventHandler.onStreamStateChanged] 回调通知，具体失败原因参看 [ErrorCode]。
  Future<int?> unsubscribeAllStreams(MediaStreamType type);

  /// 订阅房间内指定的远端屏幕共享音视频流，或更新对指定远端用户的订阅选项
  ///
  /// [uid] 指定订阅的远端发布屏幕流的用户 ID。
  ///
  /// [type] 传入媒体流类型，用于指定订阅音频/视频。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 该方法可以用于首次订阅某远端用户的屏幕流，也可用于更新已订阅远端用户的屏幕媒体流类型。
  /// + 你必须先通过 [RTCRoomEventHandler.onUserPublishScreen] 回调获取当前房间里的远端屏幕流信息，然后调用本方法按需订阅。
  /// + 成功订阅远端用户的媒体流后，订阅关系将持续到调用 [RTCRoom.unsubscribeScreen] 取消订阅或本端用户退房。
  /// + 关于其他调用异常，你会收到 [RTCRoomEventHandler.onStreamStateChanged] 回调通知，具体异常原因参看 [ErrorCode]。
  Future<int?> subscribeScreen({
    required String uid,
    required MediaStreamType type,
  });

  /// 取消订阅房间内指定的远端屏幕共享音视频流
  ///
  /// 该方法对自动订阅和手动订阅模式均适用。
  ///
  /// [uid] 指定取消订阅的远端发布屏幕流的用户 ID。
  ///
  /// [type] 传入媒体流类型，用于指定取消订阅音频/视频。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 关于其他调用异常，你会收到 [RTCRoomEventHandler.onStreamStateChanged] 回调通知，具体失败原因参看 [ErrorCode]。
  Future<int?> unsubscribeScreen({
    required String uid,
    required MediaStreamType type,
  });

  /// 暂停接收所有来自远端的媒体流。
  ///
  /// + 该方法仅暂停远端流的接收，并不影响远端流的采集和发送。
  /// + 该方法不改变用户的订阅状态以及订阅流的属性。
  /// + 若想恢复接收远端流，需调用 [RTCRoom.resumeAllSubscribedStream]。
  /// + 多房间场景下，仅暂停接收发布在当前所在房间的流。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  Future<int?> pauseAllSubscribedStream(PauseResumeControlMediaType mediaType);

  /// 恢复接收来自远端的媒体流
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// + 该方法仅恢复远端流的接收，并不影响远端流的采集和发送。
  /// + 该方法不改变用户的订阅状态以及订阅流的属性。
  Future<int?> resumeAllSubscribedStream(PauseResumeControlMediaType mediaType);

  /// 给房间内指定的用户发送文本消息
  ///
  /// [message] 长度不超过 64KB。
  ///
  /// [config] 消息发送的可靠/有序类型。
  ///
  /// 注意：
  /// + 在发送房间内文本消息前，必须先调用 [RTCRoom.joinRoom] 加入房间。
  /// + 调用本接口发送文本信息后，会收到 [RTCRoomEventHandler.onUserMessageSendResult]。
  /// + 若文本消息发送成功，则 [uid] 所指定的用户会收到 [RTCRoomEventHandler.onUserMessageReceived]。
  Future<int?> sendUserMessage({
    required String uid,
    required String message,
    required MessageConfig config,
  });

  /// 给房间内指定的用户发送二进制消息
  ///
  /// [message] 长度不超过 46KB。
  ///
  /// [config] 消息发送的可靠/有序类型。
  ///
  /// 注意：
  /// + 在发送房间内二进制消息前，必须先调用 [RTCRoom.joinRoom] 加入房间。
  /// + 调用本接口发送二进制信息后，会收到 [RTCRoomEventHandler.onUserMessageSendResult]。
  /// + 若二进制消息发送成功，则 [uid] 所指定的用户会收到 [RTCRoomEventHandler.onUserBinaryMessageReceived]。
  Future<int?> sendUserBinaryMessage({
    required String uid,
    required Uint8List message,
    required MessageConfig config,
  });

  /// 给房间内所有用户发送文本消息
  ///
  /// [message] 长度不超过 64KB。
  ///
  /// 注意：
  /// + 在发送文本消息前，必须先调用 [RTCRoom.joinRoom] 加入房间。
  /// + 调用本接口发送文本信息后，会收到 [RTCRoomEventHandler.onRoomMessageSendResult]。
  /// + 若文本消息发送成功，则房间内所有用户会收到 [RTCRoomEventHandler.onRoomMessageReceived]。
  Future<int?> sendRoomMessage(String message);

  /// 给房间内所有用户发送二进制消息
  ///
  /// [message] 长度不超过 46 KB。
  ///
  /// 注意：
  /// + 在发送房间内二进制消息前，必须先调用 [RTCRoom.joinRoom] 加入房间。
  /// + 调用本接口发送二进制信息后，会收到 [RTCRoomEventHandler.onRoomMessageSendResult]。
  /// + 若二进制消息发送成功，则房间内所有用户会收到 [RTCRoomEventHandler.onRoomBinaryMessageReceived]。
  Future<int?> sendRoomBinaryMessage(Uint8List message);

  /// 开始跨房间转发媒体流
  ///
  /// 在用户进入房间后调用本接口，实现向多个房间转发媒体流，适用于跨房间连麦等场景。
  ///
  /// [forwardStreamInfos] 跨房间媒体流转发指定房间的信息。
  ///
  /// 注意：
  /// + 调用本方法后，将在本端触发 [RTCRoomEventHandler.onForwardStreamStateChanged] 回调。
  /// + 调用本方法后，你可以通过监听 [RTCRoomEventHandler.onForwardStreamEvent] 回调来获取各个目标房间在转发媒体流过程中的相关事件。
  /// + 开始转发后，目标房间中的用户将接收到本地用户进房 [RTCRoomEventHandler.onUserJoined] 和发流 [RTCRoomEventHandler.onUserPublishStream]/[RTCRoomEventHandler.onUserPublishScreen] 的回调。
  /// + 调用本方法后，可以调用 [RTCRoom.updateForwardStreamToRooms] 更新目标房间信息，如增加或减少目标房间等。
  /// + 调用本方法后，可以调用 [RTCRoom.stopForwardStreamToRooms] 停止向所有房间转发媒体流。
  /// + 调用本方法后，可以调用 [RTCRoom.pauseForwardStreamToAllRooms] 暂停向所有房间转发媒体流。
  Future<int?> startForwardStreamToRooms(
      List<ForwardStreamInfo> forwardStreamInfos);

  /// 更新跨房间媒体流转发信息
  ///
  /// 通过 [RTCRoom.startForwardStreamToRooms] 发起媒体流转发后，可调用本方法增加或者减少目标房间，或更新房间密钥。 <br>
  /// 调用本方法增加或删减房间后，将在本端触发 [RTCRoomEventHandler.onForwardStreamStateChanged] 回调，包含发生了变动的目标房间中媒体流转发状态。
  ///
  /// [forwardStreamInfos] 跨房间媒体流转发目标房间信息。
  ///
  /// 注意：
  /// + 增加目标房间后，新增目标房间中的用户将接收到本地用户进房 [RTCRoomEventHandler.onUserJoined] 和发流 [RTCRoomEventHandler.onUserPublishStream]/[RTCRoomEventHandler.onUserPublishScreen] 的回调。
  /// + 删减目标房间后，原目标房间中的用户将接收到本地用户停止发布流 [RTCRoomEventHandler.onUserUnpublishStream]/[RTCRoomEventHandler.onUserUnpublishScreen] 和退房 [RTCRoomEventHandler.onUserLeave] 的回调。
  Future<int?> updateForwardStreamToRooms(
      List<ForwardStreamInfo> forwardStreamInfos);

  /// 停止跨房间媒体流转发
  ///
  /// 通过 [RTCRoom.startForwardStreamToRooms] 发起媒体流转发后，可调用本方法停止向所有目标房间转发媒体流。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 调用本方法后，将在本端触发 [RTCRoomEventHandler.onForwardStreamStateChanged] 回调。
  /// + 调用本方法后，原目标房间中的用户将接收到本地用户停止发布流 [RTCRoomEventHandler.onUserUnpublishStream]/[RTCRoomEventHandler.onUserUnpublishScreen] 和退房 [RTCRoomEventHandler.onUserLeave] 的回调。
  /// + 如果需要停止向指定的房间转发媒体流，请调用 [RTCRoom.updateForwardStreamToRooms] 更新房间信息。
  /// + 如果需要暂停转发，请调用 [RTCRoom.pauseForwardStreamToAllRooms]，并在之后随时调用 [RTCRoom.resumeForwardStreamToAllRooms] 快速恢复转发。
  Future<int?> stopForwardStreamToRooms();

  /// 暂停跨房间媒体流转发
  ///
  /// 通过 [RTCRoom.startForwardStreamToRooms] 发起媒体流转发后，可调用本方法暂停向所有目标房间转发媒体流。
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 调用本方法暂停向所有目标房间转发后，你可以随时调用 [RTCRoom.resumeForwardStreamToAllRooms] 快速恢复转发。
  /// + 调用本方法后，目标房间中的用户将接收到本地用户停止发布流 [RTCRoomEventHandler.onUserUnpublishStream]/[RTCRoomEventHandler.onUserUnpublishScreen] 和退房 [RTCRoomEventHandler.onUserLeave] 的回调。
  Future<int?> pauseForwardStreamToAllRooms();

  /// 恢复跨房间媒体流转发
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// + 调用 [RTCRoom.pauseForwardStreamToAllRooms] 暂停转发之后，调用本方法恢复向所有目标房间转发媒体流。
  /// + 目标房间中的用户将接收到本地用户进房 [RTCRoomEventHandler.onUserJoined] 和发流 [RTCRoomEventHandler.onUserPublishStream]/[RTCRoomEventHandler.onUserPublishScreen] 的回调。
  Future<int?> resumeForwardStreamToAllRooms();

  /// 获取范围语音接口实例
  ///
  /// 返回值：方法调用结果
  /// + RTCRangeAudio：成功，返回一个 [RTCRangeAudio] 范围语音接口实例；
  /// + null：失败，当前 SDK 不支持范围语音功能。
  ///
  /// 注意：首次调用该方法须在创建房间后、加入房间前。
  RTCRangeAudio get rangeAudio;

  /// 获取空间音频接口实例
  ///
  /// 空间音频相关 API 和调用时序详见[空间音频](https://www.volcengine.com/docs/6348/93903)。
  ///
  /// 返回值：方法调用结果
  /// + RTCSpatialAudio：成功，返回一个 [RTCSpatialAudio] 空间音频管理接口实例；
  /// + null：失败，当前 SDK 不支持空间音频功能。
  ///
  /// 注意：
  /// + 只有在使用支持真双声道播放的设备时，才能开启空间音频效果；
  /// + 在网络状况不佳的情况下，即使开启了这一功能，也不会产生空间音频效果；
  /// + 机型性能不足可能会导致音频卡顿，使用低端机时，不建议开启空间音频效果；
  /// + 空间音频效果在启用服务端选路功能时，不生效。
  RTCSpatialAudio get spatialAudio;

  /// 调节某个房间内所有远端用户的音频播放音量。
  ///
  /// [volume] 为音频播放音量值和原始音量的比值，范围是 `[0, 400]`，单位为 %，自带溢出保护。为保证更好的通话质量，建议将 volume 值设为 `[0,100]`。 <br>
  /// + 0: 静音
  /// + 100: 原始音量，默认值
  /// + 400: 最大可为原始音量的 4 倍(自带溢出保护)
  ///
  /// 返回值：
  /// + `0`：调用成功；
  /// + `<0`：调用失败，具体原因参看 [ReturnStatus]。
  ///
  /// 注意：假设某远端用户 A 始终在被调节的目标用户范围内，
  /// + 当该方法与 [RTCVideo.setRemoteAudioPlaybackVolume] 共同使用时，本地收听用户 A 的音量为后调用的方法设置的音量；
  /// + 当该方法与 [RTCVideo.setPlaybackVolume] 方法共同使用时，本地收听用户 A 的音量将为两次设置的音量效果的叠加。
  Future<int?> setRemoteRoomAudioPlaybackVolume(int volume);

  /// v3.54.1 新增。
  ///
  /// 设置本端发布流在音频选路中的优先级。
  ///
  /// [audioSelectionPriority]：本端发布流在音频选路中的优先级，默认正常参与音频选路。
  ///
  /// 注意：
  /// + 在控制台上为本 appId 开启音频选路后，调用本接口才会生效。进房前后调用均可生效。更多信息参见[音频选路](https://www.volcengine.com/docs/6348/113547)。
  /// + 如果本端用户同时加入不同房间，使用本接口进行的设置相互独立。
  Future<int?> setAudioSelectionConfig(
      AudioSelectionPriority audioSelectionPriority);

  /// v3.54.1 新增。
  ///
  /// 设置/更新房间附加信息，可用于标识房间状态或属性，或灵活实现各种业务逻辑。
  ///
  /// [key]：房间附加信息键值，长度小于 10 字节。<br>
  /// 同一房间内最多可存在 5 个 key，超出则会从第一个 key 起进行替换。
  ///
  /// [value]：房间附加信息内容，长度小于 128 字节。
  ///
  /// 返回值：
  /// + `0`: 方法调用成功，返回本次调用的任务编号；
  /// + `<0`: 方法调用失败，具体原因详见 [SetRoomExtraInfoResult]。
  ///
  /// 注意：
  /// + 在设置房间附加信息前，必须先调用 [RTCRoom.joinRoom] 加入房间。
  /// + 调用该方法后，会收到一次 [RTCRoomEventHandler.onSetRoomExtraInfoResult] 回调，提示设置结果。
  /// + 调用该方法成功设置附加信息后，同一房间内的其他用户会收到关于该信息的回调 [RTCRoomEventHandler.onRoomExtraInfoUpdate]。
  /// + 新进房的用户会收到进房前房间内已有的全部附加信息通知。
  Future<int?> setRoomExtraInfo({
    required String key,
    required String value,
  });

  /// v3.54.1 新增。
  ///
  /// 识别或翻译房间内所有用户的语音，形成字幕。<br>
  /// 语音识别或翻译的结果会通过 [RTCRoomEventHandler.onSubtitleMessageReceived] 事件回调给你。<br>
  /// 调用该方法后，你会收到 [RTCRoomEventHandler.onSubtitleStateChanged] 回调，通知字幕是否开启。
  ///
  /// [subtitleConfig]：字幕配置信息。
  ///
  /// 返回值：
  /// + 0：调用成功。
  /// + !0：调用失败。失败原因参看 [ReturnStatus]。
  ///
  /// 注意：
  /// + 使用字幕功能前，你需要[开通机器翻译服务](https://www.volcengine.com/docs/4640/130262)并前往 [RTC 控制台](https://console.volcengine.com/rtc/cloudRTC?tab=subtitle)，在功能配置页面开启字幕功能。
  /// + 此方法需要在进房后调用。
  /// + 如需指定源语言，你需要在调用 `joinRoom` 接口进房时，通过 extraInfo 参数传入 `"source_language": "zh"` JSON 字符串，设置源语言为中文；传入 `"source_language": "en"`JSON 字符串，设置源语言为英文；传入 `"source_language": "ja"` JSON 字符串，设置源语言为日文。如未指定源语言，SDK 会将系统语种设定为源语言。如果你的系统语种不是中文、英文和日文，此时 SDK 会自动将中文设为源语言。
  /// + 调用 [RTCRoom.stopSubtitle] 可以关闭字幕。
  Future<int?> startSubtitle(SubtitleConfig subtitleConfig);

  /// v3.54.1 新增。
  ///
  /// 关闭字幕。 <br>
  /// 调用该方法后，你会收到 [RTCRoomEventHandler.onSubtitleStateChanged] 回调，通知字幕是否关闭。
  ///
  /// 返回值：
  /// + 0: 调用成功。
  /// + !0: 调用失败。
  Future<int?> stopSubtitle();
}
