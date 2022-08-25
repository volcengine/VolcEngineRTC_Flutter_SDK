/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/ByteRTCRoom.h>
#import "ByteRTCFlutterStreamHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface ByteRTCFlutterRoomEventHandler : ByteRTCFlutterEventHandler <ByteRTCRoomDelegate>

- (void)handleSwitches:(NSDictionary *)arguments result:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
