/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterRoomEventHandler.h"
#import "ByteRTCFlutterMapCategory.h"

@interface ByteRTCFlutterRoomEventHandler ()

@property (nonatomic, assign) BOOL enableRoomStats;

@property (nonatomic, assign) BOOL enableLocalStreamStats;

@property (nonatomic, assign) BOOL enableRemoteStreamStats;

@property (nonatomic, assign) BOOL enableNetworkQualityStats;

@end

@implementation ByteRTCFlutterRoomEventHandler

#pragma mark -

- (void)handleSwitches:(NSDictionary *)arguments result:(FlutterResult)result {
    [arguments enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        if ([[self valueForKey:key] isKindOfClass:[value class]]) {
            [self setValue:value forKey:key];
        }
    }];
    result(nil);
}

#pragma mark - ByteRTCRoomDelegate

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onRoomStateChanged:(NSString *)roomId withUid:(NSString *)uid state:(NSInteger)state extraInfo:(NSString *)extraInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"uid"] = uid;
    dict[@"state"] = @(state);
    dict[@"extraInfo"] = extraInfo;
    [self emitEvent:dict methodName:@"onRoomStateChanged"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onStreamStateChanged:(NSString *)roomId withUid:(NSString *)uid state:(NSInteger)state extraInfo:(NSString *)extraInfo {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"roomId"] = roomId;
    dict[@"uid"] = uid;
    dict[@"state"] = @(state);
    dict[@"extraInfo"] = extraInfo;
    [self emitEvent:dict methodName:@"onStreamStateChanged"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onLeaveRoom:(ByteRTCRoomStats *)stats {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"stats"] = stats.bf_toMap;
    [self emitEvent:dict methodName:@"onLeaveRoom"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onAVSyncStateChange:(ByteRTCAVSyncState)state {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"state"] = @(state);
    [self emitEvent:dict methodName:@"onAVSyncStateChange"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onRoomStats:(ByteRTCRoomStats *)stats {
    if (!self.enableRoomStats) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"stats"] = stats.bf_toMap;
    [self emitEvent:dict methodName:@"onRoomStats"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onLocalStreamStats:(ByteRTCLocalStreamStats *)stats {
    if (!self.enableLocalStreamStats) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"stats"] = stats.bf_toMap;
    [self emitEvent:dict methodName:@"onLocalStreamStats"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onRemoteStreamStats:(ByteRTCRemoteStreamStats *)stats {
    if (!self.enableRemoteStreamStats) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"stats"] = stats.bf_toMap;
    [self emitEvent:dict methodName:@"onRemoteStreamStats"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onUserJoined:(ByteRTCUserInfo *)userInfo elapsed:(NSInteger)elapsed {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
    userDict[@"uid"] = userInfo.userId;
    userDict[@"metaData"] = userInfo.extraInfo;
    dict[@"userInfo"] = userDict;
    dict[@"elapsed"] = @(elapsed);
    [self emitEvent:dict methodName:@"onUserJoined"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onUserLeave:(NSString *)uid reason:(ByteRTCUserOfflineReason)reason {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = uid;
    dict[@"reason"] = @(reason);
    [self emitEvent:dict methodName:@"onUserLeave"];
}

- (void)onTokenWillExpire:(ByteRTCRoom *)rtcRoom {
    [self emitEvent:nil methodName:@"onTokenWillExpire"];
}

- (void)onPublishPrivilegeTokenWillExpire:(ByteRTCRoom *)rtcRoom {
    [self emitEvent:nil methodName:@"onPublishPrivilegeTokenWillExpire"];
}

- (void)onSubscribePrivilegeTokenWillExpire:(ByteRTCRoom *)rtcRoom {
    [self emitEvent:nil methodName:@"onSubscribePrivilegeTokenWillExpire"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onUserPublishStream:(NSString *)userId type:(ByteRTCMediaStreamType)type {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = userId;
    dict[@"type"] = @(type);
    [self emitEvent:dict methodName:@"onUserPublishStream"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onUserUnpublishStream:(NSString *)userId type:(ByteRTCMediaStreamType)type reason:(ByteRTCStreamRemoveReason)reason {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = userId;
    dict[@"type"] = @(type);
    dict[@"reason"] = @(reason);
    [self emitEvent:dict methodName:@"onUserUnpublishStream"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onUserPublishScreen:(NSString *)userId type:(ByteRTCMediaStreamType)type {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = userId;
    dict[@"type"] = @(type);
    [self emitEvent:dict methodName:@"onUserPublishScreen"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onUserUnpublishScreen:(NSString *)userId type:(ByteRTCMediaStreamType)type reason:(ByteRTCStreamRemoveReason)reason {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = userId;
    dict[@"type"] = @(type);
    dict[@"reason"] = @(reason);
    [self emitEvent:dict methodName:@"onUserUnpublishScreen"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onStreamSubscribed:(ByteRTCSubscribeState)state userId:(NSString *)userId subscribeConfig:(ByteRTCSubscribeConfig *)info {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"stateCode"] = @(state);
    dict[@"uid"] = userId;
    dict[@"info"] = info.bf_toMap;
    [self emitEvent:dict methodName:@"onStreamSubscribed"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onRoomMessageReceived:(NSString *)uid
        message:(NSString *)message {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = uid;
    dict[@"message"] = message;
    [self emitEvent:dict methodName:@"onRoomMessageReceived"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onRoomBinaryMessageReceived:(NSString *)uid
        message:(NSData *)message {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = uid;
    dict[@"message"] = [FlutterStandardTypedData typedDataWithBytes:message];
    [self emitEvent:dict methodName:@"onRoomBinaryMessageReceived"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onUserMessageReceived:(NSString *)uid
        message:(NSString *)message {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = uid;
    dict[@"message"] = message;
    [self emitEvent:dict methodName:@"onUserMessageReceived"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onUserBinaryMessageReceived:(NSString *)uid
        message:(NSData *)message {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = uid;
    dict[@"message"] = [FlutterStandardTypedData typedDataWithBytes:message];
    [self emitEvent:dict methodName:@"onUserBinaryMessageReceived"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onUserMessageSendResult:(NSInteger)msgid error:(ByteRTCUserMessageSendResult)error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"msgid"] = @(msgid);
    dict[@"error"] = @(error);
    [self emitEvent:dict methodName:@"onUserMessageSendResult"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onRoomMessageSendResult:(NSInteger)msgid error:(ByteRTCRoomMessageSendResult)error {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"msgid"] = @(msgid);
    dict[@"error"] = @(error);
    [self emitEvent:dict methodName:@"onRoomMessageSendResult"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onVideoStreamBanned:(NSString *)uid isBanned:(BOOL)banned {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = uid;
    dict[@"banned"] = @(banned);
    [self emitEvent:dict methodName:@"onVideoStreamBanned"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onAudioStreamBanned:(NSString *)uid isBanned:(BOOL)banned {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = uid;
    dict[@"banned"] = @(banned);
    [self emitEvent:dict methodName:@"onAudioStreamBanned"];
}

#pragma mark ForwardStream related callback

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onForwardStreamStateChanged:(NSArray<ForwardStreamStateInfo *> *)infos {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *infoDics = [NSMutableArray array];
    for (ForwardStreamStateInfo *info in infos) {
        [infoDics addObject:info.bf_toMap];
    }
    dict[@"stateInfos"] = infoDics.copy;
    [self emitEvent:dict methodName:@"onForwardStreamStateChanged"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onForwardStreamEvent:(NSArray<ForwardStreamEventInfo *> *)infos {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *infoDics = [NSMutableArray array];
    for (ForwardStreamEventInfo *info in infos) {
        [infoDics addObject:info.bf_toMap];
    }
    dict[@"eventInfos"] = infoDics.copy;
    [self emitEvent:dict methodName:@"onForwardStreamEvent"];
}

- (void)rtcRoom:(ByteRTCRoom *)rtcRoom onNetworkQuality:(ByteRTCNetworkQualityStats *)localQuality remoteQualities:(NSArray<ByteRTCNetworkQualityStats *> *)remoteQualities {
    if (!self.enableNetworkQualityStats) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *qualityDics = [NSMutableArray array];
    for (ByteRTCNetworkQualityStats *quality in remoteQualities) {
        [qualityDics addObject:[ByteRTCFlutterEventfactory networkQualityStatsToMap:quality]];
    }
    dict[@"localQuality"] = [ByteRTCFlutterEventfactory networkQualityStatsToMap:localQuality];
    dict[@"remoteQualities"] = qualityDics.copy;
    [self emitEvent:dict methodName:@"onNetworkQuality"];
}

@end
