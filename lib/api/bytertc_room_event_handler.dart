// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import '../src/bytertc_room_event_impl.dart';
import 'bytertc_event_define.dart';
import 'bytertc_room_api.dart';
import 'bytertc_video_api.dart';

/// 房间事件回调
class RTCRoomEventHandler extends RTCRoomEventValue {
  /// 房间状态改变回调
  ///
  /// 加入房间、离开房间、发生房间相关的警告或错误时会收到此回调。
  OnRoomStateChangedType? onRoomStateChanged;

  /// 流状态改变回调，发生流相关的警告或错误时会收到此回调。
  OnRoomStateChangedType? onStreamStateChanged;

  /// 离开房间回调。
  ///
  /// 用户调用 [RTCRoom.leaveRoom] 方法后，SDK 会停止所有的发布订阅流，并在释放所有与通话相关的音视频资源后，通过此回调通知用户离开房间成功。
  ///
  /// 注意：
  /// + 离开房间后，如果 App 需要使用系统音视频设备，则建议收到此回调后再初始化音视频设备，否则可能由于 SDK 占用音视频设备而导致初始化失败。
  /// + 用户调用 [RTCRoom.leaveRoom] 方法离开房间后，若立即调用 [RTCVideo.destroy] 方法销毁 RTC 引擎，则将无法收到此回调事件。
  OnLeaveRoomType? onLeaveRoom;

  /// 发布端调用 [RTCRoom.setMultiDeviceAVSync] 后音视频同步状态发生改变时，会收到此回调。
  OnAVSyncStateChangeType? onAVSyncStateChange;

  /// 房间内通话统计信息回调。
  ///
  /// 用户进房开始通话后，每 2s 收到一次本回调。
  @override
  abstract OnRoomStatsType? onRoomStats;

  /// 反映通话中本地设备发送音/视频流的统计信息以及网络状况的回调，每 2s 触发一次。
  @override
  abstract OnLocalStreamStatsType? onLocalStreamStats;

  /// 通话中本地设备接收订阅的远端音/视频流的统计信息以及网络状况，每 2s 触发一次。
  @override
  abstract OnRemoteStreamStatsType? onRemoteStreamStats;

  /// 远端可见用户加入房间，或房内隐身用户切换为可见时，房间内的其他用户会收到此回调。
  ///
  /// 以下场景下会收到此回调：
  /// 1. 远端可见用户调用 [RTCRoom.joinRoom] 方法加入房间时，房间内其他用户将收到该事件。
  /// 2. 远端可见用户断网后重新连入房间时，房间内其他用户将收到该事件。
  /// 3. 远端隐身用户调用 [RTCRoom.setUserVisibility] 方法将自身切换至可见时，房间内其他用户将收到该事件。
  /// 4. 新进房用户会收到进房前已在房内的可见用户的进房回调通知。
  OnUserJoinedType? onUserJoined;

  /// 远端可见用户离开房间，或切换至隐身时，房间内的其他用户会收到此回调。
  ///
  /// 发生以下情形时，房间内其他用户会收到此事件：
  /// 1.远端可见用户调用 [RTCRoom.leaveRoom] 方法离开房间时。
  /// 2.远端可见用户调用 [RTCRoom.setUserVisibility] 方法将角色切换至隐身。
  /// 3.远端可见用户断网，且一直未恢复。
  OnUserLeaveType? onUserLeave;

  /// Token 过期前 30 秒将触发该回调
  ///
  /// 收到该回调时需调用 [RTCRoom.updateToken] 更新 Token，否则 Token 过期后，用户将被移出房间无法继续进行音视频通话。
  EmptyCallbackType? onTokenWillExpire;

  /// Token 发布权限过期前 30 秒将触发该回调<br>
  /// 收到该回调时需调用 [RTCRoom.updateToken] 更新 Token 发布权限。
  ///
  /// 注意：若收到该回调后未及时更新 Token，Token 发布权限过期后：
  /// + 此时尝试发布流会收到 [onStreamStateChanged] 回调，提示错误码为 `noPublishPermission` 没有发布权限；
  /// + 已在发布中的流会停止发布，发布端会收到 [onStreamStateChanged] 回调，提示错误码为 `noPublishPermission` 没有发布权限，同时远端用户会收到 [onUserUnpublishStream]/[onUserUnpublishScreen] 回调，提示原因为 `publishPrivilegeExpired` 发流端发布权限过期。
  EmptyCallbackType? onPublishPrivilegeTokenWillExpire;

  /// Token 订阅权限过期前 30 秒将触发该回调。
  ///
  /// 收到该回调时需调用 [RTCRoom.updateToken] 更新 Token 订阅权限有效期，若收到该回调后未及时更新 Token，Token 订阅权限过期后，尝试新订阅流会失败，已订阅的流会取消订阅，并且会收到 [onStreamStateChanged] 回调，提示错误码为 `-1003` 没有订阅权限。
  EmptyCallbackType? onSubscribePrivilegeTokenWillExpire;

  /// 房间内新增远端摄像头/麦克风采集音视频流的回调。
  ///
  /// 当房间内的远端用户调用 [RTCRoom.publishStream] 成功发布由摄像头/麦克风采集的媒体流时，本地用户会收到该回调，此时本地用户可以自行选择是否调用 [RTCRoom.subscribeStream] 订阅此流。
  OnUserPublishStreamType? onUserPublishStream;

  /// 房间内远端摄像头/麦克风采集的媒体流移除的回调。
  ///
  /// 收到该回调通知后，你可以自行选择是否调用 [RTCRoom.unsubscribeStream] 取消订阅此流。
  OnUserUnpublishStreamType? onUserUnpublishStream;

  /// 房间内新增远端屏幕共享音视频流的回调。
  ///
  /// 当房间内的远端用户调用 [RTCRoom.publishScreen] 成功发布来自屏幕共享的音视频流时，本地用户会收到该回调，此时本地用户可以自行选择是否调用 [RTCRoom.subscribeScreen] 订阅此流。
  OnUserPublishStreamType? onUserPublishScreen;

  /// 房间内远端屏幕共享音视频流移除的回调。
  ///
  /// 收到该回调通知后，你可以自行选择是否调用 [RTCRoom.unsubscribeScreen] 取消订阅此流。
  OnUserUnpublishStreamType? onUserUnpublishScreen;

  /// @nodoc('Useless')
  OnStreamSubscribedType? onStreamSubscribed;

  /// 收到来自房间内广播的文本消息时，收到此回调。
  OnMessageReceivedType? onRoomMessageReceived;

  /// 收到来自房间内广播的二进制消息时，收到此回调。
  OnBinaryMessageReceivedType? onRoomBinaryMessageReceived;

  /// 收到来自房间中其他用户发来的文本消息时，收到此回调。
  OnMessageReceivedType? onUserMessageReceived;

  /// 收到来自房间中其他用户发来的二进制消息时，收到此回调。
  OnBinaryMessageReceivedType? onUserBinaryMessageReceived;

  /// 向房间内单个用户发送文本或二进制消息后，收到此回调。
  OnMessageSendResultType? onUserMessageSendResult;

  /// 向房间内所有用户发送文本或二进制消息后，收到此回调。
  OnRoomMessageSendResultType? onRoomMessageSendResult;

  /// v3.54.1 新增
  ///
  /// 调用 [RTCRoom.setRoomExtraInfo] 设置房间附加信息结果的回调。
  OnSetRoomExtraInfoResultType? onSetRoomExtraInfoResult;

  /// v3.54.1 新增
  ///
  /// 接收同一房间内，其他用户调用 [RTCRoom.setRoomExtraInfo] 设置的房间附加信息的回调。
  ///
  /// 新进房的用户会收到进房前房间内已有的全部附加信息通知。
  OnRoomExtraInfoUpdateType? onRoomExtraInfoUpdate;

  /// v3.54.1 新增
  ///
  /// 用户调用 [RTCRoom.setUserVisibility] 设置用户可见性的回调。
  OnUserVisibilityChangedType? onUserVisibilityChanged;

  /// 通过调用服务端 BanUserStream/UnbanUserStream 方法禁用/解禁指定房间内指定用户视频流的发送时，触发此回调。
  ///
  /// + 房间内指定用户被禁止/解禁视频流发送时，房间内所有用户都会收到该回调。
  /// + 若被封禁用户退房后再进房，则依然是封禁状态，且房间内所有人会再次收到该回调。
  /// + 若被封禁用户断网后重连进房，则依然是封禁状态，且只有本人会再次收到该回调。
  /// + 指定用户被封禁后，房间内其他用户退房后再进房，会再次收到该回调。
  /// + 在控制台开启大会模式后，只有被封禁/解禁用户会收到该回调。
  /// + 同一房间解散后再次创建，房间内状态清空。
  OnVideoStreamBannedType? onVideoStreamBanned;

  /// 通过调用服务端 BanUserStream/UnbanUserStream 方法禁用/解禁指定房间内指定用户音频流的发送时，触发此回调。
  ///
  /// + 房间内指定用户被禁止/解禁音频流发送时，房间内所有用户都会收到该回调。
  /// + 若被封禁用户退房后再进房，则依然是封禁状态，且房间内所有人会再次收到该回调。
  /// + 若被封禁用户断网后重连进房，则依然是封禁状态，且只有本人会再次收到该回调。
  /// + 指定用户被封禁后，房间内其他用户退房后再进房，会再次收到该回调。
  /// + 在控制台开启大会模式后，只有被封禁/解禁用户会收到该回调。
  /// + 同一房间解散后再次创建，房间内状态清空。
  OnAudioStreamBannedType? onAudioStreamBanned;

  /// 跨房间媒体流转发状态和错误回调
  OnForwardStreamStateChangedType? onForwardStreamStateChanged;

  /// 跨房间媒体流转发事件回调
  OnForwardStreamEventType? onForwardStreamEvent;

  /// 加入房间后， 以 2 秒 1 次的频率，报告用户的网络质量信息
  ///
  /// 更多通话中的监测接口，详见[通话中质量监测](https://www.volcengine.com/docs/6348/106866)
  @override
  abstract OnNetworkQualityType? onNetworkQuality;

  /// v3.54.1 新增
  ///
  /// 字幕状态发生改变回调。 <br>
  /// 调用 [RTCRoom.startSubtitle] 或 [RTCRoom.stopSubtitle] 使字幕状态发生改变或出现错误时，触发该回调。
  OnSubtitleStateChangedType? onSubtitleStateChanged;

  /// v3.54.1 新增
  ///
  /// 字幕相关内容回调。 <br>
  /// 成功调用 [RTCRoom.startSubtitle] 后，会通过此回调收到字幕内容及相关信息。
  OnSubtitleMessageReceivedType? onSubtitleMessageReceived;

  /// @nodoc
  RTCRoomEventHandler({
    this.onRoomStateChanged,
    this.onStreamStateChanged,
    this.onLeaveRoom,
    this.onAVSyncStateChange,
    OnRoomStatsType? onRoomStats,
    OnLocalStreamStatsType? onLocalStreamStats,
    OnRemoteStreamStatsType? onRemoteStreamStats,
    this.onUserJoined,
    this.onUserLeave,
    this.onTokenWillExpire,
    this.onPublishPrivilegeTokenWillExpire,
    this.onSubscribePrivilegeTokenWillExpire,
    this.onUserPublishStream,
    this.onUserUnpublishStream,
    this.onUserPublishScreen,
    this.onUserUnpublishScreen,
    this.onStreamSubscribed,
    this.onRoomMessageReceived,
    this.onRoomBinaryMessageReceived,
    this.onUserMessageReceived,
    this.onUserBinaryMessageReceived,
    this.onUserMessageSendResult,
    this.onRoomMessageSendResult,
    this.onSetRoomExtraInfoResult,
    this.onRoomExtraInfoUpdate,
    this.onUserVisibilityChanged,
    this.onVideoStreamBanned,
    this.onAudioStreamBanned,
    this.onForwardStreamStateChanged,
    this.onForwardStreamEvent,
    OnNetworkQualityType? onNetworkQuality,
    this.onSubtitleStateChanged,
    this.onSubtitleMessageReceived,
  }) : super(
          onRoomStats: onRoomStats,
          onLocalStreamStats: onLocalStreamStats,
          onRemoteStreamStats: onRemoteStreamStats,
          onNetworkQuality: onNetworkQuality,
        );
}
