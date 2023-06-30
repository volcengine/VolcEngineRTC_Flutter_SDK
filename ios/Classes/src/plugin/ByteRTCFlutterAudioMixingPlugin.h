/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@class ByteRTCVideo;
@interface ByteRTCFlutterAudioMixingPlugin : ByteRTCFlutterPlugin

- (instancetype)initWithRTCVideo:(ByteRTCVideo *)rtcVideo;

@end

NS_ASSUME_NONNULL_END
