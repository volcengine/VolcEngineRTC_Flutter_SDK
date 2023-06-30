// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import '../api/bytertc_event_define.dart';
import '../api/bytertc_room_event_handler.dart';
import 'base/bytertc_event_serialize.dart';

class RTCRoomEventValue {
  void Function(Map<String, dynamic>)? _valueObserver;

  set valueObserver(void Function(Map<String, dynamic>)? valueObserver) {
    _valueObserver = valueObserver;
    if (valueObserver == null) return;
    _valueObserver?.call({
      'enableRoomStats': _onRoomStats != null,
      'enableLocalStreamStats': _onLocalStreamStats != null,
      'enableRemoteStreamStats': _onRemoteStreamStats != null,
      'enableNetworkQualityStats': _onNetworkQuality != null
    });
  }

  OnRoomStatsType? _onRoomStats;

  OnRoomStatsType? get onRoomStats => _onRoomStats;

  set onRoomStats(OnRoomStatsType? onRoomStats) {
    _onRoomStats = onRoomStats;
    _valueObserver?.call({'enableRoomStats': onRoomStats != null});
  }

  OnLocalStreamStatsType? _onLocalStreamStats;

  OnLocalStreamStatsType? get onLocalStreamStats => _onLocalStreamStats;

  set onLocalStreamStats(OnLocalStreamStatsType? onLocalStreamStats) {
    _onLocalStreamStats = onLocalStreamStats;
    _valueObserver
        ?.call({'enableLocalStreamStats': onLocalStreamStats != null});
  }

  OnRemoteStreamStatsType? _onRemoteStreamStats;

  OnRemoteStreamStatsType? get onRemoteStreamStats => _onRemoteStreamStats;

  set onRemoteStreamStats(OnRemoteStreamStatsType? onRemoteStreamStats) {
    _onRemoteStreamStats = onRemoteStreamStats;
    _valueObserver
        ?.call({'enableRemoteStreamStats': onRemoteStreamStats != null});
  }

  OnNetworkQualityType? _onNetworkQuality;

  OnNetworkQualityType? get onNetworkQuality => _onNetworkQuality;

  set onNetworkQuality(OnNetworkQualityType? onNetworkQuality) {
    _onNetworkQuality = onNetworkQuality;
    _valueObserver
        ?.call({'enableNetworkQualityStats': onNetworkQuality != null});
  }
}

extension RTCRoomEventProcessor on RTCRoomEventHandler {
  void process(String methodName, Map<dynamic, dynamic> dic) {
    switch (methodName) {
      case 'onRoomStateChanged':
        final data = OnRoomStateChangedData.fromMap(dic);
        onRoomStateChanged?.call(
            data.roomId, data.uid, data.state, data.extraInfo);
        break;
      case 'onStreamStateChanged':
        final data = OnRoomStateChangedData.fromMap(dic);
        onStreamStateChanged?.call(
            data.roomId, data.uid, data.state, data.extraInfo);
        break;
      case 'onLeaveRoom':
        final data = OnLeaveRoomData.fromMap(dic);
        onLeaveRoom?.call(data.rtcRoomStats);
        break;
      case 'onAVSyncStateChange':
        final data = OnAVSyncStateChangeData.fromMap(dic);
        onAVSyncStateChange?.call(data.state);
        break;
      case 'onRoomStats':
        final data = OnRoomStatsData.fromMap(dic);
        onRoomStats?.call(data.stats);
        break;
      case 'onLocalStreamStats':
        final data = OnLocalStreamStatsData.fromMap(dic);
        onLocalStreamStats?.call(data.stats);
        break;
      case 'onRemoteStreamStats':
        final data = OnRemoteStreamStatsData.fromMap(dic);
        onRemoteStreamStats?.call(data.stats);
        break;
      case 'onUserJoined':
        final data = OnUserJoinedData.fromMap(dic);
        onUserJoined?.call(data.userInfo, data.elapsed);
        break;
      case 'onUserLeave':
        final data = OnUserLeaveData.fromMap(dic);
        onUserLeave?.call(data.uid, data.reason);
        break;
      case 'onTokenWillExpire':
        onTokenWillExpire?.call();
        break;
      case 'onPublishPrivilegeTokenWillExpire':
        onPublishPrivilegeTokenWillExpire?.call();
        break;
      case 'onSubscribePrivilegeTokenWillExpire':
        onSubscribePrivilegeTokenWillExpire?.call();
        break;
      case 'onUserPublishStream':
        final data = OnUserPublishStreamData.fromMap(dic);
        onUserPublishStream?.call(data.uid, data.type);
        break;
      case 'onUserUnpublishStream':
        final data = OnUserUnpublishStreamData.fromMap(dic);
        onUserUnpublishStream?.call(data.uid, data.type, data.reason);
        break;
      case 'onUserPublishScreen':
        final data = OnUserPublishStreamData.fromMap(dic);
        onUserPublishScreen?.call(data.uid, data.type);
        break;
      case 'onUserUnpublishScreen':
        final data = OnUserUnpublishStreamData.fromMap(dic);
        onUserUnpublishScreen?.call(data.uid, data.type, data.reason);
        break;
      case 'onStreamSubscribed':
        final data = OnStreamSubscribedData.fromMap(dic);
        onStreamSubscribed?.call(data.stateCode, data.uid, data.info);
        break;
      case 'onRoomMessageReceived':
        final data = OnMessageReceivedData.fromMap(dic);
        onRoomMessageReceived?.call(data.uid, data.message);
        break;
      case 'onRoomBinaryMessageReceived':
        final data = OnBinaryMessageReceivedData.fromMap(dic);
        onRoomBinaryMessageReceived?.call(data.uid, data.message);
        break;
      case 'onUserMessageReceived':
        final data = OnMessageReceivedData.fromMap(dic);
        onUserMessageReceived?.call(data.uid, data.message);
        break;
      case 'onUserBinaryMessageReceived':
        final data = OnBinaryMessageReceivedData.fromMap(dic);
        onUserBinaryMessageReceived?.call(data.uid, data.message);
        break;
      case 'onUserMessageSendResult':
        final data = OnMessageSendResultData.fromMap(dic);
        onUserMessageSendResult?.call(data.msgid, data.error);
        break;
      case 'onRoomMessageSendResult':
        final data = OnRoomMessageSendResultData.fromMap(dic);
        onRoomMessageSendResult?.call(data.msgid, data.error);
        break;
      case 'onVideoStreamBanned':
        final data = OnVideoStreamBannedData.fromMap(dic);
        onVideoStreamBanned?.call(data.uid, data.banned);
        break;
      case 'onAudioStreamBanned':
        final data = OnAudioStreamBannedData.fromMap(dic);
        onAudioStreamBanned?.call(data.uid, data.banned);
        break;
      case 'onForwardStreamStateChanged':
        final data = OnForwardStreamStateChangedData.fromMap(dic);
        onForwardStreamStateChanged?.call(data.stateInfos);
        break;
      case 'onForwardStreamEvent':
        final data = OnForwardStreamEventData.fromMap(dic);
        onForwardStreamEvent?.call(data.eventInfos);
        break;
      case 'onNetworkQuality':
        final data = OnNetworkQualityData.fromMap(dic);
        onNetworkQuality?.call(data.localQuality, data.remoteQualities);
        break;
      default:
        break;
    }
  }
}
