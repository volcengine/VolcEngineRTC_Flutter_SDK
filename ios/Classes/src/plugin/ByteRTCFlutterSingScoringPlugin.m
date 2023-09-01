/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/ByteRTCVideo.h>
#import "ByteRTCFlutterSingScoringPlugin.h"
#import "ByteRTCFlutterMapCategory.h"

@interface ByteRTCFlutterSingScoringEventHandler : ByteRTCFlutterEventHandler <ByteRTCSingScoringDelegate>

@end

@implementation ByteRTCFlutterSingScoringEventHandler

- (void)onCurrentScoringInfo:(ByteRTCSingScoringRealtimeInfo * _Nullable)info {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"info"] = info.bf_toMap;
    [self emitEvent:dict methodName:@"onCurrentScoringInfo"];
}

@end

@interface ByteRTCFlutterSingScoringPlugin ()

@property (nonatomic, strong) ByteRTCSingScoringManager *singScoringManager;
@property (nonatomic, strong) ByteRTCFlutterSingScoringEventHandler *eventHandler;

@end

@implementation ByteRTCFlutterSingScoringPlugin

- (instancetype)initWithRTCSingScoringManager:(ByteRTCSingScoringManager *)manager {
    self = [super init];
    if (self) {
        self.singScoringManager = manager;
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [super registerWithRegistrar:registrar];
    [self.methodHandler registerMethodChannelWithName:@"com.bytedance.ve_rtc_sing_scoring_manager"
                                         methodTarget:self
                                      binaryMessenger:[registrar messenger]];
}

- (void)destroy {
    [super destroy];
    [_eventHandler destroy];
}

#pragma mark - Lazy load
- (ByteRTCFlutterSingScoringEventHandler *)eventHandler {
    if (!_eventHandler) {
        _eventHandler = [[ByteRTCFlutterSingScoringEventHandler alloc] init];
        [_eventHandler registerEventChannelWithName:@"com.bytedance.ve_rtc_sing_scoring_event_handler"
                                    binaryMessenger:[self.registrar messenger]];
    }
    return _eventHandler;
}

#pragma mark -

- (void)initSingScoring:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *singScoringAppKey = arguments[@"singScoringAppKey"];
    NSString *singScoringToken = arguments[@"singScoringToken"];
    BOOL handler = [arguments[@"handler"] boolValue];
    ByteRTCFlutterSingScoringEventHandler *delegate = nil;
    if (handler) {
        delegate = self.eventHandler;
    }
    int res = [self.singScoringManager initSingScoring:singScoringAppKey
                                      singScoringToken:singScoringToken
                                              delegate:delegate];
    result(@(res));
}

- (void)setSingScoringConfig:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCSingScoringConfig *config = [ByteRTCSingScoringConfig bf_fromMap:arguments[@"config"]];
    int res = [self.singScoringManager setSingScoringConfig:config];
    result(@(res));
}

- (void)getStandardPitchInfo:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *midiFilepath = arguments[@"midiFilepath"];
    NSArray<ByteRTCStandardPitchInfo* > *infos = [self.singScoringManager getStandardPitchInfo:midiFilepath];
    if (!infos || !infos.count) {
        result(nil);
        return;
    }
    NSMutableArray *infoMaps = [NSMutableArray arrayWithCapacity:infos.count];
    [infos enumerateObjectsUsingBlock:^(ByteRTCStandardPitchInfo *obj, NSUInteger idx, BOOL *stop) {
        [infoMaps addObject:obj.bf_toMap];
    }];
    result(infoMaps);
}

- (void)startSingScoring:(NSDictionary *)arguments result:(FlutterResult)result {
    int position = [arguments[@"position"] intValue];
    int scoringInfoInterval = [arguments[@"scoringInfoInterval"] intValue];
    int res = [self.singScoringManager startSingScoring:position scoringInfoInterval:scoringInfoInterval];
    result(@(res));
}

- (void)stopSingScoring:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.singScoringManager stopSingScoring];
    result(@(res));
}

- (void)getLastSentenceScore:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.singScoringManager getLastSentenceScore];
    result(@(res));
}

- (void)getTotalScore:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.singScoringManager getTotalScore];
    result(@(res));
}

- (void)getAverageScore:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.singScoringManager getAverageScore];
    result(@(res));
}

@end
