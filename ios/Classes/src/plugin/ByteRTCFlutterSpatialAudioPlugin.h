/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@class ByteRTCRoom;
@interface ByteRTCFlutterSpatialAudioPlugin : ByteRTCFlutterPlugin

- (instancetype)initWithRTCRoom:(ByteRTCRoom *)rtcRoom insId:(NSInteger)insId;

@end

NS_ASSUME_NONNULL_END
