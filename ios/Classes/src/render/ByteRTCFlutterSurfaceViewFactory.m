/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Flutter/FlutterCodecs.h>
#import <Flutter/FlutterBinaryMessenger.h>
#import <VolcEngineRTC/objc/ByteRTCVideo.h>
#import "ByteRTCFlutterSurfaceViewFactory.h"
#import "ByteRTCFlutterStreamHandler.h"
#import "ByteRTCVideoManager+Extension.h"

typedef NS_ENUM(NSInteger, RTCVideoCanvasType) {
    
    RTCVideoCanvasTypeLocal = 0,
    
    RTCVideoCanvasTypeRemote = 1,
    
    RTCVideoCanvasTypePublicStream = 2,
    
    RTCVideoCanvasTypeEchoTest = 3,
};

@interface ByteRTCFlutterSurfaceViewPlugin : NSObject <FlutterPlatformView>

@property (nonatomic, strong) ByteRTCView *surfaceView;
@property (nonatomic, strong) ByteRTCFlutterMethodHandler *methodHandler;

@end

@implementation ByteRTCFlutterSurfaceViewPlugin

- (instancetype)initWithMessager:(NSObject<FlutterBinaryMessenger>*)messenger
                           frame:(CGRect)frame
                  viewIdentifier:(int64_t)viewId
                       arguments:(id)args {
    self = [super init];
    if (self) {
        self.surfaceView = [[ByteRTCView alloc] initWithFrame:frame];
        self.methodHandler = [[ByteRTCFlutterMethodHandler alloc] init];
        [self.methodHandler registerMethodChannelWithName:[NSString stringWithFormat:@"com.bytedance.ve_rtc_surfaceView%lld", viewId]
                                             methodTarget:self
                                          binaryMessenger:messenger];
        if ([args isKindOfClass:[NSDictionary class]]) {
            [self setupVideoView:args];
        }
    }
    return self;
}

- (void)setupVideoView:(NSDictionary *)args {
    RTCVideoCanvasType canvasType = [args[@"canvasType"] integerValue];
    switch (canvasType) {
        case RTCVideoCanvasTypeLocal:
            [self setupLocalVideo:args result:nil];
            break;
        case RTCVideoCanvasTypeRemote:
            [self setupRemoteVideo:args result:nil];
            break;
        case RTCVideoCanvasTypePublicStream:
            [self setupPublicStreamVideo:args result:nil];
            break;
        case RTCVideoCanvasTypeEchoTest:
            [self setupEchoTestVideo:args result:nil];
            break;
    }
}

- (UIView *)view {
    return _surfaceView;
}

- (void)dealloc {
    [self.methodHandler destroy];
}

- (ByteRTCVideo *)rtcVideo {
    return [ByteRTCVideoManager shared].rtcVideo;
}

#pragma mark -
- (void)setupLocalVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamType = [arguments[@"streamType"] integerValue];
    ByteRTCVideoCanvas *canvas = [[ByteRTCVideoCanvas alloc] init];
    canvas.view = self.surfaceView;
    canvas.renderMode = [arguments[@"renderMode"] unsignedIntegerValue];
    canvas.backgroundColor = [arguments[@"backgroundColor"] unsignedIntegerValue];
    int res = -1;
    if (self.rtcVideo != nil) {
        res = [self.rtcVideo setLocalVideoCanvas:streamType
                                      withCanvas:canvas];
    }
    result ? result(@(res)) : nil;
}

- (void)updateLocalVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamType = [arguments[@"streamType"] integerValue];
    ByteRTCRenderMode renderMode = [arguments[@"renderMode"] unsignedIntegerValue];
    NSUInteger backgroundColor = [arguments[@"backgroundColor"] unsignedIntegerValue];
    [self.rtcVideo updateLocalVideoCanvas:streamType
                           withRenderMode:renderMode
                      withBackgroundColor:backgroundColor];
    result(nil);
}

- (void)setupRemoteVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *uid = arguments[@"uid"];
    ByteRTCStreamIndex streamType = [arguments[@"streamType"] integerValue];
    ByteRTCVideoCanvas *canvas = [[ByteRTCVideoCanvas alloc] init];
    canvas.view = self.surfaceView;
    canvas.renderMode = [arguments[@"renderMode"] unsignedIntegerValue];
    canvas.backgroundColor = [arguments[@"backgroundColor"] unsignedIntegerValue];
    
    ByteRTCRemoteStreamKey *streamKey = [[ByteRTCRemoteStreamKey alloc] init];
    streamKey.roomId = arguments[@"roomId"];
    streamKey.userId = uid;
    streamKey.streamIndex = streamType;
    
    [self.rtcVideo setRemoteVideoCanvas:streamKey withCanvas:canvas];
    result ? result(nil) : nil;
}

- (void)updateRemoteVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamType = [arguments[@"streamType"] integerValue];
    ByteRTCRenderMode renderMode = [arguments[@"renderMode"] unsignedIntegerValue];
    NSUInteger backgroundColor = [arguments[@"backgroundColor"] unsignedIntegerValue];
    
    ByteRTCRemoteStreamKey *streamKey = [[ByteRTCRemoteStreamKey alloc] init];
    streamKey.roomId = arguments[@"roomId"];
    streamKey.userId = arguments[@"uid"];
    streamKey.streamIndex = streamType;
    
    [self.rtcVideo updateRemoteStreamVideoCanvas:streamKey
                                  withRenderMode:renderMode
                             withBackgroundColor:backgroundColor];
    
    result(nil);
}

- (void)setupPublicStreamVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *streamId = arguments[@"uid"];
    ByteRTCVideoCanvas *canvas = [[ByteRTCVideoCanvas alloc] init];
    canvas.view = self.surfaceView;
    canvas.renderMode = [arguments[@"renderMode"] unsignedIntegerValue];
    canvas.backgroundColor = [arguments[@"backgroundColor"] unsignedIntegerValue];
    int res = -1;
    if (self.rtcVideo != nil) {
        res = [self.rtcVideo setPublicStreamVideoCanvas:streamId
                                             withCanvas:canvas];
    }
    result ? result(@(res)) : nil;
}

- (void)setupEchoTestVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    [ByteRTCVideoManager shared].echoTestView = self.surfaceView;
    result ? result(nil) : nil;
}

@end

@interface ByteRTCFlutterSurfaceViewFactory ()

@property (nonatomic, weak) NSObject<FlutterBinaryMessenger>* messenger;

@end

@implementation ByteRTCFlutterSurfaceViewFactory

- (instancetype)initWithMessager:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        self.messenger = messenger;
    }
    return self;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame
                                    viewIdentifier:(int64_t)viewId
                                         arguments:(id)args {
    return [[ByteRTCFlutterSurfaceViewPlugin alloc] initWithMessager:self.messenger
                                                               frame:frame
                                                      viewIdentifier:viewId
                                                           arguments:args];
}

@end
