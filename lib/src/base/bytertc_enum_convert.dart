// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

// ignore_for_file: public_member_api_docs
import 'package:flutter/foundation.dart';

import '../../api/bytertc_audio_defines.dart';
import '../../api/bytertc_ktv_defines.dart';
import '../../api/bytertc_media_defines.dart';
import '../../api/bytertc_rts_defines.dart';
import '../../api/bytertc_video_defines.dart';

/// enum to int
extension ScreenVideoEncoderPreferenceValue on ScreenVideoEncoderPreference {
  int get value {
    return index + 1;
  }
}

extension RemoteUserPriorityValue on RemoteUserPriority {
  int get value {
    switch (this) {
      case RemoteUserPriority.low:
        return 0;
      case RemoteUserPriority.medium:
        return 100;
      case RemoteUserPriority.high:
        return 200;
    }
  }
}

extension VideoRotationValue on VideoRotation {
  int get value {
    switch (this) {
      case VideoRotation.rotation0:
        return 0;
      case VideoRotation.rotation90:
        return 90;
      case VideoRotation.rotation180:
        return 180;
      case VideoRotation.rotation270:
        return 270;
    }
  }
}

extension MirrorTypeValue on MirrorType {
  int get value {
    switch (this) {
      case MirrorType.none:
        return 0;
      case MirrorType.render:
        return 1;
      case MirrorType.renderAndEncoder:
        return 3;
    }
  }
}

extension RemoteMirrorTypeValue on RemoteMirrorType {
  int get value {
    switch (this) {
      case RemoteMirrorType.none:
        return 0;
      case RemoteMirrorType.render:
        return 1;
    }
  }
}

extension ProblemFeedbackValue on ProblemFeedbackOption {
  int get value {
    switch (this) {
      case ProblemFeedbackOption.none:
        return 0;
      case ProblemFeedbackOption.otherMessage:
        return 1 << 0;
      case ProblemFeedbackOption.disconnected:
        return 1 << 1;
      case ProblemFeedbackOption.earBackDelay:
        return 1 << 2;
      case ProblemFeedbackOption.localNoise:
        return 1 << 10;
      case ProblemFeedbackOption.localAudioLagging:
        return 1 << 11;
      case ProblemFeedbackOption.localNoAudio:
        return 1 << 12;
      case ProblemFeedbackOption.localAudioStrength:
        return 1 << 13;
      case ProblemFeedbackOption.localEcho:
        return 1 << 14;
      case ProblemFeedbackOption.localVideoFuzzy:
        return 1 << 24;
      case ProblemFeedbackOption.localNotSync:
        return 1 << 25;
      case ProblemFeedbackOption.localVideoLagging:
        return 1 << 26;
      case ProblemFeedbackOption.localNoVideo:
        return 1 << 27;
      case ProblemFeedbackOption.remoteNoise:
        return 1 << 37;
      case ProblemFeedbackOption.remoteAudioLagging:
        return 1 << 38;
      case ProblemFeedbackOption.remoteNoAudio:
        return 1 << 39;
      case ProblemFeedbackOption.remoteAudioStrength:
        return 1 << 40;
      case ProblemFeedbackOption.remoteEcho:
        return 1 << 41;
      case ProblemFeedbackOption.remoteVideoFuzzy:
        return 1 << 51;
      case ProblemFeedbackOption.remoteNotSync:
        return 1 << 52;
      case ProblemFeedbackOption.remoteVideoLagging:
        return 1 << 53;
      case ProblemFeedbackOption.remoteNoVideo:
        return 1 << 54;
    }
  }
}

extension VideoRenderModeValue on VideoRenderMode {
  int get value {
    return index + 1;
  }
}

extension MediaStreamTypeValue on MediaStreamType {
  int get value {
    return index + 1;
  }
}

extension AudioRouteValue on AudioRoute {
  int get value {
    if (index == 0) {
      return -1;
    }
    return index;
  }
}

extension TranscodingVideoCodecValue on TranscodingVideoCodec {
  String get value {
    switch (this) {
      case TranscodingVideoCodec.h264:
        return 'H264';
      case TranscodingVideoCodec.byteVC1:
        return 'ByteVC1';
    }
  }
}

extension TranscodingAudioCodecValue on TranscodingAudioCodec {
  String get value {
    switch (this) {
      case TranscodingAudioCodec.aac:
        return 'AAC';
    }
  }
}

extension AACProfileValue on AACProfile {
  String get value {
    switch (this) {
      case AACProfile.lc:
        return 'LC';
      case AACProfile.hev1:
        return 'HEv1';
      case AACProfile.hev2:
        return 'HEv2';
    }
  }
}

extension AudioSampleRateValue on AudioSampleRate {
  int get value {
    switch (this) {
      case AudioSampleRate.auto:
        return -1;
      case AudioSampleRate.rate8000:
        return 8000;
      case AudioSampleRate.rate16000:
        return 16000;
      case AudioSampleRate.rate32000:
        return 32000;
      case AudioSampleRate.rate44100:
        return 44100;
      case AudioSampleRate.rate48000:
        return 48000;
    }
  }
}

extension AudioChannelValue on AudioChannel {
  int get value {
    switch (this) {
      case AudioChannel.auto:
        return -1;
      case AudioChannel.mono:
        return 1;
      case AudioChannel.stereo:
        return 2;
    }
  }
}

extension MusicFilterTypeValue on MusicFilterType {
  int get value {
    if (this == MusicFilterType.none) return 0;
    return 1 << (index - 1);
  }
}

extension MusicHotTypeValue on MusicHotType {
  int get value {
    return 1 << index;
  }
}

extension AudioTrackTypeValue on AudioTrackType {
  int get value {
    return index + 1;
  }
}

extension LocalProxyTypeValue on LocalProxyType {
  int get value {
    return index + 1;
  }
}

extension MixedStreamRenderModeValue on MixedStreamRenderMode {
  int get value {
    return index + 1;
  }
}

/// int to enum
E _convertEnumValue<E>(List<E> values, int? idx, E defaultValue) {
  if (idx == null || idx >= values.length || idx < 0) {
    debugPrint('RTC: Enum ($E) unknown value $idx');
    return defaultValue;
  }
  return values[idx];
}

extension RTCTypeValue on int? {
  WarningCode get warningCode {
    switch (this) {
      case -2001:
        return WarningCode.joinRoomFailed;
      case -2002:
        return WarningCode.publishStreamFailed;
      case -2003:
        return WarningCode.subscribeStreamFailed404;
      case -2004:
        return WarningCode.subscribeStreamFailed5xx;
      case -2009:
        return WarningCode.publishStreamForbidden;
      case -2011:
        return WarningCode.sendCustomMessage;
      case -2013:
        return WarningCode.receiveUserNotifyStop;
      case -2014:
        return WarningCode.userInPublish;
      case -2015:
        return WarningCode.roomIdAlreadyExist;
      case -2016:
        return WarningCode.oldRoomBeenReplaced;
      case -2017:
        return WarningCode.inEchoTestMode;
      case -5001:
        return WarningCode.noCameraPermission;
      case -5002:
        return WarningCode.noMicrophonePermission;
      case -5003:
        return WarningCode.audioDeviceManagerRecordingStartFail;
      case -5004:
        return WarningCode.audioDeviceManagerPlayoutStartFail;
      case -5005:
        return WarningCode.noRecordingDevice;
      case -5006:
        return WarningCode.noPlayoutDevice;
      case -5007:
        return WarningCode.recordingSilence;
      case -5008:
        return WarningCode.mediaDeviceOperationDenied;
      case -5009:
        return WarningCode.setScreenAudioSourceTypeFailed;
      case -5010:
        return WarningCode.setScreenAudioStreamIndexFailed;
      case -5011:
        return WarningCode.invalidVoicePitch;
      case -5013:
        return WarningCode.invalidCallForExtAudio;
      case -6001:
        return WarningCode.invalidCanvasHandle;
      case -7002:
        return WarningCode.invalidSamiAppKeyOrToken;
      case -7003:
        return WarningCode.invalidSamiResourcePath;
      case -7004:
        return WarningCode.loadSamiLibraryFailed;
      case -7005:
        return WarningCode.invalidSamiEffectType;
      default:
        debugPrint('RTC: WarningCode unknown value $this');
        return WarningCode.unknown;
    }
  }

  ErrorCode get errorCode {
    switch (this) {
      case -1000:
        return ErrorCode.invalidToken;
      case -1001:
        return ErrorCode.joinRoom;
      case -1002:
        return ErrorCode.noPublishPermission;
      case -1003:
        return ErrorCode.noSubscribePermission;
      case -1004:
        return ErrorCode.duplicateLogin;
      case -1005:
        return ErrorCode.appIdNull;
      case -1006:
        return ErrorCode.kickedOut;
      case -1007:
        return ErrorCode.roomIdIllegal;
      case -1009:
        return ErrorCode.tokenExpired;
      case -1010:
        return ErrorCode.updateTokenWithInvalidToken;
      case -1011:
        return ErrorCode.roomDismiss;
      case -1012:
        return ErrorCode.joinRoomWithoutLicenseAuthenticateSDK;
      case -1013:
        return ErrorCode.roomAlreadyExist;
      case -1014:
        return ErrorCode.userIdDifferent;
      case -1017:
        return ErrorCode.joinRoomServerLicenseExpired;
      case -1018:
        return ErrorCode.joinRoomExceedsTheUpperLimit;
      case -1019:
        return ErrorCode.joinRoomLicenseParameterError;
      case -1020:
        return ErrorCode.joinRoomLicenseFilePathError;
      case -1021:
        return ErrorCode.joinRoomLicenseIllegal;
      case -1022:
        return ErrorCode.joinRoomLicenseExpired;
      case -1023:
        return ErrorCode.joinRoomLicenseInformationNotMatch;
      case -1024:
        return ErrorCode.joinRoomLicenseNotMatchWithCache;
      case -1025:
        return ErrorCode.joinRoomRoomForbidden;
      case -1026:
        return ErrorCode.joinRoomUserForbidden;
      case -1027:
        return ErrorCode.joinRoomLicenseFunctionNotFound;
      case -1070:
        return ErrorCode.overStreamSubscribeLimit;
      case -1072:
        return ErrorCode.loadSOLib;
      case -1080:
        return ErrorCode.overStreamPublishLimit;
      case -1081:
        return ErrorCode.overScreenPublishLimit;
      case -1082:
        return ErrorCode.overVideoPublishLimit;
      case -1083:
        return ErrorCode.invalidAudioSyncUidRepeated;
      case -1084:
        return ErrorCode.abnormalServerStatus;
      default:
        debugPrint('RTC: ErrorCode unknown value $this');
        return ErrorCode.unknown;
    }
  }

  RTCConnectionState get connectionState {
    return _convertEnumValue(
        RTCConnectionState.values, (this ?? 1) - 1, RTCConnectionState.failed);
  }

  NetworkType get networkType {
    return _convertEnumValue(
        NetworkType.values, (this ?? -1) + 1, NetworkType.unknown);
  }

  VideoCodecType get videoCodecType {
    return _convertEnumValue(VideoCodecType.values, this, VideoCodecType.auto);
  }

  LocalAudioStreamState get localAudioStreamState {
    return _convertEnumValue(
        LocalAudioStreamState.values, this, LocalAudioStreamState.failed);
  }

  LocalAudioStreamError get localAudioStreamError {
    return _convertEnumValue(
        LocalAudioStreamError.values, this, LocalAudioStreamError.failure);
  }

  StreamIndex get streamIndex {
    return _convertEnumValue(StreamIndex.values, this, StreamIndex.main);
  }

  RemoteAudioState get remoteAudioState {
    return _convertEnumValue(
        RemoteAudioState.values, this, RemoteAudioState.failed);
  }

  RemoteAudioStateChangeReason get remoteAudioStateChangeReason {
    return _convertEnumValue(RemoteAudioStateChangeReason.values, this,
        RemoteAudioStateChangeReason.internal);
  }

  LocalVideoStreamState get localVideoStreamState {
    return _convertEnumValue(
        LocalVideoStreamState.values, this, LocalVideoStreamState.failed);
  }

  LocalVideoStreamError get localVideoStreamError {
    return _convertEnumValue(
        LocalVideoStreamError.values, this, LocalVideoStreamError.failure);
  }

  RemoteVideoState get remoteVideoState {
    return _convertEnumValue(
        RemoteVideoState.values, this, RemoteVideoState.failed);
  }

  VideoSuperResolutionMode get videoSuperResolutionMode {
    return _convertEnumValue(
        VideoSuperResolutionMode.values, this, VideoSuperResolutionMode.off);
  }

  VideoSuperResolutionModeChangedReason
      get videoSuperResolutionModeChangedReason {
    return _convertEnumValue(VideoSuperResolutionModeChangedReason.values, this,
        VideoSuperResolutionModeChangedReason.apiOff);
  }

  VideoDenoiseMode get videoDenoiseMode {
    return _convertEnumValue(
        VideoDenoiseMode.values, this, VideoDenoiseMode.off);
  }

  VideoDenoiseModeChangedReason get videoDenoiseModeChangedReason {
    return _convertEnumValue(VideoDenoiseModeChangedReason.values, this,
        VideoDenoiseModeChangedReason.apiOff);
  }

  RemoteVideoStateChangeReason get remoteVideoStateChangedReason {
    return _convertEnumValue(RemoteVideoStateChangeReason.values, this,
        RemoteVideoStateChangeReason.internal);
  }

  VideoRotation get videoRotation {
    switch (this) {
      case 0:
        return VideoRotation.rotation0;
      case 90:
        return VideoRotation.rotation90;
      case 180:
        return VideoRotation.rotation180;
      case 270:
        return VideoRotation.rotation270;
      default:
        debugPrint('RTC: VideoRotation unknown value $this');
        return VideoRotation.rotation0;
    }
  }

  NetworkQuality get networkQuality {
    return _convertEnumValue(
        NetworkQuality.values, this, NetworkQuality.unKnown);
  }

  FallbackOrRecoverReason get fallbackOrRecoverReason {
    return _convertEnumValue(FallbackOrRecoverReason.values, (this ?? -1) + 1,
        FallbackOrRecoverReason.unknown);
  }

  FirstFrameSendState get firstFrameSendState {
    return _convertEnumValue(
        FirstFrameSendState.values, this, FirstFrameSendState.end);
  }

  FirstFramePlayState get firstFramePlayState {
    return _convertEnumValue(
        FirstFramePlayState.values, this, FirstFramePlayState.end);
  }

  AudioMixingState get audioMixingState {
    return _convertEnumValue(
        AudioMixingState.values, this, AudioMixingState.failed);
  }

  AudioMixingError get audioMixingError {
    return _convertEnumValue(
        AudioMixingError.values, this, AudioMixingError.startFailed);
  }

  PerformanceAlarmMode get performanceAlarmMode {
    return _convertEnumValue(
        PerformanceAlarmMode.values, this, PerformanceAlarmMode.normal);
  }

  PerformanceAlarmReason get performanceAlarmReason {
    return _convertEnumValue(PerformanceAlarmReason.values, this,
        PerformanceAlarmReason.bandwidthFallbacked);
  }

  RecordingState get recordingState {
    return _convertEnumValue(RecordingState.values, this, RecordingState.error);
  }

  RecordingErrorCode get recordingErrorCode {
    return _convertEnumValue(
        RecordingErrorCode.values, 0 - (this ?? 0), RecordingErrorCode.noOther);
  }

  SyncInfoStreamType get syncInfoStreamType {
    return _convertEnumValue(
        SyncInfoStreamType.values, this, SyncInfoStreamType.audio);
  }

  MediaStreamType get mediaStreamType {
    return _convertEnumValue(
        MediaStreamType.values, (this ?? 1) - 1, MediaStreamType.both);
  }

  AudioRoute get audioRoute {
    return _convertEnumValue(AudioRoute.values, this, AudioRoute.routeDefault);
  }

  ForwardStreamState get forwardStreamState {
    return _convertEnumValue(
        ForwardStreamState.values, this, ForwardStreamState.failure);
  }

  ForwardStreamError get forwardStreamError {
    if (this == 0) {
      return ForwardStreamError.ok;
    }
    return _convertEnumValue(ForwardStreamError.values, (this ?? 1200) - 1200,
        ForwardStreamError.notSupport);
  }

  ForwardStreamEvent get forwardStreamEvent {
    return _convertEnumValue(
        ForwardStreamEvent.values, this, ForwardStreamEvent.disconnected);
  }

  StreamRemoveReason get streamRemoveReason {
    return _convertEnumValue(
        StreamRemoveReason.values, this, StreamRemoveReason.other);
  }

  AudioDeviceType get audioDeviceType {
    return _convertEnumValue(
        AudioDeviceType.values, (this ?? -1) + 1, AudioDeviceType.unknown);
  }

  VideoDeviceType get videoDeviceType {
    return _convertEnumValue(
        VideoDeviceType.values, (this ?? -1) + 1, VideoDeviceType.unknown);
  }

  MediaDeviceState get mediaDeviceState {
    switch (this) {
      case 1:
        return MediaDeviceState.started;
      case 2:
        return MediaDeviceState.stopped;
      case 3:
        return MediaDeviceState.runtimeError;
      case 10:
        return MediaDeviceState.added;
      case 11:
        return MediaDeviceState.removed;
      case 12:
        return MediaDeviceState.interruptionBegan;
      case 13:
        return MediaDeviceState.interruptionEnded;
      default:
        debugPrint('RTC: MediaDeviceState unknown value $this');
        return MediaDeviceState.runtimeError;
    }
  }

  MediaDeviceError get mediaDeviceError {
    return _convertEnumValue(
        MediaDeviceError.values, this, MediaDeviceError.deviceFailure);
  }

  MediaDeviceWarning get mediaDeviceWarning {
    switch (this) {
      case 0:
        return MediaDeviceWarning.ok;
      case 1:
        return MediaDeviceWarning.operationDenied;
      case 2:
        return MediaDeviceWarning.captureSilence;
      case 3:
        return MediaDeviceWarning.androidSysSilence;
      case 4:
        return MediaDeviceWarning.androidSysSilenceDisappear;
      case 10:
        return MediaDeviceWarning.detectClipping;
      case 11:
        return MediaDeviceWarning.detectLeakEcho;
      case 12:
        return MediaDeviceWarning.detectLowSNR;
      case 13:
        return MediaDeviceWarning.detectInsertSilence;
      case 14:
        return MediaDeviceWarning.captureDetectSilence;
      case 15:
        return MediaDeviceWarning.captureDetectSilenceDisappear;
      case 16:
        return MediaDeviceWarning.captureDetectHowling;
      case 20:
        return MediaDeviceWarning.setAudioRouteInvalidScenario;
      case 21:
        return MediaDeviceWarning.setAudioRouteNotExists;
      case 22:
        return MediaDeviceWarning.setAudioRouteFailedByPriority;
      case 23:
        return MediaDeviceWarning.setAudioRouteNotVoipMode;
      case 24:
        return MediaDeviceWarning.setAudioRouteDeviceNotStart;
      case 25:
        return MediaDeviceWarning.setBluetoothModeScenarioUnsupport;
      case 26:
        return MediaDeviceWarning.setBluetoothModeUnsupport;
      default:
        debugPrint('RTC: MediaDeviceWarning unknown value $this');
        return MediaDeviceWarning.operationDenied;
    }
  }

  SubscribeState get subscribeState {
    return _convertEnumValue(
        SubscribeState.values, this, SubscribeState.success);
  }

  NetworkDetectionLinkType get networkDetectionLinkType {
    return _convertEnumValue(
        NetworkDetectionLinkType.values, this, NetworkDetectionLinkType.up);
  }

  NetworkDetectionStopReason get networkDetectionStopReason {
    return _convertEnumValue(NetworkDetectionStopReason.values, this,
        NetworkDetectionStopReason.innerErr);
  }

  StreamMixingType get streamMixingType {
    return _convertEnumValue(
        StreamMixingType.values, this, StreamMixingType.byServer);
  }

  StreamMixingEvent get streamMixingEvent {
    return _convertEnumValue(
        StreamMixingEvent.values, this, StreamMixingEvent.base);
  }

  StreamMixingErrorCode get transcoderErrorCode {
    if (this == 0) {
      return StreamMixingErrorCode.ok;
    }
    return _convertEnumValue(StreamMixingErrorCode.values,
        (this ?? 1090) - 1089, StreamMixingErrorCode.base);
  }

  AVSyncState get avSyncState {
    return _convertEnumValue(
        AVSyncState.values, this, AVSyncState.streamSyncBegin);
  }

  SEIStreamUpdateEvent get seiStreamUpdateEvent {
    return _convertEnumValue(
        SEIStreamUpdateEvent.values, this, SEIStreamUpdateEvent.streamRemove);
  }

  EchoTestResult get echoTestResult {
    return _convertEnumValue(
        EchoTestResult.values, this, EchoTestResult.internalError);
  }

  StreamSinglePushEvent get streamSinglePushEvent {
    return _convertEnumValue(
        StreamSinglePushEvent.values, this, StreamSinglePushEvent.base);
  }

  LogoutReason get logoutReason {
    return _convertEnumValue(LogoutReason.values, this, LogoutReason.logout);
  }

  UserOfflineReason get userOfflineReason {
    return _convertEnumValue(
        UserOfflineReason.values, this, UserOfflineReason.quit);
  }

  LoginErrorCode get loginErrorCode {
    if (this == 0) {
      return LoginErrorCode.success;
    }
    return _convertEnumValue(LoginErrorCode.values, -(this ?? -1001) - 999,
        LoginErrorCode.loginFailed);
  }

  UserMessageSendResult get userMessageSendResult {
    switch (this) {
      case 0:
        return UserMessageSendResult.success;
      case 1:
        return UserMessageSendResult.timeout;
      case 2:
        return UserMessageSendResult.broken;
      case 3:
        return UserMessageSendResult.noReceiver;
      case 4:
        return UserMessageSendResult.noRelayPath;
      case 5:
        return UserMessageSendResult.exceedQPS;
      case 17:
        return UserMessageSendResult.e2BSSendFailed;
      case 18:
        return UserMessageSendResult.e2BSReturnFailed;
      case 100:
        return UserMessageSendResult.notJoin;
      case 101:
        return UserMessageSendResult.init;
      case 102:
        return UserMessageSendResult.noConnection;
      case 103:
        return UserMessageSendResult.exceedMaxLength;
      case 104:
        return UserMessageSendResult.emptyUser;
      case 105:
        return UserMessageSendResult.notLogin;
      case 106:
        return UserMessageSendResult.serverParamsNotSet;
      case 1000:
        return UserMessageSendResult.unknown;
      default:
        debugPrint('RTC: UserMessageSendResult unknown value $this');
        return UserMessageSendResult.unknown;
    }
  }

  UserOnlineStatus get userOnlineStatus {
    return _convertEnumValue(
        UserOnlineStatus.values, this, UserOnlineStatus.unreachable);
  }

  RoomMessageSendResult get roomMessageSendResult {
    switch (this) {
      case 200:
        return RoomMessageSendResult.success;
      case 1:
        return RoomMessageSendResult.timeout;
      case 2:
        return RoomMessageSendResult.networkDisconnected;
      case 5:
        return RoomMessageSendResult.exceedQPS;
      case 100:
        return RoomMessageSendResult.notJoin;
      case 101:
        return RoomMessageSendResult.init;
      case 102:
        return RoomMessageSendResult.noConnection;
      case 103:
        return RoomMessageSendResult.exceedMaxLength;
      case 1000:
        return RoomMessageSendResult.unknown;
      default:
        debugPrint('RTC: RoomMessageSendResult unknown value $this');
        return RoomMessageSendResult.unknown;
    }
  }

  PublicStreamErrorCode get publicStreamErrorCode {
    switch (this) {
      case 0:
        return PublicStreamErrorCode.success;
      case 1191:
        return PublicStreamErrorCode.pushParamError;
      case 1192:
        return PublicStreamErrorCode.pushStateError;
      case 1193:
        return PublicStreamErrorCode.pushInternalError;
      case 1195:
        return PublicStreamErrorCode.pushError;
      case 1196:
        return PublicStreamErrorCode.pushTimeOut;
      case 1300:
        return PublicStreamErrorCode.pullNoPushStream;
      default:
        debugPrint('RTC: PublicStreamErrorCode unknown value $this');
        return PublicStreamErrorCode.pushInternalError;
    }
  }

  DataMessageSourceType get seiMessageSourceType {
    return _convertEnumValue(
        DataMessageSourceType.values, this, DataMessageSourceType.def);
  }

  AudioRecordingState get audioRecordingState {
    return _convertEnumValue(
        AudioRecordingState.values, this, AudioRecordingState.error);
  }

  AudioRecordingErrorCode get audioRecordingErrorCode {
    switch (this) {
      case 0:
        return AudioRecordingErrorCode.ok;
      case -1:
        return AudioRecordingErrorCode.noPermission;
      case -2:
        return AudioRecordingErrorCode.notInRoom;
      case -3:
        return AudioRecordingErrorCode.alreadyStarted;
      case -4:
        return AudioRecordingErrorCode.notStarted;
      case -5:
        return AudioRecordingErrorCode.notSupport;
      case -6:
        return AudioRecordingErrorCode.other;
      default:
        debugPrint('RTC: PublicStreamErrorCode unknown value $this');
        return AudioRecordingErrorCode.other;
    }
  }

  MusicHotType get ktvMusicHotType {
    return _convertEnumValue(
        MusicHotType.values, (this ?? 1) - 1, MusicHotType.contentCenter);
  }

  PlayState get ktvPlayState {
    return _convertEnumValue(
        PlayState.values, (this ?? 4) - 1, PlayState.failed);
  }

  LyricStatus get ktvLyricStatus {
    return _convertEnumValue(LyricStatus.values, this, LyricStatus.none);
  }

  DownloadFileType get ktvDownloadFileType {
    return _convertEnumValue(
        DownloadFileType.values, (this ?? 1) - 1, DownloadFileType.music);
  }

  KTVErrorCode get ktvError {
    switch (this) {
      case 0:
        return KTVErrorCode.ok;
      case -3000:
        return KTVErrorCode.appIdInValid;
      case -3001:
        return KTVErrorCode.parasInValid;
      case -3002:
        return KTVErrorCode.getMusicFailed;
      case -3003:
        return KTVErrorCode.getLyricFailed;
      case -3004:
        return KTVErrorCode.musicTakedown;
      case -3005:
        return KTVErrorCode.musicDownload;
      case -3006:
        return KTVErrorCode.midiDownloadFailed;
      case -3007:
        return KTVErrorCode.systemBusy;
      case -3008:
        return KTVErrorCode.network;
      case -3009:
        return KTVErrorCode.notJoinRoom;
      case -3010:
        return KTVErrorCode.parseData;
      case -3011:
        return KTVErrorCode.download;
      case -3012:
        return KTVErrorCode.downloading;
      case -3013:
        return KTVErrorCode.internal;
      case -3014:
        return KTVErrorCode.insufficientDiskSpace;
      case -3015:
        return KTVErrorCode.musicDecryptionFailed;
      case -3016:
        return KTVErrorCode.fileRenameFailed;
      case -3017:
        return KTVErrorCode.downloadTimeOut;
      case -3018:
        return KTVErrorCode.clearCacheFailed;
      case -3019:
        return KTVErrorCode.downloadCanceled;
      default:
        debugPrint('RTC: KTVErrorCode unknown value $this');
        return KTVErrorCode.internal;
    }
  }

  KTVPlayerErrorCode get ktvPlayerError {
    switch (this) {
      case 0:
        return KTVPlayerErrorCode.ok;
      case -3020:
        return KTVPlayerErrorCode.fileNotExist;
      case -3021:
        return KTVPlayerErrorCode.fileError;
      case -3022:
        return KTVPlayerErrorCode.notJoinRoom;
      case -3023:
        return KTVPlayerErrorCode.param;
      case -3024:
        return KTVPlayerErrorCode.startError;
      case -3025:
        return KTVPlayerErrorCode.mixIdError;
      case -3026:
        return KTVPlayerErrorCode.positionError;
      case -3027:
        return KTVPlayerErrorCode.audioVolumeError;
      case -3028:
        return KTVPlayerErrorCode.typeError;
      case -3029:
        return KTVPlayerErrorCode.pitchError;
      case -3030:
        return KTVPlayerErrorCode.audioTrackError;
      case -3031:
        return KTVPlayerErrorCode.startingError;
      default:
        debugPrint('RTC: KTVPlayerErrorCode unknown value $this');
        return KTVPlayerErrorCode.param;
    }
  }

  HardwareEchoDetectionResult get hardwareEchoDetectionResult {
    return _convertEnumValue(HardwareEchoDetectionResult.values, this,
        HardwareEchoDetectionResult.unknown);
  }

  LocalProxyType get localProxyType {
    return _convertEnumValue(
        LocalProxyType.values, (this ?? 1) - 1, LocalProxyType.socks5);
  }

  LocalProxyState get localProxyState {
    return _convertEnumValue(
        LocalProxyState.values, this, LocalProxyState.error);
  }

  LocalProxyError get localProxyError {
    return _convertEnumValue(
        LocalProxyError.values, this, LocalProxyError.httpTunnelFailed);
  }

  SetRoomExtraInfoResult get setRoomExtraInfoResult {
    switch (this) {
      case 0:
        return SetRoomExtraInfoResult.success;
      case -1:
        return SetRoomExtraInfoResult.notJoinRoom;
      case -2:
        return SetRoomExtraInfoResult.keyIsNull;
      case -3:
        return SetRoomExtraInfoResult.valueIsNull;
      case -99:
        return SetRoomExtraInfoResult.unknown;
      case -400:
        return SetRoomExtraInfoResult.keyIsEmpty;
      case -406:
        return SetRoomExtraInfoResult.tooOften;
      case -412:
        return SetRoomExtraInfoResult.silentUser;
      case -413:
        return SetRoomExtraInfoResult.keyTooLong;
      case -414:
        return SetRoomExtraInfoResult.valueTooLong;
      case -500:
        return SetRoomExtraInfoResult.serverError;
      default:
        debugPrint('RTC: SetRoomExtraInfoResult unknown value $this');
        return SetRoomExtraInfoResult.unknown;
    }
  }

  SubtitleState get subtitleState {
    return _convertEnumValue(SubtitleState.values, this, SubtitleState.error);
  }

  SubtitleErrorCode get subtitleErrorCode {
    return _convertEnumValue(
        SubtitleErrorCode.values, (this ?? -1) + 1, SubtitleErrorCode.unknown);
  }

  SubtitleMode get subtitleMode {
    return _convertEnumValue(
        SubtitleMode.values, (this ?? -1) + 1, SubtitleMode.recognition);
  }

  PlayerState get playerState {
    return _convertEnumValue(PlayerState.values, this, PlayerState.failed);
  }

  PlayerError get playerError {
    return _convertEnumValue(
        PlayerError.values, this, PlayerError.invalidState);
  }

  UserVisibilityChangeError get userVisibilityChangeError {
    return _convertEnumValue(UserVisibilityChangeError.values, this,
        UserVisibilityChangeError.unknown);
  }
}
