/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterStreamHandler.h"
#import "ByteRTCFlutterPluginProtocl.h"

NS_ASSUME_NONNULL_BEGIN

@class ByteRTCFlutterVideoManager;
@interface ByteRTCFlutterAudioMixingPlugin : ByteRTCFlutterMethodHandler <ByteRTCFlutterPlugin>

- (instancetype)initWithVideoManager:(ByteRTCFlutterVideoManager *)videoManager;

@end

NS_ASSUME_NONNULL_END
