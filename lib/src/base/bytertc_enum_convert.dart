// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import '../../api/bytertc_audio_defines.dart';
import '../../api/bytertc_common_defines.dart';
import '../../api/bytertc_render_view.dart';
import '../../api/bytertc_video_defines.dart';

/// enum to int
extension AudioScenarioValue on AudioScenario {
  int get value {
    return index;
  }
}

extension RoomProfileValue on RoomProfile {
  int get value {
    return index;
  }
}

extension CameraIdValue on CameraId {
  int get value {
    return index;
  }
}

extension ScaleModeValue on ScaleMode {
  int get value {
    return index;
  }
}

extension VideoCodecTypeValue on VideoCodecType {
  int get value {
    return index;
  }
}

extension EncoderPreferenceValue on EncoderPreference {
  int get value {
    return index;
  }
}

extension StreamIndexValue on StreamIndex {
  int get value {
    return index;
  }
}

extension PauseResumeControlMediaTypeValue on PauseResumeControlMediaType {
  int get value {
    return index;
  }
}

extension EarMonitorModeValue on EarMonitorMode {
  int get value {
    return index;
  }
}

extension AudioProfileTypeValue on AudioProfileType {
  int get value {
    return index;
  }
}

extension AudioMixingTypeValue on AudioMixingType {
  int get value {
    return index;
  }
}

extension SyncInfoStreamTypeValue on SyncInfoStreamType {
  int get value {
    return index;
  }
}

extension PublishFallbackOptionValue on PublishFallbackOption {
  int get value {
    return index;
  }
}

extension SubscribeFallbackOptionValue on SubscribeFallbackOption {
  int get value {
    return index;
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

extension RecordingFileTypeValue on RecordingFileType {
  int get value {
    return index;
  }
}

extension RecordingTypeValue on RecordingType {
  int get value {
    return index;
  }
}

extension ASRAuthorizationTypeValue on ASRAuthorizationType {
  int get value {
    return index;
  }
}

extension ProblemFeedbackValue on ProblemFeedback {
  int get value {
    if (this == ProblemFeedback.none) return 0;
    return 1 << (index - 1);
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

extension VoiceChangerTypeValue on VoiceChangerType {
  int get value {
    return index;
  }
}

extension VoiceReverbTypeValue on VoiceReverbType {
  int get value {
    return index;
  }
}

extension VideoRotationModeeValue on VideoRotationMode {
  int get value {
    return index;
  }
}

extension VirtualBackgroundSourceTypeValue on VirtualBackgroundSourceType {
  int get value {
    return index;
  }
}

extension TorchStateValue on TorchState {
  int get value {
    return index;
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

extension AudioMixingDualMonoModeValue on AudioMixingDualMonoMode {
  int get value {
    return index;
  }
}

extension VideoCapturePreferenceValue on VideoCapturePreference {
  int get value {
    return index;
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

extension StreamMixingTypeValue on StreamMixingType {
  int get value {
    return index;
  }
}

extension TranscoderContentControlTypeValue on TranscoderContentControlType {
  int get value {
    return index;
  }
}

extension TranscoderLayoutRegionTypeValue on TranscoderLayoutRegionType {
  int get value {
    return index;
  }
}

extension ScreenMediaTypeValue on ScreenMediaType {
  int get value {
    return index;
  }
}

extension VideoCanvasTypeValue on VideoCanvasType {
  int get value {
    return index;
  }
}

extension EffectBeautyModeValue on EffectBeautyMode {
  int get value {
    return index;
  }
}

extension MessageConfigValue on MessageConfig {
  int get value {
    return index;
  }
}

extension AttenuationTypeValue on AttenuationType {
  int get value {
    return index;
  }
}

extension VideoOrientationValue on VideoOrientation {
  int get value {
    return index;
  }
}

/// int to enum
E _convertEnumValue<E>(List<E> values, int? idx, E defaultValue) {
  if (idx == null || idx >= values.length || idx < 0) {
    print("RTC: Enum ($E) unknown value $idx");
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
      default:
        print("RTC: WarningCode unknown value $this");
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
      case -1070:
        return ErrorCode.overStreamSubscribeLimit;
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
        print("RTC: ErrorCode unknown value $this");
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

  RemoteVideoStateChangedReason get remoteVideoStateChangedReason {
    return _convertEnumValue(RemoteVideoStateChangedReason.values, this,
        RemoteVideoStateChangedReason.internal);
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
        print("RTC: VideoRotation unknown value $this");
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
    return _convertEnumValue(AudioRoute.values, this, AudioRoute.unknown);
  }

  NetworkDetectionStartReturn get networkDetectionStartReturn {
    return _convertEnumValue(NetworkDetectionStartReturn.values, this,
        NetworkDetectionStartReturn.notSupport);
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
        print("RTC: MediaDeviceState unknown value $this");
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
      default:
        print("RTC: MediaDeviceWarning unknown value $this");
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

  TranscoderErrorCode get transcoderErrorCode {
    if (this == 0) {
      return TranscoderErrorCode.ok;
    }
    return _convertEnumValue(TranscoderErrorCode.values, (this ?? 1090) - 1089,
        TranscoderErrorCode.base);
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
      default:
        print("RTC: UserMessageSendResult unknown value $this");
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
      case 100:
        return RoomMessageSendResult.notJoin;
      case 101:
        return RoomMessageSendResult.init;
      case 102:
        return RoomMessageSendResult.noConnection;
      case 103:
        return RoomMessageSendResult.exceedMaxLength;
      default:
        print("RTC: RoomMessageSendResult unknown value $this");
        return RoomMessageSendResult.unknown;
    }
  }

  PublicStreamErrorCode get publicStreamErrorCode {
    switch (this) {
      case 0:
      case 200:
        return PublicStreamErrorCode.success;
      case 1191:
        return PublicStreamErrorCode.paramError;
      case 1192:
        return PublicStreamErrorCode.statusError;
      case 1193:
        return PublicStreamErrorCode.internalError;
      case 1195:
        return PublicStreamErrorCode.pushError;
      case 1196:
        return PublicStreamErrorCode.timeOut;
      default:
        print("RTC: PublicStreamErrorCode unknown value $this");
        return PublicStreamErrorCode.internalError;
    }
  }
}
