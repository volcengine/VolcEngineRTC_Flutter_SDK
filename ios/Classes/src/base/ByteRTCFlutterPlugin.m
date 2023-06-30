/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterPlugin.h"

@implementation ByteRTCFlutterPlugin

- (instancetype)init {
    self = [super init];
    if (self) {
        self.methodHandler = [[ByteRTCFlutterMethodHandler alloc] init];
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    self.registrar = registrar;
}

- (void)destroy {
    [self.methodHandler destroy];
}

@end
