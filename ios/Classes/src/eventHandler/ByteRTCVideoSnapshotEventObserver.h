/*
 * Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/rtc/ByteRTCVideoDefines.h>
#import "ByteRTCFlutterStreamHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface ByteRTCVideoSnapshotEventObserver : ByteRTCFlutterEventHandler <ByteRTCVideoSnapshotCallbackDelegate>
- (void)addFilePath:(NSString*)filePath
              forId:(NSInteger)taskId;
@end

NS_ASSUME_NONNULL_END
