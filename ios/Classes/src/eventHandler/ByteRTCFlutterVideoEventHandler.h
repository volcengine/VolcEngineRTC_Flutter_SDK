/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/ByteRTCVideo.h>
#import "ByteRTCFlutterStreamHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface ByteRTCFlutterVideoEventHandler : ByteRTCFlutterEventHandler <ByteRTCVideoDelegate>

- (void)handleSwitches:(NSDictionary *)arguments result:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
