/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Foundation/Foundation.h>
#import <VolcEngineRTC/objc/rtc/ByteRTCCommonDefines.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ByteRTCVideoDelegate,
ByteRTCASREngineEventHandler,
ByteRTCFaceDetectionObserver,
LiveTranscodingDelegate,
ByteRTCPushSingleStreamToCDNObserver;

@class ByteRTCVideo, ByteRTCRoom;

@interface ByteRTCFlutterVideoManager : NSObject

@property (nonatomic, weak, nullable) id<ByteRTCVideoDelegate> delegate;
@property (nonatomic, weak, nullable) id<ByteRTCASREngineEventHandler> asrEventDelegate;
@property (nonatomic, weak, nullable) id<ByteRTCFaceDetectionObserver> faceDetectionObserver;
@property (nonatomic, weak, nullable) id<LiveTranscodingDelegate> liveTranscodingDelegate;
@property (nonatomic, weak, nullable) id<ByteRTCPushSingleStreamToCDNObserver> pushSingleStreamToCDNObserver;

@property (nonatomic, weak, nullable) ByteRTCView *echoTestView;

- (ByteRTCVideo *)getRTCVideo;

- (ByteRTCRoom *)createRTCRoom:(NSString *)roomId;
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
