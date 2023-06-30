/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/ByteRTCRoom.h>
#import "ByteRTCFlutterRangeAudioPlugin.h"
#import "ByteRTCFlutterMapCategory.h"

@interface ByteRTCFlutterRangeAudioPlugin ()

@property (nonatomic, assign) NSInteger insId;
@property (nonatomic, strong) ByteRTCRoom *room;

@end

@implementation ByteRTCFlutterRangeAudioPlugin

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
    NSString *methodChannelName = [NSString stringWithFormat:@"com.bytedance.ve_rtc_range_audio%ld",
                                   (long)self.insId];
    [self.methodHandler registerMethodChannelWithName:methodChannelName
                                         methodTarget:self
                                      binaryMessenger:[registrar messenger]];
}

- (nullable ByteRTCRangeAudio *)rangeAudio {
    return self.room.getRangeAudio;
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

- (void)setAttenuationModel:(NSDictionary *)arguments result:(FlutterResult)result {
    AttenuationType type = [arguments[@"type"] integerValue];
    float coefficient = [arguments[@"coefficient"] floatValue];
    int res = [self.rangeAudio setAttenuationModel:type coefficient:coefficient];
    result(@(res));
}

- (void)setNoAttenuationFlags:(NSDictionary *)arguments result:(FlutterResult)result {
    NSArray<NSString *> *flags = arguments[@"flags"];
    [self.rangeAudio setNoAttenuationFlags:flags];
    result(nil);
}

@end
