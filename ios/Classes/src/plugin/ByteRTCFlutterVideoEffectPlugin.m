/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/ByteRTCVideo.h>
#import "ByteRTCFlutterVideoEffectPlugin.h"
#import "ByteRTCFlutterMapCategory.h"

@interface ByteRTCFlutterVideoEffectPlugin ()

@property (nonatomic, strong) ByteRTCVideo *rtcVideo;
@property (nonatomic, strong) ByteRTCFlutterFaceDetectionHandler *faceDetectionHandler;

@end

@implementation ByteRTCFlutterVideoEffectPlugin

- (instancetype)initWithRTCVideo:(ByteRTCVideo *)rtcVideo {
    self = [super init];
    if (self) {
        self.rtcVideo = rtcVideo;
        self.faceDetectionHandler = [[ByteRTCFlutterFaceDetectionHandler alloc] init];
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [super registerWithRegistrar:registrar];
    [self.methodHandler registerMethodChannelWithName:@"com.bytedance.ve_rtc_video_effect"
                           methodTarget:self
                        binaryMessenger:[registrar messenger]];
    [self.faceDetectionHandler registerEventChannelWithName:@"com.bytedance.ve_rtc_video_effect_face_detection"
                                            binaryMessenger:[self.registrar messenger]];
}

- (void)destroy {
    [super destroy];
    [self.faceDetectionHandler destroy];
}

- (nullable ByteRTCVideoEffect *)videoEffect {
    return self.rtcVideo.getVideoEffectInterface;
}

#pragma mark Video Effect
- (void)initCVResource:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *licenseFile = arguments[@"licenseFile"];
    NSString *modelPath = arguments[@"modelPath"];
    int res = [self.videoEffect initCVResource:licenseFile withAlgoModelDir:modelPath];
    result(@(res));
}

- (void)enableVideoEffect:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.videoEffect enableVideoEffect];
    result(@(res));
}

- (void)disableVideoEffect:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.videoEffect disableVideoEffect];
    result(@(res));
}

- (void)setEffectNodes:(NSDictionary *)arguments result:(FlutterResult)result {
    NSArray<NSString *> *effectNodes = arguments[@"effectNodes"];
    int res = [self.videoEffect setEffectNodes:effectNodes];
    result(@(res));
}

- (void)updateEffectNode:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *effectNode = arguments[@"effectNode"];
    NSString *key = arguments[@"key"];
    float value = [arguments[@"value"] floatValue];
    int res = [self.videoEffect updateEffectNode:effectNode key:key value:value];
    result(@(res));
}

- (void)setColorFilter:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *resFile = arguments[@"resFile"];
    int res = [self.videoEffect setColorFilter:resFile];
    result(@(res));
}

- (void)setColorFilterIntensity:(NSDictionary *)arguments result:(FlutterResult)result {
    float intensity = [arguments[@"intensity"] floatValue];
    int res = [self.videoEffect setColorFilterIntensity:intensity];
    result(@(res));
}

- (void)enableVirtualBackground:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *modelPath = arguments[@"modelPath"];
    ByteRTCVirtualBackgroundSource *source = [ByteRTCVirtualBackgroundSource bf_fromMap:arguments[@"source"]];
    int res = [self.videoEffect enableVirtualBackground:modelPath withSource:source];
    result(@(res));
}

- (void)disableVirtualBackground:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.videoEffect disableVirtualBackground];
    result(@(res));
}

- (void)enableFaceDetection:(NSDictionary *)arguments result:(FlutterResult)result {
    NSInteger interval = [arguments[@"interval"] integerValue];
    NSString *modelPath = arguments[@"modelPath"];
    int res = [self.videoEffect enableFaceDetection:self.faceDetectionHandler
                                       withInterval:interval
                                      withModelPath:modelPath];
    result(@(res));
}

- (void)disableFaceDetection:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.videoEffect disableFaceDetection];
    result(@(res));
}

@end
