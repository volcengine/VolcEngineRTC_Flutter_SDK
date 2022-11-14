// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'bytertc_common_defines.dart';
import 'bytertc_range_audio_api.dart';
import 'bytertc_room_event_handler.dart';
import 'dart:typed_data';

import 'bytertc_spatial_audio_api.dart';
import 'bytertc_video_defines.dart';

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
  /// 测试时可使用控制台生成临时 token，正式上线需要使用密钥 SDK 在你的服务端生成并下发 token。  <br>
  /// 使用不同 AppID 的 App 是不能互通的，请务必保证生成 token 使用的 AppID 和创建引擎时使用的 AppID 相同，否则会导致加入房间失败。
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
  /// + 本地用户调用此方法加入房间成功后，会收到 [RTCRoomEventHandler.onRoomStateChanged] 回调通知。
  /// + 本地用户调用 [RTCRoom.setUserVisibility] 将自身设为可见后加入房间，远端用户会收到 [RTCRoomEventHandler.onUserJoined] 回调通知。
  /// + 用户加入房间成功后，在本地网络状况不佳的情况下，SDK 可能会与服务器失去连接，此时 SDK 将会自动重连。重连成功后，本地会收到 [RTCRoomEventHandler.onRoomStateChanged] 回调通知；若加入房间的是可见用户，则远端用户会收到 [RTCRoomEventHandler.onUserJoined] 回调通知。
  Future<int?> joinRoom({
    required String token,
    required UserInfo userInfo,
    required RoomConfig roomConfig,
  });

  /// 设置用户可见性，默认为可见
  ///
  /// 通过 [enable] 设置用户可见性和用户在房间内的行为：
  /// + true: 可以被房间中的其他用户感知，且可以在房间内发布和订阅音视频流；
  /// + false: 无法被房间中的其他用户感知，且只能在房间内订阅音视频流。
  ///
  /// 注意：
  /// + 该方法在加入房间前后均可调用。
  /// + 在房间内调用此方法，房间内其他用户会收到相应的回调通知：
  ///   - 从 false 切换至 true 时，房间内其他用户会收到 [RTCRoomEventHandler.onUserJoined]
  ///   - 从 true 切换至 false 时，房间内其他用户会收到 [RTCRoomEventHandler.onUserLeave]
  /// + 若调用该方法将可见性设为 false，此时尝试发布流会收到 [RTCEngineEventHandler.onWarning]
  Future<void> setUserVisibility(bool enable);

  /// 设置发流端音画同步
  ///
  /// 当同一用户同时使用两个通话设备分别采集发送音频和视频时，有可能会因两个设备所处的网络环境不一致而导致发布的流不同步，此时你可以在视频发送端调用该接口，SDK 会根据音频流的时间戳自动校准视频流，以保证接收端听到音频和看到视频在时间上的同步性。
  ///
  /// [audioUserId] 传入音频发送端的用户 ID，将该参数设为空则可解除当前音视频的同步关系。
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
  /// 注意：
  /// + 可见用户离开房间后，房间内其他用户会收到 [RTCRoomEventHandler.onUserLeave] 回调通知。
  /// + 如果调用此方法后立即销毁引擎，SDK 将无法触发 [RTCRoomEventHandler.onLeaveRoom] 回调。
  Future<void> leaveRoom();

  /// 更新 Token
  ///
  /// 用于加入房间的 Token 有一定的有效期。在 Token 过期前 30 秒，会收到 [RTCRoomEventHandler.onTokenWillExpire] 回调，此时需要重新获取 Token，并调用此方法更新 Token，否则用户将因为 Token 过期被移出房间。 <br>
  /// 调用 [RTCRoom.joinRoom] 方法加入房间或断网重连进入房间时，如果 Token 过期或无效，将导致加入房间失败，并会收到 [RTCRoomEventHandler.onRoomStateChanged] 回调通知。此时需要重新获取 Token，并调用此方法更新 Token。
  ///
  /// [token] 更新的动态密钥。Token 用于对登录用户进行鉴权验证。
  Future<void> updateToken(String token);

  /// 设置期望订阅的远端视频流的参数
  ///
  /// [uid] 传入期望订阅的远端视频流发布用户的 ID。
  ///
  /// [remoteVideoConfig] 传入期望订阅的远端视频流参数。
  ///
  /// 注意：
  /// + 该方法仅在发布端调用 [RTCVideo.enableSimulcastMode] 开启了发送多路视频流的情况下生效，此时订阅端将收到来自发布端与期望设置的参数最相近的一路流；否则订阅端只会收到一路参数为分辨率 640px × 360px、帧率 15fps 的视频流。
  /// + 若发布端开启了推送多路流功能，但订阅端不对流参数进行设置，则默认接受发送端设置的分辨率最大的一路视频流。
  /// + 该方法需在进房后调用，若想进房前设置，你需调用 [RTCRoom.joinRoom]，并对 `roomConfig` 中的 `remoteVideoConfig` 进行设置。
  /// + SDK 会根据发布端和所有订阅端的设置灵活调整视频流的参数，具体调整策略详见[推送多路流](https://www.volcengine.com/docs/6348/70139)文档。
  Future<void> setRemoteVideoConfig({
    required String uid,
    required RemoteVideoConfig videoConfig,
  });

  /// 在当前所在房间内发布本地通过摄像头/麦克风采集的媒体流
  ///
  /// [type] 媒体流类型，用于指定发布音频/视频
  ///
  /// 注意：
  /// + 如果你已经在用户进房时通过调用 [RTCRoom.joinRoom] 成功选择了自动发布，则无需再调用本接口。
  /// + 调用 [RTCRoom.setUserVisibility] 方法将自身设置为不可见后无法调用该方法，需将自身切换至可见后方可调用该方法发布摄像头音视频流。
  /// + 如果你需要发布屏幕共享流，调用 [RTCRoom.publishScreen]。
  /// + 如果你需要向多个房间发布流，调用 [RTCRoom.startForwardStreamToRooms]。
  /// + 调用此方法后，房间中的所有远端用户会收到 [RTCRoomEventHandler.onUserPublishStream] 回调通知，其中成功收到了音频流的远端用户会收到 [RTCVideoEventHandler.onFirstRemoteAudioFrame] 回调，订阅了视频流的远端用户会收到 [RTCVideoEventHandler.onFirstRemoteVideoFrameDecoded] 回调。
  /// + 调用 [RTCRoom.unpublishStream] 取消发布。
  Future<void> publishStream(MediaStreamType type);

  /// 停止将本地摄像头/麦克风采集的媒体流发布到当前所在房间中
  ///
  /// [type] 媒体流类型，用于取消指定发布音频/视频
  ///
  /// 注意：
  /// + 调用 [RTCRoom.publishStream] 手动发布摄像头音视频流后，你需调用此接口停止发布。
  /// + 调用此方法停止发布音视频流后，房间中的其他用户将会收到 [RTCRoomEventHandler.onUserUnpublishStream] 回调通知。
  Future<void> unpublishStream(MediaStreamType type);

  /// 在当前所在房间内发布本地屏幕共享音视频流
  ///
  /// [type] 媒体流类型，用于指定发布音频/视频
  ///
  /// 注意：
  /// + 如果你已经在用户进房时通过调用 [RTCRoom.joinRoom] 成功选择了自动发布，则无需再调用本接口。
  /// + 调用 [RTCRoom.setUserVisibility] 方法将自身设置为不可见后无法调用该方法，需将自身切换至可见后方可调用该方法发布屏幕流。
  /// + 调用该方法后，房间中的所有远端用户会收到 [RTCRoomEventHandler.onUserPublishScreen] 回调，其中成功收到音频流的远端用户会收到 [RTCVideoEventHandler.onFirstRemoteAudioFrame] 回调，订阅了视频流的远端用户会收到 [RTCVideoEventHandler.onFirstRemoteVideoFrameDecoded] 回调。
  /// + 如果你需要向多个房间发布流，调用 [RTCRoom.startForwardStreamToRooms]。
  /// + 调用 [RTCRoom.unpublishScreen] 取消发布。
  Future<void> publishScreen(MediaStreamType type);

  /// 停止将本地屏幕共享音视频流发布到当前所在房间中
  ///
  /// [type] 媒体流类型，用于指定取消发布音频/视频。
  ///
  /// 注意：
  /// + 调用 [RTCRoom.publishScreen] 发布屏幕流后，你需调用此接口停止发布。
  /// + 调用此方法停止发布屏幕音视频流后，房间中的其他用户将会收到 [RTCRoomEventHandler.onUserUnpublishScreen] 回调。
  Future<void> unpublishScreen(MediaStreamType type);

  /// 订阅房间内指定的通过摄像头/麦克风采集的媒体流，或更新对指定远端用户的订阅选项
  ///
  /// [uid] 传入指定订阅的远端发布音视频流的用户 ID。
  ///
  /// [type] 传入媒体流类型，用于指定订阅音频/视频。
  ///
  /// 注意：
  /// + 该方法可以用于首次订阅某远端用户，也可用于更新已订阅远端用户的媒体流类型。
  /// + 你必须先通过 [RTCRoomEventHandler.onUserPublishStream] 回调获取当前房间里的远端摄像头音视频流信息，然后调用本方法按需订阅。
  /// + 成功订阅远端用户的媒体流后，订阅关系将持续到调用 [RTCRoom.unsubscribeStream] 取消订阅或本端用户退房。
  /// + 关于其他调用异常，你会收到 [RTCRoomEventHandler.onStreamStateChanged] 回调通知，具体异常原因参看 [ErrorCode]。
  Future<void> subscribeStream({
    required String uid,
    required MediaStreamType type,
  });

  /// 取消订阅房间内指定的通过摄像头/麦克风采集的媒体流
  ///
  /// 该方法对自动订阅和手动订阅模式均适用。
  ///
  /// [uid] 指定取消订阅的远端发布音视频流的用户 ID。
  ///
  /// [type] 传入媒体流类型，用于指定取消订阅音频/视频。
  ///
  /// + 关于其他调用异常，你会收到 [RTCRoomEventHandler.onStreamStateChanged] 回调通知，具体失败原因参看 [ErrorCode]。
  Future<void> unsubscribeStream({
    required String uid,
    required MediaStreamType type,
  });

  /// 订阅房间内指定的远端屏幕共享音视频流，或更新对指定远端用户的订阅选项
  ///
  /// [uid] 指定订阅的远端发布屏幕流的用户 ID。
  ///
  /// [type] 传入媒体流类型，用于指定订阅音频/视频。
  ///
  /// 注意：
  /// + 该方法可以用于首次订阅某远端用户的屏幕流，也可用于更新已订阅远端用户的屏幕媒体流类型。
  /// + 你必须先通过 [RTCRoomEventHandler.onUserPublishScreen] 回调获取当前房间里的远端屏幕流信息，然后调用本方法按需订阅。
  /// + 成功订阅远端用户的媒体流后，订阅关系将持续到调用 [RTCRoom.unsubscribeScreen] 取消订阅或本端用户退房。
  /// + 关于其他调用异常，你会收到 [RTCRoomEventHandler.onStreamStateChanged] 回调通知，具体异常原因参看 [ErrorCode]。
  Future<void> subscribeScreen({
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
  /// 注意：
  /// + 关于其他调用异常，你会收到 [RTCRoomEventHandler.onStreamStateChanged] 回调通知，具体失败原因参看 [ErrorCode]。
  Future<void> unsubscribeScreen({
    required String uid,
    required MediaStreamType type,
  });

  /// 暂停接收所有来自远端的媒体流。
  ///
  /// + 该方法仅暂停远端流的接收，并不影响远端流的采集和发送。
  /// + 该方法不改变用户的订阅状态以及订阅流的属性。
  /// + 若想恢复接收远端流，需调用 [RTCRoom.resumeAllSubscribedStream]。
  /// + 多房间场景下，仅暂停接收发布在当前所在房间的流。
  Future<void> pauseAllSubscribedStream(PauseResumeControlMediaType mediaType);

  /// 恢复接收来自远端的媒体流
  ///
  /// + 该方法仅恢复远端流的接收，并不影响远端流的采集和发送。
  /// + 该方法不改变用户的订阅状态以及订阅流的属性。
  Future<void> resumeAllSubscribedStream(PauseResumeControlMediaType mediaType);

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
  /// 注意：
  /// + 调用本方法后，将在本端触发 [RTCRoomEventHandler.onForwardStreamStateChanged] 回调。
  /// + 调用本方法后，原目标房间中的用户将接收到本地用户停止发布流 [RTCRoomEventHandler.onUserUnpublishStream]/[RTCRoomEventHandler.onUserUnpublishScreen] 和退房 [RTCRoomEventHandler.onUserLeave] 的回调。
  /// + 如果需要停止向指定的房间转发媒体流，请调用 [RTCRoom.updateForwardStreamToRooms] 更新房间信息。
  /// + 如果需要暂停转发，请调用 [RTCRoom.pauseForwardStreamToAllRooms]，并在之后随时调用 [RTCRoom.resumeForwardStreamToAllRooms] 快速恢复转发。
  Future<void> stopForwardStreamToRooms();

  /// 暂停跨房间媒体流转发
  ///
  /// 通过 [RTCRoom.startForwardStreamToRooms] 发起媒体流转发后，可调用本方法暂停向所有目标房间转发媒体流。
  ///
  /// 注意：
  /// + 调用本方法暂停向所有目标房间转发后，你可以随时调用 [RTCRoom.resumeForwardStreamToAllRooms] 快速恢复转发。
  /// + 调用本方法后，目标房间中的用户将接收到本地用户停止发布流 [RTCRoomEventHandler.onUserUnpublishStream]/[RTCRoomEventHandler.onUserUnpublishScreen] 和退房 [RTCRoomEventHandler.onUserLeave] 的回调。
  Future<void> pauseForwardStreamToAllRooms();

  /// 恢复跨房间媒体流转发
  ///
  /// + 调用 [RTCRoom.pauseForwardStreamToAllRooms] 暂停转发之后，调用本方法恢复向所有目标房间转发媒体流。
  /// + 目标房间中的用户将接收到本地用户进房 [RTCRoomEventHandler.onUserJoined] 和发流 [RTCRoomEventHandler.onUserPublishStream]/[RTCRoomEventHandler.onUserPublishScreen] 的回调。
  Future<void> resumeForwardStreamToAllRooms();

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
}
