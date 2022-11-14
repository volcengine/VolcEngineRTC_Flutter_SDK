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

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine onWarning:(ByteRTCWarningCode)Code {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"code"] = @(Code);
    [self emitEvent:dict methodName:@"onWarning"];
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine onError:(ByteRTCErrorCode)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"code"] = @(errorCode);
    [self emitEvent:dict methodName:@"onError"];
}

- (void)rtcEngine:(ByteRTCVideo *)engine onCreateRoomStateChanged:(NSString *)roomId errorCode:(NSInteger)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"errorCode"] = @(errorCode);
    [self emitEvent:dict methodName:@"onCreateRoomStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine connectionChangedToState:(ByteRTCConnectionState)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onConnectionStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine networkTypeChangedToType:(ByteRTCNetworkType)type {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"type"] = @(type);
    [self emitEvent:dict methodName:@"onNetworkTypeChanged"];
}

#pragma mark - Core Audio Delegate Methods

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onUserStartAudioCapture:(NSString* _Nonnull)roomId
              uid:(NSString *_Nonnull)userId {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"uid"] = userId;
    [self emitEvent:dict methodName:@"onUserStartAudioCapture"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onUserStopAudioCapture:(NSString* _Nonnull)roomId
              uid:(NSString *_Nonnull)userId {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"uid"] = userId;
    [self emitEvent:dict methodName:@"onUserStopAudioCapture"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onFirstRemoteAudioFrame:(ByteRTCRemoteStreamKey * _Nonnull)key {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = key.bf_toMap;
    [self emitEvent:dict methodName:@"onFirstRemoteAudioFrame"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onLocalAudioPropertiesReport:(NSArray<ByteRTCLocalAudioPropertiesInfo *> * _Nonnull)audioPropertiesInfos {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *infos = [NSMutableArray array];
    for (ByteRTCLocalAudioPropertiesInfo *info in audioPropertiesInfos) {
        [infos addObject:info.bf_toMap];
    }
    dict[@"infos"] = infos;
    [self emitEvent:dict methodName:@"onLocalAudioPropertiesReport"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onRemoteAudioPropertiesReport:(NSArray<ByteRTCRemoteAudioPropertiesInfo *> * _Nonnull)audioPropertiesInfos totalRemoteVolume:(NSInteger)totalRemoteVolume {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *infos = [NSMutableArray array];
    for (ByteRTCRemoteAudioPropertiesInfo *info in audioPropertiesInfos) {
        [infos addObject:info.bf_toMap];
    }
    dict[@"infos"] = infos;
    dict[@"totalRemoteVolume"] = @(totalRemoteVolume);
    [self emitEvent:dict methodName:@"onRemoteAudioPropertiesReport"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onActiveSpeaker:(NSString * _Nonnull)roomId uid:(NSString *_Nonnull)uid {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"uid"] = uid;
    [self emitEvent:dict methodName:@"onActiveSpeaker"];
}

#pragma mark - Core Video Delegate Methods

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onUserStartVideoCapture:(NSString * _Nonnull)roomId
              uid:(NSString * _Nonnull)uid {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"uid"] = uid;
    [self emitEvent:dict methodName:@"onUserStartVideoCapture"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onUserStopVideoCapture:(NSString * _Nonnull)roomId
              uid:(NSString * _Nonnull)uid {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"uid"] = uid;
    [self emitEvent:dict methodName:@"onUserStopVideoCapture"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onFirstLocalVideoFrameCaptured:(ByteRTCStreamIndex)streamIndex withFrameInfo:(ByteRTCVideoFrameInfo * _Nonnull)frameInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"index"] = @(streamIndex);
    dict[@"videoFrame"] = frameInfo.bf_toMap;
    [self emitEvent:dict methodName:@"onFirstLocalVideoFrameCaptured"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onFirstRemoteVideoFrameRendered:(ByteRTCRemoteStreamKey * _Nonnull)streamKey withFrameInfo:(ByteRTCVideoFrameInfo * _Nonnull)frameInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = streamKey.bf_toMap;
    dict[@"videoFrame"] = frameInfo.bf_toMap;
    [self emitEvent:dict methodName:@"onFirstRemoteVideoFrameRendered"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onFirstRemoteVideoFrameDecoded:(ByteRTCRemoteStreamKey * _Nonnull)streamKey withFrameInfo:(ByteRTCVideoFrameInfo * _Nonnull)frameInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = streamKey.bf_toMap;
    dict[@"videoFrame"] = frameInfo.bf_toMap;
    [self emitEvent:dict methodName:@"onFirstRemoteVideoFrameDecoded"];
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine onRemoteVideoSizeChanged:(ByteRTCRemoteStreamKey *_Nonnull)streamKey withFrameInfo:(ByteRTCVideoFrameInfo *_Nonnull)frameInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = streamKey.bf_toMap;
    dict[@"videoFrame"] = frameInfo.bf_toMap;
    [self emitEvent:dict methodName:@"onRemoteVideoSizeChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine onLocalVideoSizeChanged:(ByteRTCStreamIndex)streamIndex withFrameInfo:(ByteRTCVideoFrameInfo *_Nonnull)frameInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"index"] = @(streamIndex);
    dict[@"videoFrame"] = frameInfo.bf_toMap;
    [self emitEvent:dict methodName:@"onLocalVideoSizeChanged"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onAudioDeviceStateChanged:(NSString*_Nonnull)device_id
      device_type:(ByteRTCAudioDeviceType)device_type
     device_state:(ByteRTCMediaDeviceState)device_state
     device_error:(ByteRTCMediaDeviceError)device_error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"deviceId"] = device_id;
    dict[@"deviceType"] = @(device_type);
    dict[@"deviceState"] = @(device_state);
    dict[@"deviceError"] = @(device_error);
    [self emitEvent:dict methodName:@"onAudioDeviceStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onVideoDeviceStateChanged:(NSString*_Nonnull)device_id
      device_type:(ByteRTCVideoDeviceType)device_type
     device_state:(ByteRTCMediaDeviceState)device_state
     device_error:(ByteRTCMediaDeviceError)device_error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"deviceId"] = device_id;
    dict[@"deviceType"] = @(device_type);
    dict[@"deviceState"] = @(device_state);
    dict[@"deviceError"] = @(device_error);
    [self emitEvent:dict methodName:@"onVideoDeviceStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onAudioDeviceWarning:(NSString*_Nonnull)deviceId
       deviceType:(ByteRTCAudioDeviceType)deviceType
    deviceWarning:(ByteRTCMediaDeviceWarning)deviceWarning {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"deviceId"] = deviceId;
    dict[@"deviceType"] = @(deviceType);
    dict[@"deviceWarning"] = @(deviceWarning);
    [self emitEvent:dict methodName:@"onAudioDeviceWarning"];
    
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onVideoDeviceWarning:(NSString*_Nonnull)deviceId
       deviceType:(ByteRTCVideoDeviceType)deviceType
    deviceWarning:(ByteRTCMediaDeviceWarning)deviceWarning {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"deviceId"] = deviceId;
    dict[@"deviceType"] = @(deviceType);
    dict[@"deviceWarning"] = @(deviceWarning);
    [self emitEvent:dict methodName:@"onVideoDeviceWarning"];
    
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine onAudioFrameSendStateChanged:(NSString * _Nonnull)roomId
          rtcUser:(ByteRTCUser *_Nonnull)user state:(ByteRTCFirstFrameSendState)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"userInfo"] = user.bf_toMap;
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onAudioFrameSendStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine onVideoFrameSendStateChanged:(NSString * _Nonnull)roomId
          rtcUser:(ByteRTCUser *_Nonnull)user state:(ByteRTCFirstFrameSendState)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"userInfo"] = user.bf_toMap;
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onVideoFrameSendStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine onScreenVideoFrameSendStateChanged:(NSString * _Nonnull)roomId rtcUser:(ByteRTCUser *_Nonnull)user state:(ByteRTCFirstFrameSendState)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"userInfo"] = user.bf_toMap;
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onScreenVideoFrameSendStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine onAudioFramePlayStateChanged:(NSString * _Nonnull)roomId
          rtcUser:(ByteRTCUser *_Nonnull)user state:(ByteRTCFirstFramePlayState)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"userInfo"] = user.bf_toMap;
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onAudioFramePlayStateChanged"];
}


- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine onVideoFramePlayStateChanged:(NSString * _Nonnull)roomId
          rtcUser:(ByteRTCUser *_Nonnull)user state:(ByteRTCFirstFramePlayState)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"userInfo"] = user.bf_toMap;
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onVideoFramePlayStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine onScreenVideoFramePlayStateChanged:(NSString * _Nonnull)roomId rtcUser:(ByteRTCUser *_Nonnull)user state:(ByteRTCFirstFramePlayState)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"userInfo"] = user.bf_toMap;
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onScreenVideoFramePlayStateChanged"];
}

#pragma mark - Media Stream Delegate Methods

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onFirstLocalAudioFrame:(ByteRTCStreamIndex)streamIndex {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"index"] = @(streamIndex);
    [self emitEvent:dict methodName:@"onFirstLocalAudioFrame"];
}


#pragma mark - Media Device Delegate Methods

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine onAudioRouteChanged:(ByteRTCAudioRoute)route {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"route"] = @(route);
    [self emitEvent:dict methodName:@"onAudioRouteChanged"];
}

#pragma mark custom message Delegate Methods

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onSEIMessageReceived:(ByteRTCRemoteStreamKey* _Nonnull)remoteStreamKey andMessage:(NSData* _Nonnull)message {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = remoteStreamKey.bf_toMap;
    dict[@"message"] = [FlutterStandardTypedData typedDataWithBytes:message];
    [self emitEvent:dict methodName:@"onSEIMessageReceived"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onSEIStreamUpdate:(ByteRTCRemoteStreamKey * _Nonnull)remoteStreamKey eventType:(ByteSEIStreamEventType)eventType {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = remoteStreamKey.bf_toMap;
    dict[@"event"] = @(eventType);
    [self emitEvent:dict methodName:@"onSEIStreamUpdate"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onStreamSyncInfoReceived:(ByteRTCRemoteStreamKey* _Nonnull)remoteStreamKey streamType:(ByteRTCSyncInfoStreamType)streamType data:(NSData* _Nonnull)data {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = remoteStreamKey.bf_toMap;
    dict[@"streamType"] = @(streamType);
    dict[@"data"] = [FlutterStandardTypedData typedDataWithBytes:data];
    [self emitEvent:dict methodName:@"onStreamSyncInfoReceived"];
}

#pragma mark - Statistics Delegate Methods

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine reportSysStats:(const ByteRTCSysStats * _Nonnull)stats {
    if (!self.enableSysStats) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"stats"] = stats.bf_toMap;
    [self emitEvent:dict methodName:@"onSysStats"];
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine
onLocalAudioStateChanged:(ByteRTCLocalAudioStreamState)state
            error:(ByteRTCLocalAudioStreamError)error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"state"] = @(state);
    dict[@"error"] = @(error);
    [self emitEvent:dict methodName:@"onLocalAudioStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine
onRemoteAudioStateChanged:(ByteRTCRemoteStreamKey * _Nonnull)key
            state:(ByteRTCRemoteAudioState)state
           reason:(ByteRTCRemoteAudioStateChangeReason)reason {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = key.bf_toMap;
    dict[@"state"] = @(state);
    dict[@"reason"] = @(reason);
    [self emitEvent:dict methodName:@"onRemoteAudioStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine
onLocalVideoStateChanged:(ByteRTCStreamIndex)streamIndex
  withStreamState:(ByteRTCLocalVideoStreamState)state
  withStreamError:(ByteRTCLocalVideoStreamError)error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"index"] = @(streamIndex);
    dict[@"state"] = @(state);
    dict[@"error"] = @(error);
    [self emitEvent:dict methodName:@"onLocalVideoStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine
onRemoteVideoStateChanged:(ByteRTCRemoteStreamKey*_Nonnull)streamKey
   withVideoState:(ByteRTCRemoteVideoState)state
withVideoStateReason:(ByteRTCRemoteVideoStateChangeReason)reason {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"streamKey"] = streamKey.bf_toMap;
    dict[@"state"] = @(state);
    dict[@"reason"] = @(reason);
    [self emitEvent:dict methodName:@"onRemoteVideoStateChanged"];
}

#pragma mark - Rtm

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onLoginResult:(NSString * _Nonnull)uid errorCode:(ByteRTCLoginErrorCode)errorCode elapsed:(NSInteger)elapsed {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = uid;
    dict[@"errorCode"] = @(errorCode);
    dict[@"elapsed"] = @(elapsed);
    [self emitEvent:dict methodName:@"onLoginResult"];
}

- (void)rtcEngineOnLogout:(ByteRTCVideo * _Nonnull)engine {
    [self emitEvent:nil methodName:@"onLogout"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onServerParamsSetResult:(NSInteger)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"error"] = @(errorCode);
    [self emitEvent:dict methodName:@"onServerParamsSetResult"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onGetPeerOnlineStatus:(NSString * _Nonnull)peerUserId status:(ByteRTCUserOnlineStatus)status {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = peerUserId;
    dict[@"status"] = @(status);
    [self emitEvent:dict methodName:@"onGetPeerOnlineStatus"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onUserMessageReceivedOutsideRoom:(NSString * _Nonnull)uid message:(NSString * _Nonnull)message {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = uid;
    dict[@"message"] = message;
    [self emitEvent:dict methodName:@"onUserMessageReceivedOutsideRoom"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onUserBinaryMessageReceivedOutsideRoom:(NSString * _Nonnull)uid message:(NSData * _Nonnull)message {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = uid;
    dict[@"message"] = [FlutterStandardTypedData typedDataWithBytes:message];
    [self emitEvent:dict methodName:@"onUserBinaryMessageReceivedOutsideRoom"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onUserMessageSendResultOutsideRoom:(int64_t)msgid error:(ByteRTCUserMessageSendResult)error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"msgid"] = @(msgid);
    dict[@"error"] = @(error);
    [self emitEvent:dict methodName:@"onUserMessageSendResultOutsideRoom"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onServerMessageSendResult:(int64_t)msgid error:(ByteRTCUserMessageSendResult)error message:(NSData * _Nonnull)message {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"msgid"] = @(msgid);
    dict[@"error"] = @(error);
    dict[@"message"] = [FlutterStandardTypedData typedDataWithBytes:message];
    [self emitEvent:dict methodName:@"onServerMessageSendResult"];
}

#pragma mark - Network Probe Methods

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onNetworkDetectionResult:(ByteRTCNetworkDetectionLinkType)type quality:(ByteRTCNetworkQuality)quality rtt:(int)rtt lostRate:(double)lost_rate bitrate:(int)bitrate jitter:(int)jitter{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"type"] = @(type);
    dict[@"quality"] = @(quality);
    dict[@"rtt"] = @(rtt);
    dict[@"lostRate"] = @(lost_rate);
    dict[@"bitrate"] = @(bitrate);
    dict[@"jitter"] = @(jitter);
    [self emitEvent:dict methodName:@"onNetworkDetectionResult"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onNetworkDetectionStopped:(ByteRTCNetworkDetectionStopReason)err_code {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"reason"] = @(err_code);
    [self emitEvent:dict methodName:@"onNetworkDetectionStopped"];
}

#pragma mark Audio Mix Delegate Methods

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine
onAudioMixingStateChanged:(NSInteger)mixId state:(ByteRTCAudioMixingState)state error:(ByteRTCAudioMixingError)error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mixId"] = @(mixId);
    dict[@"state"] = @(state);
    dict[@"error"] = @(error);
    [self emitEvent:dict methodName:@"onAudioMixingStateChanged"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine
onAudioMixingPlayingProgress:(NSInteger)mixId progress:(int64_t)progress {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mixId"] = @(mixId);
    dict[@"progress"] = @(progress);
    [self emitEvent:dict methodName:@"onAudioMixingPlayingProgress"];
}

#pragma mark Performance Delegate Methods

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine
onPerformanceAlarmsWithMode:(ByteRTCPerformanceAlarmMode)mode
           roomId:(NSString *_Nonnull)roomId
           reason:(ByteRTCPerformanceAlarmReason)reason
 sourceWantedData:(ByteRTCSourceWantedData *_Nonnull)data {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"mode"] = @(mode);
    dict[@"roomId"] = roomId;
    dict[@"reason"] = @(reason);
    dict[@"data"] = data.bf_toMap;
    [self emitEvent:dict methodName:@"onPerformanceAlarms"];
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine OnSimulcastSubscribeFallback:(ByteRTCRemoteStreamSwitchEvent *_Nonnull)event {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"event"] = event.bf_toMap;
    [self emitEvent:dict methodName:@"onSimulcastSubscribeFallback"];
}

#pragma mark Proxy Delegate Methods

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine onHttpProxyState:(NSInteger)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onHttpProxyState"];
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine onHttpsProxyState:(NSInteger)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onHttpsProxyState"];
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine
onSocks5ProxyState:(NSInteger)state
              cmd:(NSString *_Nonnull)cmd
    proxy_address:(NSString *_Nonnull)proxy_address
    local_address:(NSString *_Nonnull)local_address
   remote_address:(NSString *_Nonnull)remote_address {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"state"] = @(state);
    dict[@"cmd"] = cmd;
    dict[@"proxyAddress"] = proxy_address;
    dict[@"localAddress"] = local_address;
    dict[@"remoteAddress"] = remote_address;
    [self emitEvent:dict methodName:@"onSocks5ProxyState"];
}

#pragma mark FileRecording related callback

- (void)rtcEngine:(ByteRTCVideo* _Nonnull)engine
onRecordingStateUpdate:(ByteRTCStreamIndex)type
            state:(ByteRTCRecordingState)state
       error_code:(ByteRTCRecordingErrorCode)error_code
   recording_info:(ByteRTCRecordingInfo* _Nonnull)recording_info{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"state"] = @(state);
    dict[@"type"] = @(type);
    dict[@"errorCode"] = @(error_code);
    dict[@"info"] = recording_info.bf_toMap;
    [self emitEvent:dict methodName:@"onRecordingStateUpdate"];
}

- (void)rtcEngine:(ByteRTCVideo* _Nonnull)engine
onRecordingProgressUpdate:(ByteRTCStreamIndex)type
          process:(ByteRTCRecordingProgress* _Nonnull)process
   recording_info:(ByteRTCRecordingInfo* _Nonnull)recording_info {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"type"] = @(type);
    dict[@"progress"] = process.bf_toMap;
    dict[@"info"] = recording_info.bf_toMap;
    [self emitEvent:dict methodName:@"onRecordingProgressUpdate"];
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine
onPushPublicStreamResult:(NSString *_Nonnull)roomId
  publiscStreamId:(NSString *_Nonnull)publicStreamId
        errorCode:(ByteRTCPublicStreamErrorCode)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"publicStreamId"] = publicStreamId;
    dict[@"errorCode"] = @(errorCode);
    [self emitEvent:dict methodName:@"onPushPublicStreamResult"];
}

- (void)rtcEngine:(ByteRTCVideo *_Nonnull)engine
onPlayPublicStreamResult:(NSString *_Nonnull)publicStreamId
        errorCode:(ByteRTCPublicStreamErrorCode)errorCode {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"publicStreamId"] = publicStreamId;
    dict[@"errorCode"] = @(errorCode);
    [self emitEvent:dict methodName:@"onPlayPublicStreamResult"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onPublicStreamSEIMessageReceived:(NSString* _Nonnull)publicStreamId andMessage:(NSData* _Nonnull)message {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"publicStreamId"] = publicStreamId;
    dict[@"message"] = [FlutterStandardTypedData typedDataWithBytes:message];
    [self emitEvent:dict methodName:@"onPublicStreamSEIMessageReceived"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onFirstPublicStreamVideoFrameDecoded:(NSString * _Nonnull)publicStreamId withFrameInfo:(ByteRTCVideoFrameInfo * _Nonnull)frameInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"publicStreamId"] = publicStreamId;
    dict[@"videoFrame"] = frameInfo.bf_toMap;
    [self emitEvent:dict methodName:@"onFirstPublicStreamVideoFrameDecoded"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onFirstPublicStreamAudioFrame:(NSString * _Nonnull)publicStreamId {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"publicStreamId"] = publicStreamId;
    [self emitEvent:dict methodName:@"onFirstPublicStreamAudioFrame"];
}

- (void)rtcEngine:(ByteRTCVideo *  _Nonnull)engine onCloudProxyConnected:(NSInteger)interval {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"interval"] = @(interval);
    [self emitEvent:dict methodName:@"onCloudProxyConnected"];
}

- (void)rtcEngine:(ByteRTCVideo * _Nonnull)engine onEchoTestResult:(ByteRTCEchoTestResult)result {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"result"] = @(result);
    [self emitEvent:dict methodName:@"onEchoTestResult"];
}

@end
