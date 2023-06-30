/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <objc/message.h>
#import "ByteRTCPlugin.h"
#import "ByteRTCFlutterSurfaceViewFactory.h"
#import "ByteRTCFlutterVideoPlugin.h"
#import "ByteRTCFlutterVideoEventHandler.h"
#import "ByteRTCVideoManager+Extension.h"

@interface ByteRTCPlugin ()

@property (nonatomic, weak) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic, strong, nullable) ByteRTCFlutterVideoPlugin *videoPlugin;
@property (nonatomic, strong) ByteRTCFlutterVideoEventHandler *eventHandler;

@end

@implementation ByteRTCPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    ByteRTCPlugin *instance = [[ByteRTCPlugin alloc] initWithRegistrar:registrar];
    FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:@"com.bytedance.ve_rtc_plugin"
                                                                      binaryMessenger:registrar.messenger];
    [registrar addMethodCallDelegate:instance channel:methodChannel];
    [registrar publish:instance];
    
    ByteRTCFlutterSurfaceViewFactory *surfaceViewFactory = [[ByteRTCFlutterSurfaceViewFactory alloc] initWithMessager:[registrar messenger]];
    [registrar registerViewFactory:surfaceViewFactory withId:@"ByteRTCSurfaceView"];
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super init];
    if (self) {
        self.registrar = registrar;
        self.eventHandler = [[ByteRTCFlutterVideoEventHandler alloc] init];
        [self.eventHandler registerEventChannelWithName:@"com.bytedance.ve_rtc_video_event"
                                        binaryMessenger:[registrar messenger]];
    }
    return self;
}

#pragma mark - FlutterPlugin
- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    SEL selector = NSSelectorFromString([call.method stringByAppendingString:@":result:"]);
    if ([self respondsToSelector:selector]) {
        ((void(*)(id,SEL,id,FlutterResult))objc_msgSend)(self,selector,call.arguments,result);
        return;
    }
    result(FlutterMethodNotImplemented);
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [self.videoPlugin destroy];
    self.videoPlugin = nil;
    [[ByteRTCVideoManager shared] destroyRTCVideo];
    [self.eventHandler destroy];
}

#pragma mark - method
- (void)createRTCVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL res = [[ByteRTCVideoManager shared] createRTCVideo:arguments delegate:self.eventHandler];
    if (res) {
        self.videoPlugin = [[ByteRTCFlutterVideoPlugin alloc] initWithRTCVideo:[ByteRTCVideoManager shared].rtcVideo];
        [self.videoPlugin registerWithRegistrar:self.registrar];
    }
    result(@(res));
}

- (void)destroyRTCVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.videoPlugin destroy];
    self.videoPlugin = nil;
    [[ByteRTCVideoManager shared] destroyRTCVideo];
    result(nil);
}

- (void)eventHandlerSwitches:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.eventHandler handleSwitches:arguments result:result];
}

- (void)getSDKVersion:(NSDictionary *)arguments result:(FlutterResult)result {
    result([ByteRTCVideo getSDKVersion]);
}

- (void)getErrorDescription:(NSDictionary *)arguments result:(FlutterResult)result {
    NSInteger code = [arguments[@"code"] integerValue];
    NSString *description = [ByteRTCVideo getErrorDescription:code];
    result(description);
}

@end
