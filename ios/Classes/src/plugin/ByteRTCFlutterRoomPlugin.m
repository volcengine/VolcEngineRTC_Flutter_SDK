/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Flutter/FlutterPlugin.h>
#import "ByteRTCFlutterRoomPlugin.h"
#import "ByteRTCFlutterRoomManager.h"
#import "ByteRTCFlutterRoomEventHandler.h"
#import "ByteRTCFlutterRangeAudioPlugin.h"
#import "ByteRTCFlutterSpatialAudioPlugin.h"

@interface ByteRTCFlutterRoomPlugin ()

@property (nonatomic, weak) NSObject<FlutterPluginRegistrar> *registrar;

@property (nonatomic, strong) ByteRTCFlutterRangeAudioPlugin *rangeAudioPlugin;
@property (nonatomic, strong) ByteRTCFlutterSpatialAudioPlugin *spatialAudioPlugin;
@property (nonatomic, strong) ByteRTCFlutterRoomManager *roomManager;
@property (nonatomic, assign) NSInteger insId;
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
        self.eventHandler = [[ByteRTCFlutterRoomEventHandler alloc] init];
        self.roomManager = [ByteRTCFlutterRoomManager createWithRTCRoom:rtcRoom
                                                           roomDelegate:self.eventHandler];
        self.rangeAudioPlugin = [[ByteRTCFlutterRangeAudioPlugin alloc] initWithRoomManager:self.roomManager
                                                                                      insId:roomInsId];
        self.spatialAudioPlugin = [[ByteRTCFlutterSpatialAudioPlugin alloc] initWithRoomManager:self.roomManager
                                                                                          insId:roomInsId];
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    self.registrar = registrar;
    NSString *methodChannelName = [NSString stringWithFormat:@"com.bytedance.ve_rtc_room%ld",
                                   (long)self.insId];
    [self registerMethodChannelWithName:methodChannelName
                           methodTarget:self.roomManager
                        binaryMessenger:[registrar messenger]];
    [self.rangeAudioPlugin registerWithRegistrar:registrar];
    [self.spatialAudioPlugin registerWithRegistrar:registrar];
    
    NSString *eventChannelName = [NSString stringWithFormat:@"com.bytedance.ve_rtc_room_event%ld",
                                  (long)self.insId];
    [self.eventHandler registerEventChannelWithName:eventChannelName
                                    binaryMessenger:[registrar messenger]];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"eventHandlerSwitches"]) {
        [self.eventHandler handleSwitches:call.arguments result:result];
        return;
    }
    [super handleMethodCall:call result:result];
}

- (void)destroy {
    [super destroy];
    [self.roomManager destroyEngine];
    [self.eventHandler destroy];
    [self.rangeAudioPlugin destroy];
    [self.spatialAudioPlugin destroy];
}

@end
