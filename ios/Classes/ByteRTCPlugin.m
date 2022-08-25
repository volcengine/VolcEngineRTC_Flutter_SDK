/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <objc/message.h>
#import "ByteRTCPlugin.h"
#import "ByteRTCFlutterSurfaceViewFactory.h"
#import "ByteRTCFlutterVideoPlugin.h"
#import "ByteRTCFlutterVideoManager.h"

@interface ByteRTCPlugin ()

@property (nonatomic, weak) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic, strong) ByteRTCFlutterVideoPlugin *videoPlugin;

@end

@implementation ByteRTCPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    ByteRTCPlugin *instance = [[ByteRTCPlugin alloc] initWithRegistrar:registrar];
    [registrar publish:instance];
    ByteRTCFlutterSurfaceViewFactory *surfaceViewFactory = [[ByteRTCFlutterSurfaceViewFactory alloc] initWithMessager:[registrar messenger]
                                                                                                         videoManager:instance.videoPlugin.videoManager];
    [registrar registerViewFactory:surfaceViewFactory withId:@"ByteRTCSurfaceView"];
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super init];
    if (self) {
        self.registrar = registrar;
        self.videoPlugin = [[ByteRTCFlutterVideoPlugin alloc] init];
        [self.videoPlugin registerWithRegistrar:registrar];
    }
    return self;
}

#pragma mark - FlutterPlugin
- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [self.videoPlugin destroy];
}

@end
