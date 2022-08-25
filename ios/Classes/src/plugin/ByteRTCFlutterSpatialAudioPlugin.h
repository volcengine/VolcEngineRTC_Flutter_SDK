/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterStreamHandler.h"
#import "ByteRTCFlutterPluginProtocl.h"

NS_ASSUME_NONNULL_BEGIN

@class ByteRTCFlutterRoomManager;
@interface ByteRTCFlutterSpatialAudioPlugin : ByteRTCFlutterMethodHandler <ByteRTCFlutterPlugin>

- (instancetype)initWithRoomManager:(ByteRTCFlutterRoomManager *)roomManager insId:(NSInteger)insId;

@end

NS_ASSUME_NONNULL_END
