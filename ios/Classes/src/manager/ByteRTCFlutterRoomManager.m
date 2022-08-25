/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/ByteRTCRoom.h>
#import <Flutter/Flutter.h>
#import "ByteRTCFlutterRoomManager.h"
#import "ByteRTCFlutterMapCategory.h"

@interface ByteRTCFlutterRoomManager ()

@property (nonatomic, strong) ByteRTCRoom *room;

@end

@implementation ByteRTCFlutterRoomManager

+ (instancetype)createWithRTCRoom:(ByteRTCRoom *)rtcRoom roomDelegate:(id<ByteRTCRoomDelegate>)delegate {
    ByteRTCFlutterRoomManager *this = [[ByteRTCFlutterRoomManager alloc] init];
    this.room = rtcRoom;
    [this.room setRtcRoomDelegate:delegate];
    return this;
}

- (ByteRTCRoom *)getRTCRoom {
    return self.room;
}

- (void)destroyEngine {
    [self.room destroy];
}

#pragma mark - method
- (void)joinRoom:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *token = arguments[@"token"];
    NSDictionary *userInfoDic = arguments[@"userInfo"];
    NSDictionary *roomDic = arguments[@"roomConfig"];
    ByteRTCUserInfo *user = [[ByteRTCUserInfo alloc]init];
    user.userId = userInfoDic[@"uid"];
    user.extraInfo = userInfoDic[@"metaData"];
    ByteRTCRoomConfig *roomConfig = [[ByteRTCRoomConfig alloc] init];
    roomConfig.profile = [roomDic[@"profile"] integerValue];
    roomConfig.isAutoPublish = [roomDic[@"isAutoPublish"] boolValue];
    roomConfig.isAutoSubscribeAudio = [roomDic[@"isAutoSubscribeAudio"] boolValue];
    roomConfig.isAutoSubscribeVideo = [roomDic[@"isAutoSubscribeVideo"] boolValue];
    roomConfig.remoteVideoConfig = [ByteRTCRemoteVideoConfig bf_fromMap:arguments[@"remoteVideoConfig"]];
    int res = [self.room joinRoomByToken:token userInfo:user roomConfig:roomConfig];
    result(@(res));
}

- (void)setUserVisibility:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL enable = [arguments[@"enable"] boolValue];
    int res = [self.room setUserVisibility:enable];
    result(@(res));
}

- (void)setMultiDeviceAVSync:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *audioUserId = arguments[@"audioUid"];
    int res = [self.room setMultiDeviceAVSync:audioUserId] ? 0 : -1;
    result(@(res));
}

- (void)leaveRoom:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.room leaveRoom];
    result(@(res));
}

- (void)updateToken:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *token = arguments[@"token"];
    int res = [self.room renewToken:token];
    result(@(res));
}

- (void)setRemoteVideoConfig:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *userId = arguments[@"uid"];
    ByteRTCRemoteVideoConfig *remoteVideoConfig = [ByteRTCRemoteVideoConfig bf_fromMap:arguments[@"videoConfig"]];
    int res = [self.room setRemoteVideoConfig:userId
                            remoteVideoConfig:remoteVideoConfig];
    result(@(res));
}

- (void)publishStream:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCMediaStreamType type = [arguments[@"type"] integerValue];
    int res = [self.room publishStream:type];
    result(@(res));
}

- (void)unpublishStream:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCMediaStreamType type = [arguments[@"type"] integerValue];
    int res = [self.room unpublishStream:type];
    result(@(res));
}

- (void)publishScreen:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCMediaStreamType type = [arguments[@"type"] integerValue];
    int res = [self.room publishScreen:type];
    result(@(res));
}

- (void)unpublishScreen:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCMediaStreamType type = [arguments[@"type"] integerValue];
    int res = [self.room unpublishScreen:type];
    result(@(res));
}

- (void)subscribeStream:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *userId = arguments[@"uid"];
    ByteRTCMediaStreamType mediaStreamType = [arguments[@"type"] integerValue];
    [self.room subscribeStream:userId
               mediaStreamType:mediaStreamType];
    result(nil);
}

- (void)unsubscribeStream:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *userId = arguments[@"uid"];
    ByteRTCMediaStreamType mediaStreamType = [arguments[@"type"] integerValue];
    [self.room unSubscribeStream:userId
                 mediaStreamType:mediaStreamType];
    result(nil);
}

- (void)subscribeScreen:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *userId = arguments[@"uid"];
    ByteRTCMediaStreamType mediaStreamType = [arguments[@"type"] integerValue];
    [self.room subscribeScreen:userId
               mediaStreamType:mediaStreamType];
    result(nil);
}

- (void)unsubscribeScreen:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *userId = arguments[@"uid"];
    ByteRTCMediaStreamType mediaStreamType = [arguments[@"type"] integerValue];
    [self.room unSubscribeScreen:userId
                 mediaStreamType:mediaStreamType];
    result(nil);
}

- (void)pauseAllSubscribedStream:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCPauseResumControlMediaType mediaType = [arguments[@"mediaType"] integerValue];
    [self.room pauseAllSubscribedStream:mediaType];
    result(nil);
}

- (void)resumeAllSubscribedStream:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCPauseResumControlMediaType mediaType = [arguments[@"mediaType"] integerValue];
    [self.room resumeAllSubscribedStream:mediaType];
    result(nil);
}

- (void)sendUserMessage:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *uid = arguments[@"uid"];
    NSString *message = arguments[@"message"];
    ByteRTCMessageConfig config = [arguments[@"config"] integerValue];
    int64_t res = [self.room sendUserMessage:uid message:message config:config];
    result(@(res));
}

- (void)sendUserBinaryMessage:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *uid = arguments[@"uid"];
    FlutterStandardTypedData *message = arguments[@"message"];
    ByteRTCMessageConfig config = [arguments[@"config"] integerValue];
    int64_t res = [self.room sendUserBinaryMessage:uid message:message.data config:config];
    result(@(res));
}

- (void)sendRoomMessage:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *message = arguments[@"message"];
    int64_t res = [self.room sendRoomMessage:message];
    result(@(res));
}

- (void)sendRoomBinaryMessage:(NSDictionary *)arguments result:(FlutterResult)result {
    FlutterStandardTypedData *message = arguments[@"message"];
    int64_t res = [self.room sendRoomBinaryMessage:message.data];
    result(@(res));
}

#pragma mark ForwardStream

- (void)startForwardStreamToRooms:(NSDictionary *)arguments result:(FlutterResult)result {
    NSMutableArray<ForwardStreamConfiguration *> *configurations = [NSMutableArray new];
    for (NSDictionary *dic in arguments[@"forwardStreamInfos"]) {
        ForwardStreamConfiguration *config = [ForwardStreamConfiguration bf_fromMap:dic];
        [configurations addObject:config];
    }
    int res = [self.room startForwardStreamToRooms:configurations];
    result(@(res));
}

- (void)updateForwardStreamToRooms:(NSDictionary *)arguments result:(FlutterResult)result {
    NSMutableArray<ForwardStreamConfiguration *> *configurations = [NSMutableArray new];
    for (NSDictionary *dic in arguments[@"forwardStreamInfos"]) {
        ForwardStreamConfiguration *config = [ForwardStreamConfiguration bf_fromMap:dic];
        [configurations addObject:config];
    }
    int res = [self.room updateForwardStreamToRooms:configurations];
    result(@(res));
}

- (void)stopForwardStreamToRooms:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.room stopForwardStreamToRooms];
    result(nil);
}

- (void)pauseForwardStreamToAllRooms:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.room pauseForwardStreamToAllRooms];
    result(nil);
}

- (void)resumeForwardStreamToAllRooms:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.room resumeForwardStreamToAllRooms];
    result(nil);
}

#pragma mark - CloudRendering

- (void)startCloudRendering:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *effectInfo = arguments[@"effectInfo"];
    int res = [self.room enableCloudRending:effectInfo];
    result(@(res));
}

- (void)updateCloudRendering:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *effectInfo = arguments[@"effectInfo"];
    int res = [self.room updateCloudRending:effectInfo];
    result(@(res));
}

- (void)stopCloudRendering:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.room disableCloudRending];
    result(@(res));
}

@end
