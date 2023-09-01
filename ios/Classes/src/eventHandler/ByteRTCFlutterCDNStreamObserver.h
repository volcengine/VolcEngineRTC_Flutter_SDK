/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/rtc/ByteRTCVideoDefines.h>
#import "ByteRTCFlutterStreamHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface ByteRTCFlutterPushSingleStreamToCDNObserver : ByteRTCFlutterEventHandler <ByteRTCPushSingleStreamToCDNObserver>

@end

@interface ByteRTCFlutterMixedStreamObserver : ByteRTCFlutterEventHandler <ByteRTCMixedStreamObserver>

@end

NS_ASSUME_NONNULL_END
