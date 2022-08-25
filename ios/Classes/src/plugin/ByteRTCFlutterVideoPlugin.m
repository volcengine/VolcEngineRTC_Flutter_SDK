/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Flutter/FlutterPlugin.h>
#import "ByteRTCFlutterVideoPlugin.h"
#import "ByteRTCFlutterRoomPlugin.h"
#import "ByteRTCFlutterAudioMixingPlugin.h"
#import "ByteRTCFlutterVideoManager.h"
#import "ByteRTCFlutterVideoEventHandler.h"
#import "ByteRTCFlutterASREventHandler.h"
#import "ByteRTCFlutterFaceDetectionHandler.h"
#import "ByteRTCFlutterLiveTranscodingObserver.h"
#import "ByteRTCFlutterPushSingleStreamToCDNObserver.h"

@interface ByteRTCFlutterVideoPlugin ()

@property (nonatomic, weak) NSObject<FlutterPluginRegistrar> *registrar;

@property (nonatomic, strong) ByteRTCFlutterAudioMixingPlugin *audioMixingPlugin;
@property (nonatomic, strong) NSMutableDictionary<NSNumber*, ByteRTCFlutterRoomPlugin*> *roomPlugins;
@property (nonatomic, strong) ByteRTCFlutterVideoManager *videoManager;
@property (nonatomic, strong) ByteRTCFlutterVideoEventHandler *eventHandler;
@property (nonatomic, strong) ByteRTCFlutterASREventHandler *asrEventHandler;
@property (nonatomic, strong) ByteRTCFlutterFaceDetectionHandler *faceDetectionHandler;
@property (nonatomic, strong) ByteRTCFlutterLiveTranscodingObserver *liveTranscodingObserver;
@property (nonatomic, strong) ByteRTCFlutterPushSingleStreamToCDNObserver *pushSingleStreamToCDNObserver;

@end


@implementation ByteRTCFlutterVideoPlugin

- (instancetype)init {
    self = [super init];
    if (self) {
        self.eventHandler = [[ByteRTCFlutterVideoEventHandler alloc] init];
        self.asrEventHandler = [[ByteRTCFlutterASREventHandler alloc] init];
        self.faceDetectionHandler = [[ByteRTCFlutterFaceDetectionHandler alloc] init];
        self.liveTranscodingObserver = [[ByteRTCFlutterLiveTranscodingObserver alloc] init];
        self.pushSingleStreamToCDNObserver = [[ByteRTCFlutterPushSingleStreamToCDNObserver alloc] init];
        self.videoManager = [[ByteRTCFlutterVideoManager alloc] init];
        self.videoManager.delegate = self.eventHandler;
        self.videoManager.asrEventDelegate = self.asrEventHandler;
        self.videoManager.faceDetectionObserver = self.faceDetectionHandler;
        self.videoManager.liveTranscodingDelegate = self.liveTranscodingObserver;
        self.videoManager.pushSingleStreamToCDNObserver = self.pushSingleStreamToCDNObserver;
        self.audioMixingPlugin = [[ByteRTCFlutterAudioMixingPlugin alloc] initWithVideoManager:self.videoManager];
        self.roomPlugins = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self.registrar = registrar;
    [self registerMethodChannelWithName:@"com.bytedance.ve_rtc_video"
                           methodTarget:self.videoManager
                        binaryMessenger:[registrar messenger]];
    [self.audioMixingPlugin registerWithRegistrar:registrar];
    
    [self.eventHandler registerEventChannelWithName:@"com.bytedance.ve_rtc_video_event"
                                    binaryMessenger:[self.registrar messenger]];
    [self.asrEventHandler registerEventChannelWithName:@"com.bytedance.ve_rtc_asr"
                                       binaryMessenger:[self.registrar messenger]];
    [self.faceDetectionHandler registerEventChannelWithName:@"com.bytedance.ve_rtc_face_detection"
                                            binaryMessenger:[self.registrar messenger]];
    [self.liveTranscodingObserver registerEventChannelWithName:@"com.bytedance.ve_rtc_live_transcoding"
                                               binaryMessenger:[self.registrar messenger]];
    [self.pushSingleStreamToCDNObserver registerEventChannelWithName:@"com.bytedance.ve_rtc_push_single_stream_to_cdn"
                                                     binaryMessenger:[self.registrar messenger]];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"createRTCRoom"]) {
        [self createRTCRoom:call.arguments result:result];
        return;
    } else if ([call.method isEqualToString:@"destroyRTCRoom"]) {
        [self destroyRTCRoom:call.arguments result:result];
        return;
    }if ([call.method isEqualToString:@"eventHandlerSwitches"]) {
        [self.eventHandler handleSwitches:call.arguments result:result];
        return;
    }
    [super handleMethodCall:call result:result];
}

- (void)destroy {
    [super destroy];
    [self.videoManager destroy];
    [self.roomPlugins enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, ByteRTCFlutterRoomPlugin *obj, BOOL *stop) {
        [obj destroy];
    }];
    [self.roomPlugins removeAllObjects];
    [self.eventHandler destroy];
    [self.asrEventHandler destroy];
    [self.faceDetectionHandler destroy];
    [self.liveTranscodingObserver destroy];
    [self.pushSingleStreamToCDNObserver destroy];
    [self.audioMixingPlugin destroy];
}

#pragma mark - method

- (void)createRTCRoom:(NSDictionary *)arguments result:(FlutterResult)result {
    NSNumber *insId = arguments[@"roomInsId"];
    NSString *roomId = arguments[@"roomId"];
    ByteRTCRoom *room = [self.videoManager createRTCRoom:roomId];
    if (room == nil) {
        result(@(NO));
        return;
    }
    ByteRTCFlutterRoomPlugin *roomPlugin = [ByteRTCFlutterRoomPlugin createWithRTCRoom:room
                                                                             roomInsId:insId.integerValue];
    [roomPlugin registerWithRegistrar:self.registrar];
    [self.roomPlugins setObject:roomPlugin forKey:insId];
    result(@(YES));
}

- (void)destroyRTCRoom:(NSDictionary *)arguments result:(FlutterResult)result {
    NSNumber *insId = arguments[@"insId"];
    ByteRTCFlutterRoomPlugin *roomPlugin = [self.roomPlugins objectForKey:insId];
    [self.roomPlugins removeObjectForKey:insId];
    [roomPlugin destroy];
    result(nil);
}

@end
