/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/ByteRTCRoom.h>
#import "ByteRTCFlutterSpatialAudioPlugin.h"
#import "ByteRTCFlutterMapCategory.h"

@interface ByteRTCFlutterSpatialAudioPlugin ()

@property (nonatomic, assign) NSInteger insId;
@property (nonatomic, strong) ByteRTCRoom *room;

@end

@implementation ByteRTCFlutterSpatialAudioPlugin

- (instancetype)initWithRTCRoom:(ByteRTCRoom *)rtcRoom insId:(NSInteger)insId {
    self = [super init];
    if (self) {
        self.insId = insId;
        self.room = rtcRoom;
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [super registerWithRegistrar:registrar];
    NSString *methodChannelName = [NSString stringWithFormat:@"com.bytedance.ve_rtc_spatial_audio%ld",
                                   (long)self.insId];
    [self.methodHandler registerMethodChannelWithName:methodChannelName
                                         methodTarget:self
                                      binaryMessenger:[registrar messenger]];
}

- (nullable ByteRTCSpatialAudio *)spatialAudio {
    return self.room.getSpatialAudio;
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

- (void)updateListenerPosition:(NSDictionary *)arguments result:(FlutterResult)result {
    Position *pos = [Position bf_fromMap:arguments[@"pos"]];
    int res = [self.spatialAudio updateListenerPosition:pos];
    result(@(res));
}

- (void)updateListenerOrientation:(NSDictionary *)arguments result:(FlutterResult)result {
    HumanOrientation *orientation = [HumanOrientation bf_fromMap:arguments[@"orientation"]];
    int res = [self.spatialAudio updateListenerOrientation:orientation];
    result(@(res));
}

@end
