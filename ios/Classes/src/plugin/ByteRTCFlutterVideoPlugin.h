/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterStreamHandler.h"
#import "ByteRTCFlutterPluginProtocl.h"

NS_ASSUME_NONNULL_BEGIN

@class ByteRTCFlutterVideoManager;
@interface ByteRTCFlutterVideoPlugin : ByteRTCFlutterMethodHandler <ByteRTCFlutterPlugin>

@property (nonatomic, strong, readonly) ByteRTCFlutterVideoManager *videoManager;

@end

NS_ASSUME_NONNULL_END
