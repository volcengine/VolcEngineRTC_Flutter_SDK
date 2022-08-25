/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Flutter/FlutterPlugin.h>
#import "ByteRTCFlutterSpatialAudioPlugin.h"
#import "ByteRTCFlutterSpatialAudioManager.h"

@interface ByteRTCFlutterSpatialAudioPlugin ()

@property (nonatomic, assign) NSInteger insId;
@property (nonatomic, strong) ByteRTCFlutterSpatialAudioManager *manager;

@end

@implementation ByteRTCFlutterSpatialAudioPlugin

- (instancetype)initWithRoomManager:(ByteRTCFlutterRoomManager *)roomManager
                              insId:(NSInteger)insId {
    self = [super init];
    if (self) {
        self.insId = insId;
        self.manager = [[ByteRTCFlutterSpatialAudioManager alloc] initWithRoomManager:roomManager];
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    NSString *methodChannelName = [NSString stringWithFormat:@"com.bytedance.ve_rtc_spatial_audio%ld",
                                   (long)self.insId];
    [self registerMethodChannelWithName:methodChannelName
                           methodTarget:self.manager
                        binaryMessenger:[registrar messenger]];
}

@end
