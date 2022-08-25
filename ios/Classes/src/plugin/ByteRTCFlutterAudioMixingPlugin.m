/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Flutter/FlutterPlugin.h>
#import "ByteRTCFlutterAudioMixingPlugin.h"
#import "ByteRTCFlutterAudioMixingManager.h"

@interface ByteRTCFlutterAudioMixingPlugin ()

@property (nonatomic, strong) ByteRTCFlutterAudioMixingManager *audioMixingManager;

@end

@implementation ByteRTCFlutterAudioMixingPlugin

- (instancetype)initWithVideoManager:(ByteRTCFlutterVideoManager *)videoManager {
    self = [super init];
    if (self) {
        self.audioMixingManager = [[ByteRTCFlutterAudioMixingManager alloc] initWithVideoManager:videoManager];
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [self registerMethodChannelWithName:@"com.bytedance.ve_rtc_audio_mixing_manager"
                           methodTarget:self.audioMixingManager
                        binaryMessenger:[registrar messenger]];
}

@end
