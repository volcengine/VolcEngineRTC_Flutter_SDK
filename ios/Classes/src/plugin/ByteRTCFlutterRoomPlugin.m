/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/ByteRTCRoom.h>
#import "ByteRTCFlutterRoomPlugin.h"
#import "ByteRTCFlutterMapCategory.h"
#import "ByteRTCFlutterRoomEventHandler.h"
#import "ByteRTCFlutterRangeAudioPlugin.h"
#import "ByteRTCFlutterSpatialAudioPlugin.h"

@interface ByteRTCFlutterRoomPlugin ()

@property (nonatomic, assign) NSInteger insId;
@property (nonatomic, strong) ByteRTCRoom *room;
@property (nonatomic, strong) NSMutableArray<ByteRTCFlutterPlugin *> *flutterPlugins;
@property (nonatomic, strong) ByteRTCFlutterRoomEventHandler *eventHandler;

@end

@implementation ByteRTCFlutterRoomPlugin

+ (instancetype)createWithRTCRoom:(ByteRTCRoom *)rtcRoom roomInsId:(NSInteger)roomInsId {
    return [[self alloc] initWithRTCRoom:rtcRoom roomInsId:roomInsId];
}

- (instancetype)initWithRTCRoom:(ByteRTCRoom *)rtcRoom roomInsId:(NSInteger)roomInsId {
    self = [super init];
    if (self) {
        self.insId = roomInsId;
        self.room = rtcRoom;
        self.flutterPlugins = [NSMutableArray array];
        self.eventHandler = [[ByteRTCFlutterRoomEventHandler alloc] init];
        [rtcRoom setRTCRoomDelegate:self.eventHandler];
        [self.flutterPlugins addObject:[[ByteRTCFlutterRangeAudioPlugin alloc] initWithRTCRoom:rtcRoom
                                                                                         insId:roomInsId]];
        [self.flutterPlugins addObject:[[ByteRTCFlutterSpatialAudioPlugin alloc] initWithRTCRoom:rtcRoom
                                                                                           insId:roomInsId]];
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [super registerWithRegistrar:registrar];
    
    [self.flutterPlugins enumerateObjectsUsingBlock:^(ByteRTCFlutterPlugin *obj, NSUInteger idx, BOOL *stop) {
        [obj registerWithRegistrar:registrar];
    }];
    
    NSString *methodChannelName = [NSString stringWithFormat:@"com.bytedance.ve_rtc_room%ld",
                                   (long)self.insId];
    [self.methodHandler registerMethodChannelWithName:methodChannelName
                                         methodTarget:self
                                      binaryMessenger:[registrar messenger]];
    NSString *eventChannelName = [NSString stringWithFormat:@"com.bytedance.ve_rtc_room_event%ld",
                                  (long)self.insId];
    [self.eventHandler registerEventChannelWithName:eventChannelName
                                    binaryMessenger:[registrar messenger]];
}

- (void)destroy {
    [super destroy];
    [self.flutterPlugins enumerateObjectsUsingBlock:^(ByteRTCFlutterPlugin *obj, NSUInteger idx, BOOL *stop) {
        [obj destroy];
    }];
    [self.room destroy];
    [self.eventHandler destroy];
}

#pragma mark - method
- (void)eventHandlerSwitches:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.eventHandler handleSwitches:arguments result:result];
}

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
    int res = [self.room joinRoom:token userInfo:user roomConfig:roomConfig];
    result(@(res));
}

- (void)setUserVisibility:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL enable = [arguments[@"enable"] boolValue];
    int res = [self.room setUserVisibility:enable];
    result(@(res));
}

- (void)setMultiDeviceAVSync:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *audioUserId = arguments[@"audioUid"];
    int res = [self.room setMultiDeviceAVSync:audioUserId];
    result(@(res));
}

- (void)leaveRoom:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.room leaveRoom];
    result(@(res));
}

- (void)updateToken:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *token = arguments[@"token"];
    int res = [self.room updateToken:token];
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
    int res = [self.room subscribeStream:userId
                         mediaStreamType:mediaStreamType];
    result(@(res));
}

- (void)subscribeAllStreams:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCMediaStreamType mediaStreamType = [arguments[@"type"] integerValue];
    int res = [self.room subscribeAllStreamsWithMediaStreamType:mediaStreamType];
    result(@(res));
}

- (void)unsubscribeStream:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *userId = arguments[@"uid"];
    ByteRTCMediaStreamType mediaStreamType = [arguments[@"type"] integerValue];
    int res = [self.room unsubscribeStream:userId
                           mediaStreamType:mediaStreamType];
    result(@(res));
}

- (void)unsubscribeAllStreams:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCMediaStreamType mediaStreamType = [arguments[@"type"] integerValue];
    int res = [self.room unsubscribeAllStreamsWithMediaStreamType:mediaStreamType];
    result(@(res));
}

- (void)subscribeScreen:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *userId = arguments[@"uid"];
    ByteRTCMediaStreamType mediaStreamType = [arguments[@"type"] integerValue];
    int res = [self.room subscribeScreen:userId
                         mediaStreamType:mediaStreamType];
    result(@(res));
}

- (void)unsubscribeScreen:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *userId = arguments[@"uid"];
    ByteRTCMediaStreamType mediaStreamType = [arguments[@"type"] integerValue];
    int res = [self.room unsubscribeScreen:userId
                           mediaStreamType:mediaStreamType];
    result(@(res));
}

- (void)pauseAllSubscribedStream:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCPauseResumControlMediaType mediaType = [arguments[@"mediaType"] integerValue];
    int res = [self.room pauseAllSubscribedStream:mediaType];
    result(@(res));
}

- (void)resumeAllSubscribedStream:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCPauseResumControlMediaType mediaType = [arguments[@"mediaType"] integerValue];
    int res = [self.room resumeAllSubscribedStream:mediaType];
    result(@(res));
}

- (void)sendUserMessage:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *uid = arguments[@"uid"];
    NSString *message = arguments[@"message"];
    ByteRTCMessageConfig config = [arguments[@"config"] integerValue];
    NSInteger res = [self.room sendUserMessage:uid message:message config:config];
    result(@(res));
}

- (void)sendUserBinaryMessage:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *uid = arguments[@"uid"];
    FlutterStandardTypedData *message = arguments[@"message"];
    ByteRTCMessageConfig config = [arguments[@"config"] integerValue];
    NSInteger res = [self.room sendUserBinaryMessage:uid message:message.data config:config];
    result(@(res));
}

- (void)sendRoomMessage:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *message = arguments[@"message"];
    NSInteger res = [self.room sendRoomMessage:message];
    result(@(res));
}

- (void)sendRoomBinaryMessage:(NSDictionary *)arguments result:(FlutterResult)result {
    FlutterStandardTypedData *message = arguments[@"message"];
    NSInteger res = [self.room sendRoomBinaryMessage:message.data];
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
    int res = [self.room stopForwardStreamToRooms];
    result(@(res));
}

- (void)pauseForwardStreamToAllRooms:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.room pauseForwardStreamToAllRooms];
    result(@(res));
}

- (void)resumeForwardStreamToAllRooms:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.room resumeForwardStreamToAllRooms];
    result(@(res));
}

- (void)setRemoteRoomAudioPlaybackVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    NSInteger volume = [arguments[@"volume"] integerValue];
    int res = [self.room setRemoteRoomAudioPlaybackVolume:volume];
    result(@(res));
}

- (void)setAudioSelectionConfig:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCAudioSelectionPriority audioSelectionPriority = [arguments[@"audioSelectionPriority"] integerValue];
    int res = [self.room setAudioSelectionConfig:audioSelectionPriority];
    result(@(res));
}

- (void)setRoomExtraInfo:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *key = arguments[@"key"];
    NSString *value = arguments[@"value"];
    NSInteger res = [self.room setRoomExtraInfo:key value:value];
    result(@(res));
}

- (void)startSubtitle:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCSubtitleConfig *subtitleConfig = [ByteRTCSubtitleConfig bf_fromMap:arguments[@"subtitleConfig"]];
    int res = [self.room startSubtitle:subtitleConfig];
    result(@(res));
}

- (void)stopSubtitle:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.room stopSubtitle];
    result(@(res));
}

@end
