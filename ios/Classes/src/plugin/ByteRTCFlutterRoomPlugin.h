/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterPlugin.h"

NS_ASSUME_NONNULL_BEGIN

@class ByteRTCRoom;
@interface ByteRTCFlutterRoomPlugin : ByteRTCFlutterPlugin

+ (instancetype)createWithRTCRoom:(ByteRTCRoom *)rtcRoom
                        roomInsId:(NSInteger)roomInsId;

@end

NS_ASSUME_NONNULL_END
