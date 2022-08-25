/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Flutter/FlutterPlugin.h>
#import "ByteRTCFlutterRangeAudioPlugin.h"
#import "ByteRTCFlutterRangeAudioManager.h"
#import "ByteRTCFlutterRangeAudioObserver.h"

@interface ByteRTCFlutterRangeAudioPlugin ()

@property (nonatomic, weak) NSObject<FlutterPluginRegistrar> *registrar;

@property (nonatomic, assign) NSInteger insId;
@property (nonatomic, strong) ByteRTCFlutterRangeAudioManager *manager;
@property (nonatomic, strong) ByteRTCFlutterRangeAudioObserver *rangeAudioObserver;

@end

@implementation ByteRTCFlutterRangeAudioPlugin

- (instancetype)initWithRoomManager:(ByteRTCFlutterRoomManager *)roomManager
                              insId:(NSInteger)insId {
    self = [super init];
    if (self) {
        self.insId = insId;
        self.rangeAudioObserver = [[ByteRTCFlutterRangeAudioObserver alloc] init];
        self.manager = [[ByteRTCFlutterRangeAudioManager alloc] initWithRoomManager:roomManager];
        self.manager.observer = self.rangeAudioObserver;
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    self.registrar = registrar;
    NSString *methodChannelName = [NSString stringWithFormat:@"com.bytedance.ve_rtc_range_audio%ld",
                                   (long)self.insId];
    [self registerMethodChannelWithName:methodChannelName
                           methodTarget:self.manager
                        binaryMessenger:[registrar messenger]];
    NSString *eventChannelName = [NSString stringWithFormat:@"com.bytedance.ve_rtc_range_audio_observer%ld",
                                  (long)self.insId];
    [self.rangeAudioObserver registerEventChannelWithName:eventChannelName
                                          binaryMessenger:[self.registrar messenger]];
}

- (void)destroy {
    [super destroy];
    [self.rangeAudioObserver destroy];
}

@end
