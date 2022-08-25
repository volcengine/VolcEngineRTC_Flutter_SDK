/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import "ByteRTCFlutterStreamHandler.h"
#import "ByteRTCFlutterPluginProtocl.h"

NS_ASSUME_NONNULL_BEGIN

@class ByteRTCFlutterRoomManager, ByteRTCRoom;
@interface ByteRTCFlutterRoomPlugin : ByteRTCFlutterMethodHandler <ByteRTCFlutterPlugin>

@property (nonatomic, strong, readonly) ByteRTCFlutterRoomManager *roomManager;

+ (instancetype)createWithRTCRoom:(ByteRTCRoom *)rtcRoom
                        roomInsId:(NSInteger)roomInsId;

@end

NS_ASSUME_NONNULL_END
