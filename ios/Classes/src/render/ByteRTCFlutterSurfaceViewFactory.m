/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <Flutter/FlutterCodecs.h>
#import <Flutter/FlutterBinaryMessenger.h>
#import <VolcEngineRTC/objc/ByteRTCVideo.h>
#import "ByteRTCFlutterSurfaceViewFactory.h"
#import "ByteRTCFlutterVideoManager.h"

typedef NS_ENUM(NSInteger, RTCVideoCanvasType) {
    
    RTCVideoCanvasTypeLocal = 0,
    
    RTCVideoCanvasTypeRemote = 1,
    
    RTCVideoCanvasTypePublicStream = 2,
    
    RTCVideoCanvasTypeEchoTest = 3,
};

@interface ByteRTCFlutterSurfaceView : ByteRTCView

@property (nonatomic, weak) ByteRTCFlutterVideoManager *videoManager;

@end

@implementation ByteRTCFlutterSurfaceView

- (instancetype)initWithFrame:(CGRect)frame videoManager:(ByteRTCFlutterVideoManager *)videoManager {
    self = [super initWithFrame:frame];
    if (self) {
        self.videoManager = videoManager;
    }
    return self;
}

- (void)setupLocalVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamType = [arguments[@"streamType"] integerValue];
    ByteRTCVideoCanvas *canvas = [[ByteRTCVideoCanvas alloc] init];
    canvas.view = self;
    canvas.renderMode = [arguments[@"renderMode"] unsignedIntegerValue];
    canvas.roomId = arguments[@"roomId"];
    canvas.uid = arguments[@"uid"];
    canvas.backgroundColor = [arguments[@"backgroundColor"] unsignedIntegerValue];
    int res = [[self.videoManager getRTCVideo] setLocalVideoCanvas:streamType
                                                        withCanvas:canvas];
    result ? result(@(res)) : nil;
}

- (void)updateLocalVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamType = [arguments[@"streamType"] integerValue];
    ByteRTCRenderMode renderMode = [arguments[@"renderMode"] unsignedIntegerValue];
    NSUInteger backgroundColor = [arguments[@"backgroundColor"] unsignedIntegerValue];
    int res = [[self.videoManager getRTCVideo] updateLocalVideoCanvas:streamType
                                                       withRenderMode:renderMode
                                                  withBackgroundColor:backgroundColor];
    result(@(res));
}

- (void)setupRemoteVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *uid = arguments[@"uid"];
    ByteRTCStreamIndex streamType = [arguments[@"streamType"] integerValue];
    ByteRTCVideoCanvas *canvas = [[ByteRTCVideoCanvas alloc] init];
    canvas.view = self;
    canvas.renderMode = [arguments[@"renderMode"] unsignedIntegerValue];
    canvas.roomId = arguments[@"roomId"];
    canvas.uid = uid;
    canvas.backgroundColor = [arguments[@"backgroundColor"] unsignedIntegerValue];
    int res = [[self.videoManager getRTCVideo] setRemoteVideoCanvas:uid
                                                          withIndex:streamType
                                                         withCanvas:canvas];
    result ? result(@(res)) : nil;
}

- (void)updateRemoteVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *roomId = arguments[@"roomId"];
    NSString *uid = arguments[@"uid"];
    ByteRTCStreamIndex streamType = [arguments[@"streamType"] integerValue];
    ByteRTCRenderMode renderMode = [arguments[@"renderMode"] unsignedIntegerValue];
    NSUInteger backgroundColor = [arguments[@"backgroundColor"] unsignedIntegerValue];
    int res = [[self.videoManager getRTCVideo] updateRemoteStreamVideoCanvas:roomId
                                                                  withUserId:uid
                                                                   withIndex:streamType
                                                              withRenderMode:renderMode
                                                         withBackgroundColor:backgroundColor];
    result(@(res));
}

- (void)setupPublicStreamVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *streamId = arguments[@"uid"];
    ByteRTCVideoCanvas *canvas = [[ByteRTCVideoCanvas alloc] init];
    canvas.view = self;
    canvas.renderMode = [arguments[@"renderMode"] unsignedIntegerValue];
    canvas.backgroundColor = [arguments[@"backgroundColor"] unsignedIntegerValue];
    int res = [[self.videoManager getRTCVideo] setPublicStreamVideoCanvas:streamId
                                                               withCanvas:canvas];
    result ? result(@(res)) : nil;
}

- (void)setupEchoTestVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    self.videoManager.echoTestView = self;
    result ? result(nil) : nil;
}

@end

@interface ByteRTCFlutterSurfaceViewPlugin : ByteRTCFlutterMethodHandler <FlutterPlatformView>

@property (nonatomic, strong) ByteRTCFlutterSurfaceView *surfaceView;

@end

@implementation ByteRTCFlutterSurfaceViewPlugin

- (instancetype)initWithMessager:(NSObject<FlutterBinaryMessenger>*)messenger
                           frame:(CGRect)frame
                  viewIdentifier:(int64_t)viewId
                       arguments:(id)args
                    videoManager:(ByteRTCFlutterVideoManager *)videoManager {
    self = [super init];
    if (self) {
        self.surfaceView = [[ByteRTCFlutterSurfaceView alloc] initWithFrame:frame videoManager:videoManager];
        [self registerMethodChannelWithName:[NSString stringWithFormat:@"com.bytedance.ve_rtc_surfaceView%lld", viewId]
                               methodTarget:self.surfaceView
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
            [self.surfaceView setupLocalVideo:args result:nil];
            break;
        case RTCVideoCanvasTypeRemote:
            [self.surfaceView setupRemoteVideo:args result:nil];
            break;
        case RTCVideoCanvasTypePublicStream:
            [self.surfaceView setupPublicStreamVideo:args result:nil];
            break;
        case RTCVideoCanvasTypeEchoTest:
            [self.surfaceView setupEchoTestVideo:args result:nil];
            break;
    }
}

- (UIView *)view {
    return _surfaceView;
}

- (void)dealloc {
    [self destroy];
}

@end


@interface ByteRTCFlutterSurfaceViewFactory ()

@property (nonatomic, weak) NSObject<FlutterBinaryMessenger>* messenger;
@property (nonatomic, weak) ByteRTCFlutterVideoManager *videoManager;

@end

@implementation ByteRTCFlutterSurfaceViewFactory

- (instancetype)initWithMessager:(NSObject<FlutterBinaryMessenger>*)messenger videoManager:(ByteRTCFlutterVideoManager *)videoManager {
    self = [super init];
    if (self) {
        self.messenger = messenger;
        self.videoManager = videoManager;
    }
    return self;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args {
    return [[ByteRTCFlutterSurfaceViewPlugin alloc] initWithMessager:self.messenger
                                                               frame:frame
                                                      viewIdentifier:viewId
                                                           arguments:args
                                                        videoManager:self.videoManager];
}

@end
