/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/ByteRTCRoom.h>
#import <Flutter/FlutterChannels.h>
#import "ByteRTCFlutterSpatialAudioManager.h"
#import "ByteRTCFlutterMapCategory.h"
#import "ByteRTCFlutterRoomManager.h"

@interface ByteRTCFlutterSpatialAudioManager ()

@property (nonatomic, weak) ByteRTCFlutterRoomManager *roomManager;

@end

@implementation ByteRTCFlutterSpatialAudioManager

- (instancetype)initWithRoomManager:(ByteRTCFlutterRoomManager *)roomManager {
    self = [super init];
    if (self) {
        self.roomManager = roomManager;
    }
    return self;
}

- (nullable ByteRTCSpatialAudio *)spatialAudio {
    return [self.roomManager getRTCRoom].getSpatialAudio;
}

#pragma mark - SpatialAudio

- (void)enableSpatialAudio:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL enable = [arguments[@"enable"] boolValue];
    [self.spatialAudio enableSpatialAudio:enable];
    result(nil);
}

- (void)updatePosition:(NSDictionary *)arguments result:(FlutterResult)result {
    Position *pos = [Position bf_fromMap:arguments[@"pos"]];
    int res = [self.spatialAudio updatePosition:pos];
    result(@(res));
}

- (void)updateSelfOrientation:(NSDictionary *)arguments result:(FlutterResult)result {
    HumanOrientation *orientation = [HumanOrientation bf_fromMap:arguments[@"orientation"]];
    int res = [self.spatialAudio updateSelfOrientation:orientation];
    result(@(res));
}

- (void)disableRemoteOrientation:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.spatialAudio disableRemoteOrientation];
    result(nil);
}

@end
