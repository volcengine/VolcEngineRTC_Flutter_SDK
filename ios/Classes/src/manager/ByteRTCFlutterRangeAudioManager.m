/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/rtc/ByteRTCVideoDefines.h>
#import <VolcEngineRTC/objc/ByteRTCRoom.h>
#import <Flutter/FlutterChannels.h>
#import "ByteRTCFlutterRangeAudioManager.h"
#import "ByteRTCFlutterMapCategory.h"
#import "ByteRTCFlutterRoomManager.h"

@interface ByteRTCFlutterRangeAudioManager ()

@property (nonatomic, weak) ByteRTCFlutterRoomManager *roomManager;

@end

@implementation ByteRTCFlutterRangeAudioManager

- (instancetype)initWithRoomManager:(ByteRTCFlutterRoomManager *)roomManager {
    self = [super init];
    if (self) {
        self.roomManager = roomManager;
    }
    return self;
}

- (nullable ByteRTCRangeAudio *)rangeAudio {
    return [self.roomManager getRTCRoom].getRangeAudio;
}

#pragma mark - RangeAudio

- (void)enableRangeAudio:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL enable = [arguments[@"enable"] boolValue];
    [self.rangeAudio enableRangeAudio:enable];
    result(nil);
}

- (void)updateReceiveRange:(NSDictionary *)arguments result:(FlutterResult)result {
    ReceiveRange *range = [ReceiveRange bf_fromMap:arguments[@"range"]];
    int res = [self.rangeAudio updateReceiveRange:range];
    result(@(res));
}

- (void)updatePosition:(NSDictionary *)arguments result:(FlutterResult)result {
    Position *pos = [Position bf_fromMap:arguments[@"pos"]];
    int res = [self.rangeAudio updatePosition:pos];
    result(@(res));
}

- (void)registerRangeAudioObserver:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL observer = [arguments[@"observer"] boolValue];
    if (observer) {
        [self.rangeAudio registerRangeAudioObserver:self.observer];
    } else {
        [self.rangeAudio registerRangeAudioObserver:nil];
    }
    result(nil);
}

- (void)setAttenuationModel:(NSDictionary *)arguments result:(FlutterResult)result {
    AttenuationType type = [arguments[@"type"] integerValue];
    float coefficient = [arguments[@"coefficient"] floatValue];
    int res = [self.rangeAudio setAttenuationModel:type coefficient:coefficient];
    result(@(res));
}

@end
