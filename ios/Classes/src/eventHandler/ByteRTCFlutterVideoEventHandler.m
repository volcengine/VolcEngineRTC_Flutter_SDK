/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterVideoEventHandler.h"
#import "ByteRTCFlutterMapCategory.h"

@interface ByteRTCFlutterVideoEventHandler ()

@property (nonatomic, assign) BOOL enableSysStats;

@end

@implementation ByteRTCFlutterVideoEventHandler

#pragma mark -

- (void)handleSwitches:(NSDictionary *)arguments result:(FlutterResult)result {
    [arguments enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if ([[self valueForKey:key] isKindOfClass:[value class]]) {
            [self setValue:value forKey:key];
        }
    }];
    result(nil);
}

#pragma mark - ByteRTCVideoDelegate
#pragma mark - Core Delegate Methods

- (void)rtcEngine:(ByteRTCVideo *)engine onWarning:(ByteRTCWarningCode)code{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"code"] = @(code);
    [self emitEvent:dict methodName:@"onWarning"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onError:(ByteRTCErrorCode)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"code"] = @(errorCode);
    [self emitEvent:dict methodName:@"onError"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onExtensionAccessError:(NSString *)extensionName msg:(NSString *)msg {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"extensionName"] = extensionName;
    dict[@"msg"] = msg;
    [self emitEvent:dict methodName:@"onExtensionAccessError"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onCreateRoomStateChanged:(NSString *)roomId errorCode:(NSInteger)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"errorCode"] = @(errorCode);
    [self emitEvent:dict methodName:@"onCreateRoomStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onConnectionStateChanged:(ByteRTCConnectionState)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onConnectionStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onNetworkTypeChanged:(ByteRTCNetworkType)type {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"type"] = @(type);
    [self emitEvent:dict methodName:@"onNetworkTypeChanged"];
}

#pragma mark - Core Audio Delegate Methods

- (void)rtcEngine:(ByteRTCVideo *)engine onUserStartAudioCapture:(NSString*)roomId
              uid:(NSString *)userId {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"uid"] = userId;
    [self emitEvent:dict methodName:@"onUserStartAudioCapture"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onUserStopAudioCapture:(NSString*)roomId
              uid:(NSString *)userId {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"uid"] = userId;
    [self emitEvent:dict methodName:@"onUserStopAudioCapture"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onFirstRemoteAudioFrame:(ByteRTCRemoteStreamKey *)key {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = key.bf_toMap;
    [self emitEvent:dict methodName:@"onFirstRemoteAudioFrame"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onLocalAudioPropertiesReport:(NSArray<ByteRTCLocalAudioPropertiesInfo *> *)audioPropertiesInfos {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *infos = [NSMutableArray array];
    for (ByteRTCLocalAudioPropertiesInfo *info in audioPropertiesInfos) {
        [infos addObject:info.bf_toMap];
    }
    dict[@"infos"] = infos;
    [self emitEvent:dict methodName:@"onLocalAudioPropertiesReport"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onRemoteAudioPropertiesReport:(NSArray<ByteRTCRemoteAudioPropertiesInfo *> *)audioPropertiesInfos totalRemoteVolume:(NSInteger)totalRemoteVolume {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *infos = [NSMutableArray array];
    for (ByteRTCRemoteAudioPropertiesInfo *info in audioPropertiesInfos) {
        [infos addObject:info.bf_toMap];
    }
    dict[@"infos"] = infos;
    dict[@"totalRemoteVolume"] = @(totalRemoteVolume);
    [self emitEvent:dict methodName:@"onRemoteAudioPropertiesReport"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onActiveSpeaker:(NSString *)roomId uid:(NSString *)uid {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"uid"] = uid;
    [self emitEvent:dict methodName:@"onActiveSpeaker"];
}

#pragma mark - Core Video Delegate Methods

- (void)rtcEngine:(ByteRTCVideo *)engine onUserStartVideoCapture:(NSString *)roomId
              uid:(NSString *)uid {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"uid"] = uid;
    [self emitEvent:dict methodName:@"onUserStartVideoCapture"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onUserStopVideoCapture:(NSString *)roomId
              uid:(NSString *)uid {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"uid"] = uid;
    [self emitEvent:dict methodName:@"onUserStopVideoCapture"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onFirstLocalVideoFrameCaptured:(ByteRTCStreamIndex)streamIndex
    withFrameInfo:(ByteRTCVideoFrameInfo *)frameInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"index"] = @(streamIndex);
    dict[@"videoFrame"] = frameInfo.bf_toMap;
    [self emitEvent:dict methodName:@"onFirstLocalVideoFrameCaptured"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onFirstRemoteVideoFrameRendered:(ByteRTCRemoteStreamKey *)streamKey
    withFrameInfo:(ByteRTCVideoFrameInfo *)frameInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = streamKey.bf_toMap;
    dict[@"videoFrame"] = frameInfo.bf_toMap;
    [self emitEvent:dict methodName:@"onFirstRemoteVideoFrameRendered"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onFirstRemoteVideoFrameDecoded:(ByteRTCRemoteStreamKey *)streamKey
    withFrameInfo:(ByteRTCVideoFrameInfo *)frameInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = streamKey.bf_toMap;
    dict[@"videoFrame"] = frameInfo.bf_toMap;
    [self emitEvent:dict methodName:@"onFirstRemoteVideoFrameDecoded"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onRemoteVideoSizeChanged:(ByteRTCRemoteStreamKey *)streamKey
    withFrameInfo:(ByteRTCVideoFrameInfo *)frameInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = streamKey.bf_toMap;
    dict[@"videoFrame"] = frameInfo.bf_toMap;
    [self emitEvent:dict methodName:@"onRemoteVideoSizeChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onLocalVideoSizeChanged:(ByteRTCStreamIndex)streamIndex
    withFrameInfo:(ByteRTCVideoFrameInfo *)frameInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"index"] = @(streamIndex);
    dict[@"videoFrame"] = frameInfo.bf_toMap;
    [self emitEvent:dict methodName:@"onLocalVideoSizeChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onAudioDeviceStateChanged:(NSString *)deviceID
      device_type:(ByteRTCAudioDeviceType)deviceType
     device_state:(ByteRTCMediaDeviceState)deviceState
     device_error:(ByteRTCMediaDeviceError)deviceError {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"deviceId"] = deviceID;
    dict[@"deviceType"] = @(deviceType);
    dict[@"deviceState"] = @(deviceState);
    dict[@"deviceError"] = @(deviceError);
    [self emitEvent:dict methodName:@"onAudioDeviceStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onVideoDeviceStateChanged:(NSString *)deviceID
      device_type:(ByteRTCVideoDeviceType)deviceType
     device_state:(ByteRTCMediaDeviceState)deviceState
     device_error:(ByteRTCMediaDeviceError)deviceError {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"deviceId"] = deviceID;
    dict[@"deviceType"] = @(deviceType);
    dict[@"deviceState"] = @(deviceState);
    dict[@"deviceError"] = @(deviceError);
    [self emitEvent:dict methodName:@"onVideoDeviceStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onAudioDeviceWarning:(NSString*)deviceId
       deviceType:(ByteRTCAudioDeviceType)deviceType
    deviceWarning:(ByteRTCMediaDeviceWarning)deviceWarning {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"deviceId"] = deviceId;
    dict[@"deviceType"] = @(deviceType);
    dict[@"deviceWarning"] = @(deviceWarning);
    [self emitEvent:dict methodName:@"onAudioDeviceWarning"];
    
}

- (void)rtcEngine:(ByteRTCVideo *)engine onVideoDeviceWarning:(NSString*)deviceId
       deviceType:(ByteRTCVideoDeviceType)deviceType
    deviceWarning:(ByteRTCMediaDeviceWarning)deviceWarning {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"deviceId"] = deviceId;
    dict[@"deviceType"] = @(deviceType);
    dict[@"deviceWarning"] = @(deviceWarning);
    [self emitEvent:dict methodName:@"onVideoDeviceWarning"];
    
}

- (void)rtcEngine:(ByteRTCVideo *)engine onAudioFrameSendStateChanged:(NSString *)roomId
          rtcUser:(ByteRTCUser *)user state:(ByteRTCFirstFrameSendState)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"userInfo"] = user.bf_toMap;
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onAudioFrameSendStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onVideoFrameSendStateChanged:(NSString *)roomId
          rtcUser:(ByteRTCUser *)user state:(ByteRTCFirstFrameSendState)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"userInfo"] = user.bf_toMap;
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onVideoFrameSendStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onScreenVideoFrameSendStateChanged:(NSString *)roomId
          rtcUser:(ByteRTCUser *)user state:(ByteRTCFirstFrameSendState)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"userInfo"] = user.bf_toMap;
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onScreenVideoFrameSendStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onAudioFramePlayStateChanged:(NSString *)roomId
          rtcUser:(ByteRTCUser *)user state:(ByteRTCFirstFramePlayState)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"userInfo"] = user.bf_toMap;
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onAudioFramePlayStateChanged"];
}


- (void)rtcEngine:(ByteRTCVideo *)engine onVideoFramePlayStateChanged:(NSString *)roomId
          rtcUser:(ByteRTCUser *)user state:(ByteRTCFirstFramePlayState)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"userInfo"] = user.bf_toMap;
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onVideoFramePlayStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onScreenVideoFramePlayStateChanged:(NSString *)roomId
          rtcUser:(ByteRTCUser *)user state:(ByteRTCFirstFramePlayState)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"userInfo"] = user.bf_toMap;
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onScreenVideoFramePlayStateChanged"];
}

#pragma mark - Media Stream Delegate Methods

- (void)rtcEngine:(ByteRTCVideo *)engine onFirstLocalAudioFrame:(ByteRTCStreamIndex)streamIndex {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"index"] = @(streamIndex);
    [self emitEvent:dict methodName:@"onFirstLocalAudioFrame"];
}


#pragma mark - Media Device Delegate Methods

- (void)rtcEngine:(ByteRTCVideo *)engine onAudioRouteChanged:(ByteRTCAudioRoute)route {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"route"] = @(route);
    [self emitEvent:dict methodName:@"onAudioRouteChanged"];
}

#pragma mark custom message Delegate Methods

- (void)rtcEngine:(ByteRTCVideo *)engine onSEIMessageReceived:(ByteRTCRemoteStreamKey*)remoteStreamKey
       andMessage:(NSData*)message {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = remoteStreamKey.bf_toMap;
    dict[@"message"] = [FlutterStandardTypedData typedDataWithBytes:message];
    [self emitEvent:dict methodName:@"onSEIMessageReceived"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine
onSEIStreamUpdate:(ByteRTCRemoteStreamKey *)remoteStreamKey
        eventType:(ByteSEIStreamEventType)eventType {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = remoteStreamKey.bf_toMap;
    dict[@"event"] = @(eventType);
    [self emitEvent:dict methodName:@"onSEIStreamUpdate"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onStreamSyncInfoReceived:(ByteRTCRemoteStreamKey*)remoteStreamKey
       streamType:(ByteRTCSyncInfoStreamType)streamType data:(NSData*)data {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = remoteStreamKey.bf_toMap;
    dict[@"streamType"] = @(streamType);
    dict[@"data"] = [FlutterStandardTypedData typedDataWithBytes:data];
    [self emitEvent:dict methodName:@"onStreamSyncInfoReceived"];
}

#pragma mark - Statistics Delegate Methods

- (void)rtcEngine:(ByteRTCVideo *)engine onSysStats:(const ByteRTCSysStats *)stats {
    if (!self.enableSysStats) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"stats"] = stats.bf_toMap;
    [self emitEvent:dict methodName:@"onSysStats"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onLocalAudioStateChanged:(ByteRTCLocalAudioStreamState)state
            error:(ByteRTCLocalAudioStreamError)error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"state"] = @(state);
    dict[@"error"] = @(error);
    [self emitEvent:dict methodName:@"onLocalAudioStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onRemoteAudioStateChanged:(ByteRTCRemoteStreamKey *)key
            state:(ByteRTCRemoteAudioState)state
           reason:(ByteRTCRemoteAudioStateChangeReason)reason {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = key.bf_toMap;
    dict[@"state"] = @(state);
    dict[@"reason"] = @(reason);
    [self emitEvent:dict methodName:@"onRemoteAudioStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onLocalVideoStateChanged:(ByteRTCStreamIndex)streamIndex
  withStreamState:(ByteRTCLocalVideoStreamState)state
  withStreamError:(ByteRTCLocalVideoStreamError)error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"index"] = @(streamIndex);
    dict[@"state"] = @(state);
    dict[@"error"] = @(error);
    [self emitEvent:dict methodName:@"onLocalVideoStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onRemoteVideoStateChanged:(ByteRTCRemoteStreamKey*)streamKey
   withVideoState:(ByteRTCRemoteVideoState)state withVideoStateReason:(ByteRTCRemoteVideoStateChangeReason)reason {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = streamKey.bf_toMap;
    dict[@"state"] = @(state);
    dict[@"reason"] = @(reason);
    [self emitEvent:dict methodName:@"onRemoteVideoStateChanged"];
}

#pragma mark - Rtm

- (void)rtcEngine:(ByteRTCVideo *)engine
    onLoginResult:(NSString *)uid
        errorCode:(ByteRTCLoginErrorCode)errorCode
          elapsed:(NSInteger)elapsed {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = uid;
    dict[@"errorCode"] = @(errorCode);
    dict[@"elapsed"] = @(elapsed);
    [self emitEvent:dict methodName:@"onLoginResult"];
}

- (void)rtcEngineOnLogout:(ByteRTCVideo *)engine {
    [self emitEvent:nil methodName:@"onLogout"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onServerParamsSetResult:(NSInteger)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"error"] = @(errorCode);
    [self emitEvent:dict methodName:@"onServerParamsSetResult"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onGetPeerOnlineStatus:(NSString *)peerUserId
           status:(ByteRTCUserOnlineStatus)status {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = peerUserId;
    dict[@"status"] = @(status);
    [self emitEvent:dict methodName:@"onGetPeerOnlineStatus"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onUserMessageReceivedOutsideRoom:(NSString *)uid
          message:(NSString *)message {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = uid;
    dict[@"message"] = message;
    [self emitEvent:dict methodName:@"onUserMessageReceivedOutsideRoom"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onUserBinaryMessageReceivedOutsideRoom:(NSString *)uid
          message:(NSData *)message {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = uid;
    dict[@"message"] = [FlutterStandardTypedData typedDataWithBytes:message];
    [self emitEvent:dict methodName:@"onUserBinaryMessageReceivedOutsideRoom"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onUserMessageSendResultOutsideRoom:(NSInteger)msgid
            error:(ByteRTCUserMessageSendResult)error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"msgid"] = @(msgid);
    dict[@"error"] = @(error);
    [self emitEvent:dict methodName:@"onUserMessageSendResultOutsideRoom"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onServerMessageSendResult:(int64_t)msgid
            error:(ByteRTCUserMessageSendResult)error message:(NSData *)message {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"msgid"] = @(msgid);
    dict[@"error"] = @(error);
    dict[@"message"] = [FlutterStandardTypedData typedDataWithBytes:message];
    [self emitEvent:dict methodName:@"onServerMessageSendResult"];
}

#pragma mark - Network Probe Methods

- (void)rtcEngine:(ByteRTCVideo *)engine onNetworkDetectionResult:(ByteRTCNetworkDetectionLinkType)type
          quality:(ByteRTCNetworkQuality)quality rtt:(int)rtt
         lostRate:(double)lostRate bitrate:(int)bitrate jitter:(int)jitter{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"type"] = @(type);
    dict[@"quality"] = @(quality);
    dict[@"rtt"] = @(rtt);
    dict[@"lostRate"] = @(lostRate);
    dict[@"bitrate"] = @(bitrate);
    dict[@"jitter"] = @(jitter);
    [self emitEvent:dict methodName:@"onNetworkDetectionResult"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onNetworkDetectionStopped:(ByteRTCNetworkDetectionStopReason)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"reason"] = @(errorCode);
    [self emitEvent:dict methodName:@"onNetworkDetectionStopped"];
}

#pragma mark Audio Mix Delegate Methods

- (void)rtcEngine:(ByteRTCVideo *)engine onAudioMixingStateChanged:(NSInteger)mixId
            state:(ByteRTCAudioMixingState)state error:(ByteRTCAudioMixingError)error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mixId"] = @(mixId);
    dict[@"state"] = @(state);
    dict[@"error"] = @(error);
    [self emitEvent:dict methodName:@"onAudioMixingStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onAudioMixingPlayingProgress:(NSInteger)mixId
         progress:(int64_t)progress {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mixId"] = @(mixId);
    dict[@"progress"] = @(progress);
    [self emitEvent:dict methodName:@"onAudioMixingPlayingProgress"];
}

#pragma mark Performance Delegate Methods

- (void)rtcEngine:(ByteRTCVideo *)engine onPerformanceAlarms:(ByteRTCPerformanceAlarmMode)mode
           roomId:(NSString *)roomId
           reason:(ByteRTCPerformanceAlarmReason)reason
 sourceWantedData:(ByteRTCSourceWantedData *)data {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mode"] = @(mode);
    dict[@"roomId"] = roomId;
    dict[@"reason"] = @(reason);
    dict[@"data"] = data.bf_toMap;
    [self emitEvent:dict methodName:@"onPerformanceAlarms"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onSimulcastSubscribeFallback:(ByteRTCRemoteStreamSwitchEvent *)event {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"event"] = event.bf_toMap;
    [self emitEvent:dict methodName:@"onSimulcastSubscribeFallback"];
}

#pragma mark Proxy Delegate Methods

- (void)rtcEngine:(ByteRTCVideo *)engine onHttpProxyState:(NSInteger)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onHttpProxyState"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onHttpsProxyState:(NSInteger)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onHttpsProxyState"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onSocks5ProxyState:(NSInteger)state
              cmd:(NSString *)cmd
    proxy_address:(NSString *)proxyAddress
    local_address:(NSString *)localAddress
   remote_address:(NSString *)remoteAddress {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"state"] = @(state);
    dict[@"cmd"] = cmd;
    dict[@"proxyAddress"] = proxyAddress;
    dict[@"localAddress"] = localAddress;
    dict[@"remoteAddress"] = remoteAddress;
    [self emitEvent:dict methodName:@"onSocks5ProxyState"];
}

#pragma mark FileRecording related callback

- (void)rtcEngine:(ByteRTCVideo *)engine onRecordingStateUpdate:(ByteRTCStreamIndex)type
            state:(ByteRTCRecordingState)state
       error_code:(ByteRTCRecordingErrorCode)errorCode
   recording_info:(ByteRTCRecordingInfo *)recordingInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"state"] = @(state);
    dict[@"type"] = @(type);
    dict[@"errorCode"] = @(errorCode);
    dict[@"info"] = recordingInfo.bf_toMap;
    [self emitEvent:dict methodName:@"onRecordingStateUpdate"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onRecordingProgressUpdate:(ByteRTCStreamIndex)type
          process:(ByteRTCRecordingProgress *)process
   recording_info:(ByteRTCRecordingInfo *)recordingInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"type"] = @(type);
    dict[@"progress"] = process.bf_toMap;
    dict[@"info"] = recordingInfo.bf_toMap;
    [self emitEvent:dict methodName:@"onRecordingProgressUpdate"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onAudioRecordingStateUpdate:(ByteRTCAudioRecordingState)state
       error_code:(ByteRTCAudioRecordingErrorCode)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"state"] = @(state);
    dict[@"errorCode"] = @(errorCode);
    [self emitEvent:dict methodName:@"onAudioRecordingStateUpdate"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onPushPublicStreamResult:(NSString *)roomId
   publicStreamId:(NSString *)publicStreamId
        errorCode:(ByteRTCPublicStreamErrorCode)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"publicStreamId"] = publicStreamId;
    dict[@"errorCode"] = @(errorCode);
    [self emitEvent:dict methodName:@"onPushPublicStreamResult"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onPlayPublicStreamResult:(NSString *)publicStreamId
        errorCode:(ByteRTCPublicStreamErrorCode)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"publicStreamId"] = publicStreamId;
    dict[@"errorCode"] = @(errorCode);
    [self emitEvent:dict methodName:@"onPlayPublicStreamResult"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onPublicStreamSEIMessageReceived:(NSString*)publicStreamId
       andMessage:(NSData*)message
    andSourceType:(ByteRTCDataMessageSourceType)sourceType{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"publicStreamId"] = publicStreamId;
    dict[@"message"] = [FlutterStandardTypedData typedDataWithBytes:message];
    dict[@"sourceType"] = @(sourceType);
    [self emitEvent:dict methodName:@"onPublicStreamSEIMessageReceived"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onPublicStreamDataMessageReceived:(NSString *)publicStreamId andMessage:(NSData *)message andSourceType:(ByteRTCDataMessageSourceType)sourceType {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"publicStreamId"] = publicStreamId;
    dict[@"message"] = [FlutterStandardTypedData typedDataWithBytes:message];
    dict[@"sourceType"] = @(sourceType);
    [self emitEvent:dict methodName:@"onPublicStreamDataMessageReceived"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onFirstPublicStreamVideoFrameDecoded:(NSString *)publicStreamId
    withFrameInfo:(ByteRTCVideoFrameInfo *)frameInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"publicStreamId"] = publicStreamId;
    dict[@"videoFrame"] = frameInfo.bf_toMap;
    [self emitEvent:dict methodName:@"onFirstPublicStreamVideoFrameDecoded"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onFirstPublicStreamAudioFrame:(NSString *)publicStreamId {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"publicStreamId"] = publicStreamId;
    [self emitEvent:dict methodName:@"onFirstPublicStreamAudioFrame"];
}

- (void)rtcEngine:(ByteRTCVideo * )engine onCloudProxyConnected:(NSInteger)interval {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"interval"] = @(interval);
    [self emitEvent:dict methodName:@"onCloudProxyConnected"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onEchoTestResult:(ByteRTCEchoTestResult)result {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"result"] = @(result);
    [self emitEvent:dict methodName:@"onEchoTestResult"];
}

- (void)rtcEngineOnNetworkTimeSynchronized:(ByteRTCVideo *)engine {
    [self emitEvent:nil methodName:@"onNetworkTimeSynchronized"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onLicenseWillExpire:(NSInteger)days {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"days"] = @(days);
    [self emitEvent:dict methodName:@"onLicenseWillExpire"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onInvokeExperimentalAPI:(NSString *)param {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"param"] = param;
    [self emitEvent:dict methodName:@"onInvokeExperimentalAPI"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onHardwareEchoDetectionResult:(ByteRTCHardwareEchoDetectionResult)result {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"result"] = @(result);
    [self emitEvent:dict methodName:@"onHardwareEchoDetectionResult"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onLocalProxyStateChanged:(ByteRTCLocalProxyType)type withProxyState:(ByteRTCLocalProxyState)state withProxyError:(ByteRTCLocalProxyError)error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"localProxyType"] = @(type);
    dict[@"localProxyState"] = @(state);
    dict[@"localProxyError"] = @(error);
    [self emitEvent:dict methodName:@"onLocalProxyStateChanged"];
}

@end
