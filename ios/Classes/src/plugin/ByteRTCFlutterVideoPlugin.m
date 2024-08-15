/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/ByteRTCVideo.h>
#import "ByteRTCFlutterVideoPlugin.h"
#import "ByteRTCVideoManager+Extension.h"
#import "ByteRTCFlutterMapCategory.h"
#import "ByteRTCFlutterRoomPlugin.h"
#import "ByteRTCFlutterAudioMixingPlugin.h"
#import "ByteRTCFlutterASREventHandler.h"
#import "ByteRTCFlutterLiveTranscodingObserver.h"
#import "ByteRTCFlutterCDNStreamObserver.h"
#import "ByteRTCVideoSnapshotEventObserver.h"
#import "ByteRTCFlutterVideoEffectPlugin.h"
#import "ByteRTCFlutterSingScoringPlugin.h"
#import "ByteRTCFlutterKTVManagerPlugin.h"
#import "ByteRTCFlutterAudioEffectPlayerPlugin.h"
#import "ByteRTCFlutterrMediaPlayerPlugin.h"

@interface ByteRTCFlutterVideoPlugin ()

@property (nonatomic, strong) ByteRTCVideo *rtcVideo;
@property (nonatomic, strong) NSMutableDictionary<NSString *, ByteRTCFlutterPlugin *> *flutterPlugins;
@property (nonatomic, strong) NSMutableDictionary<NSNumber*, ByteRTCFlutterRoomPlugin*> *roomPlugins;
@property (nonatomic, strong) ByteRTCFlutterASREventHandler *asrEventHandler;
@property (nonatomic, strong) ByteRTCFlutterFaceDetectionHandler *faceDetectionHandler;
@property (nonatomic, strong) ByteRTCFlutterLiveTranscodingObserver *liveTranscodingObserver;
@property (nonatomic, strong) ByteRTCFlutterMixedStreamObserver *mixedStreamObserver;
@property (nonatomic, strong) ByteRTCFlutterPushSingleStreamToCDNObserver *pushSingleStreamToCDNObserver;
@property (nonatomic, strong) ByteRTCVideoSnapshotEventObserver *snapshotEventObserver;

@end

@implementation ByteRTCFlutterVideoPlugin

- (instancetype)initWithRTCVideo:(ByteRTCVideo *)rtcVideo {
    self = [super init];
    if (self) {
        self.rtcVideo = rtcVideo;
        self.flutterPlugins = [NSMutableDictionary dictionary];
        self.roomPlugins = [NSMutableDictionary dictionary];
        
        [self.flutterPlugins setValue:[[ByteRTCFlutterAudioMixingPlugin alloc] initWithRTCVideo:rtcVideo] forKey:@"AudioMixing"];
        [self.flutterPlugins setValue:[[ByteRTCFlutterVideoEffectPlugin alloc] initWithRTCVideo:rtcVideo] forKey:@"VideoEffect"];
        
        self.asrEventHandler = [[ByteRTCFlutterASREventHandler alloc] init];
        self.faceDetectionHandler = [[ByteRTCFlutterFaceDetectionHandler alloc] init];
        self.liveTranscodingObserver = [[ByteRTCFlutterLiveTranscodingObserver alloc] init];
        self.mixedStreamObserver = [[ByteRTCFlutterMixedStreamObserver alloc] init];
        self.pushSingleStreamToCDNObserver = [[ByteRTCFlutterPushSingleStreamToCDNObserver alloc] init];
        self.snapshotEventObserver = [[ByteRTCVideoSnapshotEventObserver alloc] init];
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [super registerWithRegistrar:registrar];
    
    [self.flutterPlugins enumerateKeysAndObjectsUsingBlock:^(NSString *key, ByteRTCFlutterPlugin *obj, BOOL *stop) {
        [obj registerWithRegistrar:registrar];
    }];
    
    [self.methodHandler registerMethodChannelWithName:@"com.bytedance.ve_rtc_video"
                                         methodTarget:self
                                      binaryMessenger:[registrar messenger]];
    [self.asrEventHandler registerEventChannelWithName:@"com.bytedance.ve_rtc_asr"
                                       binaryMessenger:[self.registrar messenger]];
    [self.faceDetectionHandler registerEventChannelWithName:@"com.bytedance.ve_rtc_face_detection"
                                            binaryMessenger:[self.registrar messenger]];
    [self.liveTranscodingObserver registerEventChannelWithName:@"com.bytedance.ve_rtc_live_transcoding"
                                               binaryMessenger:[self.registrar messenger]];
    [self.mixedStreamObserver registerEventChannelWithName:@"com.bytedance.ve_rtc_mix_stream"
                                           binaryMessenger:[self.registrar messenger]];
    [self.pushSingleStreamToCDNObserver registerEventChannelWithName:@"com.bytedance.ve_rtc_push_single_stream_to_cdn"
                                                     binaryMessenger:[self.registrar messenger]];
    [self.snapshotEventObserver registerEventChannelWithName:@"com.bytedance.ve_rtc_snapshot_result"
                                             binaryMessenger:[self.registrar messenger]];
}

- (void)destroy {
    [super destroy];
    [self.flutterPlugins enumerateKeysAndObjectsUsingBlock:^(NSString *key, ByteRTCFlutterPlugin *obj, BOOL *stop) {
        [obj destroy];
    }];
    [self.roomPlugins enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, ByteRTCFlutterRoomPlugin *obj, BOOL *stop) {
        [obj destroy];
    }];
    [self.roomPlugins removeAllObjects];
    [self.asrEventHandler destroy];
    [self.faceDetectionHandler destroy];
    [self.liveTranscodingObserver destroy];
    [self.mixedStreamObserver destroy];
    [self.pushSingleStreamToCDNObserver destroy];
    [self.snapshotEventObserver destroy];
}

#pragma mark - method

- (void)createRTCRoom:(NSDictionary *)arguments result:(FlutterResult)result {
    NSNumber *insId = arguments[@"roomInsId"];
    NSString *roomId = arguments[@"roomId"];
    ByteRTCRoom *room = [self.rtcVideo createRTCRoom:roomId];
    if (room == nil) {
        result(@(NO));
        return;
    }
    ByteRTCFlutterRoomPlugin *roomPlugin = [ByteRTCFlutterRoomPlugin createWithRTCRoom:room
                                                                             roomInsId:insId.integerValue];
    [roomPlugin registerWithRegistrar:self.registrar];
    [self.roomPlugins setObject:roomPlugin forKey:insId];
    result(@(YES));
}

- (void)destroyRTCRoom:(NSDictionary *)arguments result:(FlutterResult)result {
    NSNumber *insId = arguments[@"insId"];
    ByteRTCFlutterRoomPlugin *roomPlugin = [self.roomPlugins objectForKey:insId];
    [self.roomPlugins removeObjectForKey:insId];
    [roomPlugin destroy];
    result(nil);
}

#pragma mark - method
#pragma mark Core Audio Methods

- (void)startAudioCapture:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.rtcVideo startAudioCapture];
    result(@(res));
}

- (void)stopAudioCapture:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.rtcVideo stopAudioCapture];
    result(@(res));
}

- (void)setAudioScenario:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCAudioScenarioType type = [arguments[@"audioScenario"] integerValue];
    int res = [self.rtcVideo setAudioScenario:type];
    result(@(res));
}

- (void)setAudioScene:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCAudioSceneType audioScene = [arguments[@"audioScene"] integerValue];
    int res = [self.rtcVideo setAudioScene:audioScene];
    result(@(res));
}

- (void)setAudioProfile:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCAudioProfileType type = [arguments[@"audioProfile"] integerValue];
    int res = [self.rtcVideo setAudioProfile:type];
    result(@(res));
}

- (void)setAnsMode:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCAnsMode ansMode = [arguments[@"ansMode"] integerValue];
    int res = [self.rtcVideo setAnsMode:ansMode];
    result(@(res));
}

- (void)setVoiceChangerType:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVoiceChangerType voiceChanger = [arguments[@"voiceChanger"] integerValue];
    int res = [self.rtcVideo setVoiceChangerType:voiceChanger];
    result(@(res));
}

- (void)setVoiceReverbType:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVoiceReverbType voiceReverb = [arguments[@"voiceReverb"] integerValue];
    int res = [self.rtcVideo setVoiceReverbType:voiceReverb];
    result(@(res));
}

- (void)setLocalVoiceEqualization:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVoiceEqualizationConfig *config = [ByteRTCVoiceEqualizationConfig bf_fromMap:arguments[@"config"]];
    int res = [self.rtcVideo setLocalVoiceEqualization:config];
    result(@(res));
}

- (void)setLocalVoiceReverbParam:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVoiceReverbConfig *config = [ByteRTCVoiceReverbConfig bf_fromMap:arguments[@"config"]];
    int res = [self.rtcVideo setLocalVoiceReverbParam:config];
    result(@(res));
}

- (void)enableLocalVoiceReverb:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL enable = [arguments[@"enable"] boolValue];
    int res = [self.rtcVideo enableLocalVoiceReverb:enable];
    result(@(res));
}

- (void)muteAudioCapture:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL mute = [arguments[@"mute"] boolValue];
    ByteRTCStreamIndex index = [arguments[@"index"] integerValue];
    int res = [self.rtcVideo muteAudioCapture:index mute:mute];

    result(@(res));
}

- (void)setCaptureVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex index = [arguments[@"index"] integerValue];
    int volume = [arguments[@"volume"] intValue];
    int res = [self.rtcVideo setCaptureVolume:index volume:volume];
    result(@(res));
}

- (void)setPlaybackVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    NSInteger volume = [arguments[@"volume"] integerValue];
    int res = [self.rtcVideo setPlaybackVolume:volume];
    result(@(res));
}

- (void)enableAudioPropertiesReport:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCAudioPropertiesConfig *config = [ByteRTCAudioPropertiesConfig bf_fromMap:arguments[@"config"]];
    int res = [self.rtcVideo enableAudioPropertiesReport:config];
    result(@(res));
}

- (void)setRemoteAudioPlaybackVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *roomId = arguments[@"roomId"];
    NSString *uid = arguments[@"uid"];
    int volume = [arguments[@"volume"] intValue];
    int res = [self.rtcVideo setRemoteAudioPlaybackVolume:roomId remoteUid:uid playVolume:volume];
    result(@(res));
}

- (void)setEarMonitorMode:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCEarMonitorMode mode = [arguments[@"mode"] integerValue];
    int res = [self.rtcVideo setEarMonitorMode:mode];
    result(@(res));
}

- (void)setEarMonitorVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    NSInteger volume = [arguments[@"volume"] integerValue];
    int res = [self.rtcVideo setEarMonitorVolume:volume];
    result(@(res));
}

- (void)setBluetoothMode:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCBluetoothMode mode = [arguments[@"mode"] integerValue];
    int res = [self.rtcVideo setBluetoothMode:mode];
    result(@(res));
}

- (void)setLocalVoicePitch:(NSDictionary *)arguments result:(FlutterResult)result {
    NSInteger pitch = [arguments[@"pitch"] integerValue];
    int res = [self.rtcVideo setLocalVoicePitch:pitch];
    result(@(res));
}

- (void)enableVocalInstrumentBalance:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL enable = [arguments[@"enable"] boolValue];
    int res = [self.rtcVideo enableVocalInstrumentBalance:enable];
    result(@(res));
}

- (void)enablePlaybackDucking:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL enable = [arguments[@"enable"] boolValue];
    int res = [self.rtcVideo enablePlaybackDucking:enable];
    result(@(res));
}

#pragma mark Core Video Methods

- (void)enableSimulcastMode:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL enable = [arguments[@"enable"] boolValue];
    int res = [self.rtcVideo enableSimulcastMode:enable];
    result(@(res));
}

- (void)setMaxVideoEncoderConfig:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVideoEncoderConfig *maxSolution = [ByteRTCVideoEncoderConfig bf_fromMap:arguments[@"maxSolution"]];
    int res = [self.rtcVideo setMaxVideoEncoderConfig:maxSolution];
    result(@(res));
}

- (void)setVideoEncoderConfig:(NSDictionary *)arguments result:(FlutterResult)result {
    NSMutableArray<ByteRTCVideoEncoderConfig *> *channelSolutions = [NSMutableArray new];
    for (NSDictionary *dic in arguments[@"channelSolutions"]) {
        ByteRTCVideoEncoderConfig *videoEncoderConfig = [ByteRTCVideoEncoderConfig bf_fromMap:dic];
        [channelSolutions addObject:videoEncoderConfig];
    }
    int res = [self.rtcVideo setVideoEncoderConfig:channelSolutions.copy];
    result(@(res));
}

- (void)setScreenVideoEncoderConfig:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCScreenVideoEncoderConfig *screenSolution = [ByteRTCScreenVideoEncoderConfig bf_fromMap:arguments[@"screenSolution"]];
    int res = [self.rtcVideo setScreenVideoEncoderConfig:screenSolution];
    result(@(res));
}

- (void)setVideoCaptureConfig:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVideoCaptureConfig *config = [ByteRTCVideoCaptureConfig bf_fromMap: arguments[@"config"]];
    int res = [self.rtcVideo setVideoCaptureConfig:config];
    result(@(res));
}

- (void)removeLocalVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamType = [arguments[@"streamType"] integerValue];
    int res = [self.rtcVideo setLocalVideoCanvas:streamType
                                      withCanvas:nil];
    result(@(res));
}

- (void)removeRemoteVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVideoCanvas *canvas = [[ByteRTCVideoCanvas alloc] init];
    
    ByteRTCRemoteStreamKey *streamKey = [ByteRTCRemoteStreamKey new];
    streamKey.roomId = arguments[@"roomId"];
    streamKey.userId = arguments[@"uid"];
    streamKey.streamIndex = [arguments[@"streamType"] integerValue];
    int res = [self.rtcVideo setRemoteVideoCanvas:streamKey
                                       withCanvas:canvas];
    result(@(res));
}

- (void)startVideoCapture:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.rtcVideo startVideoCapture];
    result(@(res));
}

- (void)stopVideoCapture:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.rtcVideo stopVideoCapture];
    result(@(res));
}

- (void)setLocalVideoMirrorType:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCMirrorType mirrorType = [arguments[@"mirrorType"] integerValue];
    int res = [self.rtcVideo setLocalVideoMirrorType:mirrorType];
    result(@(res));
}

- (void)setRemoteVideoMirrorType:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCRemoteStreamKey *streamKey = [ByteRTCRemoteStreamKey bf_fromMap: arguments[@"streamKey"]];
    ByteRTCRemoteMirrorType mirrorType = [arguments[@"mirrorType"] integerValue];
    int res = [self.rtcVideo setRemoteVideoMirrorType:streamKey withMirrorType:mirrorType];
    result(@(res));
}

- (void)setVideoRotationMode:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVideoRotationMode rotationMode = [arguments[@"rotationMode"] integerValue];
    int res = [self.rtcVideo setVideoRotationMode:rotationMode];
    result(@(res));
}

- (void)setVideoOrientation:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVideoOrientation orientation = [arguments[@"orientation"] integerValue];
    int res = [self.rtcVideo setVideoOrientation:orientation];
    result(@(res));
}

- (void)setVideoCaptureRotation:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVideoRotation rotation = [arguments[@"rotation"] integerValue];
    int res = [self.rtcVideo setVideoCaptureRotation:rotation];
    result(@(res));
}

- (void)switchCamera:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCCameraID cameraId = [arguments[@"cameraId"] integerValue];
    int res = [self.rtcVideo switchCamera:cameraId];
    result(@(res));
}

- (void)checkVideoEffectLicense:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *licenseFile = arguments[@"licenseFile"];
    int res = [self.rtcVideo checkVideoEffectLicense:licenseFile];
    result(@(res));
}

- (void)enableVideoEffect:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL enable = [arguments[@"enable"] boolValue];
    int res = [self.rtcVideo enableVideoEffect:enable];
    result(@(res));
}

- (void)setVideoEffectAlgoModelPath:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *modelPath = arguments[@"modelPath"];
    [self.rtcVideo setVideoEffectAlgoModelPath:modelPath];
    result(nil);
}

- (void)setVideoEffectNodes:(NSDictionary *)arguments result:(FlutterResult)result {
    NSArray<NSString *> *effectNodePaths = arguments[@"effectNodes"];
    int res = [self.rtcVideo setVideoEffectNodes:effectNodePaths];
    result(@(res));
}

- (void)updateVideoEffectNode:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *nodePath = arguments[@"effectNode"];
    NSString *nodeKey = arguments[@"key"];
    float nodeValue = [arguments[@"value"] floatValue];
    int res = [self.rtcVideo updateVideoEffectNode:nodePath
                                           nodeKey:nodeKey
                                         nodeValue:nodeValue];
    result(@(res));
}

- (void)setVideoEffectColorFilter:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *resPath = arguments[@"resFile"];
    int res = [self.rtcVideo setVideoEffectColorFilter:resPath];
    result(@(res));
}

- (void)setVideoEffectColorFilterIntensity:(NSDictionary *)arguments result:(FlutterResult)result {
    float intensity = [arguments[@"intensity"] floatValue];
    int res = [self.rtcVideo setVideoEffectColorFilterIntensity:intensity];
    result(@(res));
}

- (void)setBackgroundSticker:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *modelPath = arguments[@"modelPath"];
    ByteRTCVirtualBackgroundSource *source = [ByteRTCVirtualBackgroundSource bf_fromMap:arguments[@"source"]];
    int res = [self.rtcVideo setBackgroundSticker:modelPath source:source];
    result(@(res));
}

- (void)enableEffectBeauty:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL enable = [arguments[@"enable"] boolValue];
    int res = [self.rtcVideo enableEffectBeauty:enable];
    result(@(res));
}

- (void)setBeautyIntensity:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCEffectBeautyMode beautyMode = [arguments[@"beautyMode"] integerValue];
    float intensity = [arguments[@"intensity"] floatValue];
    int res = [self.rtcVideo setBeautyIntensity:beautyMode withIntensity:intensity];
    result(@(res));
}

- (void)registerFaceDetectionObserver:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL observer = [arguments[@"observer"] boolValue];
    NSInteger interval = [arguments[@"interval"] integerValue];
    int res = -1;
    if (observer) {
        res = [self.rtcVideo registerFaceDetectionObserver:self.faceDetectionHandler
                                              withInterval:interval];
    } else {
        res = [self.rtcVideo registerFaceDetectionObserver:nil
                                              withInterval:interval];
    }
    result(@(res));
}

- (void)setRemoteVideoSuperResolution:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCRemoteStreamKey *streamKey = [ByteRTCRemoteStreamKey bf_fromMap: arguments[@"streamKey"]];
    ByteRTCVideoSuperResolutionMode mode = [arguments[@"mode"] integerValue];
    int res = [self.rtcVideo setRemoteVideoSuperResolution:streamKey withMode:mode];
    result(@(res));
}

- (void)setVideoDenoiser:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVideoDenoiseMode mode = [arguments[@"mode"] integerValue];
    int res = [self.rtcVideo setVideoDenoiser:mode];
    result(@(res));
}

#pragma mark - ICameraControl

- (void)setCameraZoomRatio:(NSDictionary *)arguments result:(FlutterResult)result {
    float zoomVal = [arguments[@"zoom"] floatValue];
    int res = [self.rtcVideo setCameraZoomRatio:zoomVal];
    result(@(res));
}

- (void)getCameraZoomMaxRatio:(NSDictionary *)arguments result:(FlutterResult)result {
    float res = [self.rtcVideo getCameraZoomMaxRatio];
    result(@(res));
}

- (void)isCameraZoomSupported:(NSDictionary *)arguments result:(FlutterResult)result {
    bool res = [self.rtcVideo isCameraZoomSupported];
    result(@(res));
}

- (void)isCameraTorchSupported:(NSDictionary *)arguments result:(FlutterResult)result {
    bool res = [self.rtcVideo isCameraTorchSupported];
    result(@(res));
}

- (void)setCameraTorch:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCTorchState torchState = [arguments[@"torchState"] integerValue];
    int res = [self.rtcVideo setCameraTorch:torchState];
    result(@(res));
}

- (void)isCameraFocusPositionSupported:(NSDictionary *)arguments result:(FlutterResult)result {
    bool res = [self.rtcVideo isCameraFocusPositionSupported];
    result(@(res));
}

- (void)setCameraFocusPosition:(NSDictionary *)arguments result:(FlutterResult)result {
    CGPoint position = CGPointMake([arguments[@"x"] floatValue], [arguments[@"y"] floatValue]);
    int res = [self.rtcVideo setCameraFocusPosition:position];
    result(@(res));
}

- (void)isCameraExposurePositionSupported:(NSDictionary *)arguments result:(FlutterResult)result {
    bool res = [self.rtcVideo isCameraExposurePositionSupported];
    result(@(res));
}

- (void)setCameraExposurePosition:(NSDictionary *)arguments result:(FlutterResult)result {
    CGPoint position = CGPointMake([arguments[@"x"] floatValue], [arguments[@"y"] floatValue]);
    int res = [self.rtcVideo setCameraExposurePosition:position];
    result(@(res));
}

- (void)setCameraExposureCompensation:(NSDictionary *)arguments result:(FlutterResult)result {
    float val = [arguments[@"val"] floatValue];
    int res = [self.rtcVideo setCameraExposureCompensation:val];
    result(@(res));
}

- (void)enableCameraAutoExposureFaceMode:(NSDictionary *)arguments result:(FlutterResult)result {
    bool enable = [arguments[@"enable"] boolValue];
    int res = [self.rtcVideo enableCameraAutoExposureFaceMode:enable];
    result(@(res));
}

- (void)setCameraAdaptiveMinimumFrameRate:(NSDictionary *)arguments result:(FlutterResult)result {
    int framerate = [arguments[@"framerate"] intValue];
    int res = [self.rtcVideo setCameraAdaptiveMinimumFrameRate:framerate];
    result(@(res));
}

#pragma mark - MediaMetadataData InnerVideoSource

- (void)sendSEIMessage:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamIndex = [arguments[@"streamIndex"] integerValue];
    FlutterStandardTypedData *message = arguments[@"message"];
    int repeatCount = [arguments[@"repeatCount"] intValue];
    ByteRTCSEICountPerFrame countPerFrame = [arguments[@"mode"] intValue];
    int res = [self.rtcVideo sendSEIMessage:streamIndex
                                 andMessage:message.data
                             andRepeatCount:repeatCount
                           andCountPerFrame:countPerFrame
    ];
    result(@(res));
}

- (void)sendPublicStreamSEIMessage:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamIndex = [arguments[@"streamIndex"] integerValue];
    int channelId = [arguments[@"channelId"] intValue];
    FlutterStandardTypedData *message = arguments[@"message"];
    int repeatCount = [arguments[@"repeatCount"] intValue];
    ByteRTCSEICountPerFrame countPerFrame = [arguments[@"mode"] intValue];
    int res = [self.rtcVideo sendPublicStreamSEIMessage:streamIndex
                                 andChannelId:channelId
                                 andMessage:message.data
                             andRepeatCount:repeatCount
                           andCountPerFrame:countPerFrame
    ];
    result(@(res));
}

#pragma mark - VideoFrameObserver InnerVideoSource

- (void)setVideoDigitalZoomConfig:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCZoomConfigType type = [arguments[@"type"] integerValue];
    float size = [arguments[@"size"] floatValue];
    int res = [self.rtcVideo setVideoDigitalZoomConfig:type size:size];
    result(@(res));
}

- (void)setVideoDigitalZoomControl:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCZoomDirectionType direction = [arguments[@"direction"] integerValue];
    int res = [self.rtcVideo setVideoDigitalZoomControl:direction];
    result(@(res));
}

- (void)startVideoDigitalZoomControl:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCZoomDirectionType direction = [arguments[@"direction"] integerValue];
    int res = [self.rtcVideo startVideoDigitalZoomControl:direction];
    result(@(res));
}

- (void)stopVideoDigitalZoomControl:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.rtcVideo stopVideoDigitalZoomControl];
    result(@(res));
}

#pragma mark Audio Routing Controller

- (void)setAudioRoute:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCAudioRoute audioRoute = [arguments[@"audioRoute"] integerValue];
    int res = [self.rtcVideo setAudioRoute:audioRoute];
    result(@(res));
}

- (void)setDefaultAudioRoute:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCAudioRoute audioRoute = [arguments[@"audioRoute"] integerValue];
    int res = [self.rtcVideo setDefaultAudioRoute:audioRoute];
    result(@(res));
}

- (void)getAudioRoute:(NSDictionary *)arguments result:(FlutterResult)result {
    NSInteger res = [self.rtcVideo getAudioRoute];
    result(@(res));
}

- (void)enableExternalSoundCard:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL enable = [arguments[@"enable"] boolValue];
    int res = [self.rtcVideo enableExternalSoundCard:enable];
    result(@(res));
}

#pragma mark Push mixed or signle stream to CDN

- (void)startLiveTranscoding:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *taskId = arguments[@"taskId"];
    NSDictionary *transcodingDict = arguments[@"transcoding"];
    int res = [self.rtcVideo startLiveTranscoding:taskId
                                      transcoding:[ByteRTCLiveTranscoding bf_fromMap:transcodingDict]
                                         observer:self.liveTranscodingObserver];
    result(@(res));
}

- (void)stopLiveTranscoding:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *taskId = arguments[@"taskId"];
    int res = [self.rtcVideo stopLiveTranscoding:taskId];
    result(@(res));
}

- (void)updateLiveTranscoding:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *taskId = arguments[@"taskId"];
    NSDictionary *transcodingDict = arguments[@"transcoding"];
    int res = [self.rtcVideo updateLiveTranscoding:taskId
                                       transcoding:[ByteRTCLiveTranscoding bf_fromMap:transcodingDict]];
    result(@(res));
}

- (void)startPushMixedStreamToCDN:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *taskId = arguments[@"taskId"];
    NSDictionary *config = arguments[@"mixedConfig"];
    int res = [self.rtcVideo startPushMixedStreamToCDN:taskId
                                           mixedConfig:[ByteRTCMixedStreamConfig bf_fromMap:config]
                                              observer:self.mixedStreamObserver];
    result(@(res));
}

- (void)updatePushMixedStreamToCDN:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *taskId = arguments[@"taskId"];
    NSDictionary *config = arguments[@"mixedConfig"];
    int res = [self.rtcVideo updatePushMixedStreamToCDN:taskId
                                            mixedConfig:[ByteRTCMixedStreamConfig bf_fromMap:config]];
    result(@(res));
}

- (void)startPushSingleStreamToCDN:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *taskId = arguments[@"taskId"];
    ByteRTCPushSingleStreamParam *param = [ByteRTCPushSingleStreamParam bf_fromMap:arguments[@"param"]];
    int res = [self.rtcVideo startPushSingleStreamToCDN:taskId
                                           singleStream:param
                                               observer:self.pushSingleStreamToCDNObserver];
    result(@(res));
}

- (void)stopPushStreamToCDN:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *taskId = arguments[@"taskId"];
    int res = [self.rtcVideo stopPushStreamToCDN:taskId];
    result(@(res));
}

#pragma mark public streaming

- (void)startPushPublicStream:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *publicStreamId = arguments[@"publicStreamId"];
    ByteRTCPublicStreaming *publicStreamParam = [ByteRTCPublicStreaming bf_fromMap:arguments[@"publicStreamParam"]];
    int res = [self.rtcVideo startPushPublicStream:publicStreamId
                                        withLayout:publicStreamParam];
    result(@(res));
}

- (void)stopPushPublicStream:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *publicStreamId = arguments[@"publicStreamId"];
    int res = [self.rtcVideo stopPushPublicStream:publicStreamId];
    result(@(res));
}

- (void)updatePublicStreamParam:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *publicStreamId = arguments[@"publicStreamId"];
    ByteRTCPublicStreaming *publicStreamParam = [ByteRTCPublicStreaming bf_fromMap:arguments[@"publicStreamParam"]];
    int res = [self.rtcVideo updatePublicStreamParam:publicStreamId
                                          withLayout:publicStreamParam];
    result(@(res));
}

- (void)startPlayPublicStream:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *publicStreamId = arguments[@"publicStreamId"];
    int res = [self.rtcVideo startPlayPublicStream:publicStreamId];
    result(@(res));
}

- (void)stopPlayPublicStream:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *publicStreamId = arguments[@"publicStreamId"];
    int res = [self.rtcVideo stopPlayPublicStream:publicStreamId];
    result(@(res));
}

- (void)removePublicStreamVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *publicStreamId = arguments[@"publicStreamId"];
    int res = [self.rtcVideo setPublicStreamVideoCanvas:publicStreamId withCanvas:nil];
    result(@(res));
}

- (void)setPublicStreamAudioPlaybackVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *publicStreamId = arguments[@"publicStreamId"];
    NSInteger volume = [arguments[@"volume"] integerValue];
    int res = [self.rtcVideo setPublicStreamAudioPlaybackVolume:publicStreamId volume:volume];
    result(@(res));
}

#pragma mark Others

- (void)setBusinessId:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString * businessId = arguments[@"businessId"];
    int res = [self.rtcVideo setBusinessId:businessId];
    result(@(res));
}

- (void)feedback:(NSDictionary *)arguments result:(FlutterResult)result {
    NSArray *types = arguments[@"types"];
    __block ByteRTCProblemFeedbackOption option = ByteRTCProblemFeedbackOptionNone;
    [types enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        option |= [obj unsignedLongLongValue];
    }];
    ByteRTCProblemFeedbackInfo *info = [ByteRTCProblemFeedbackInfo bf_fromMap:arguments[@"info"]];
    int res = [self.rtcVideo feedback:option info:info];
    result(@(res));
}

#pragma mark Fallback Related

- (void)setPublishFallbackOption:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCPublishFallbackOption option = [arguments[@"option"] integerValue];
    int res = [self.rtcVideo setPublishFallbackOption:option];
    result(@(res));
}

- (void)setSubscribeFallbackOption:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCSubscribeFallbackOption option = [arguments[@"option"] integerValue];
    int res = [self.rtcVideo setSubscribeFallbackOption:option];
    result(@(res));
}

- (void)setRemoteUserPriority:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCRemoteUserPriority priority = [arguments[@"priority"] integerValue];
    NSString *roomId = arguments[@"roomId"];
    NSString *uid = arguments[@"uid"];
    int res = [self.rtcVideo setRemoteUserPriority:priority InRoomId:roomId uid:uid];
    result(@(res));
}

#pragma mark AES Related

- (void)setEncryptInfo:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCEncryptType aesType = [arguments[@"aesType"] integerValue];
    NSString *key = arguments[@"key"];
    int res = [self.rtcVideo setEncryptInfo:aesType key:key];
    result(@(res));
}

#pragma mark - ScreenCapture

- (void)startScreenCapture:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCScreenMediaType type = [arguments[@"type"] integerValue];
    int res = [self.rtcVideo startScreenCapture:type bundleId:[ByteRTCVideoManager shared].bundleId];
    result(@(res));
}

- (void)updateScreenCapture:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCScreenMediaType type = [arguments[@"type"] integerValue];
    int res = [self.rtcVideo updateScreenCapture:type];
    result(@(res));
}

- (void)stopScreenCapture:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.rtcVideo stopScreenCapture];
    result(@(res));
}

- (void)sendScreenCaptureExtensionMessage:(NSDictionary *)arguments result:(FlutterResult)result {
    FlutterStandardTypedData *message = arguments[@"message"];
    int res = [self.rtcVideo sendScreenCaptureExtensionMessage:message.data];
    result(@(res));
}

- (void)setRuntimeParameters:(NSDictionary *)arguments result:(FlutterResult)result {
    NSDictionary *params = arguments[@"params"];
    int res = [self.rtcVideo setRuntimeParameters:params];
    result(@(res));
}

#pragma mark - ASR

- (void)startASR:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCASRConfig *asrConfig = [ByteRTCASRConfig bf_fromMap:arguments[@"asrConfig"]];
    int res = [self.rtcVideo startASR:asrConfig handler:self.asrEventHandler];
    result(@(res));
}

- (void)stopASR:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.rtcVideo stopASR];
    result(@(res));
}

#pragma mark - FileRecording

- (void)startFileRecording:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamIndex = [arguments[@"streamIndex"] integerValue];
    ByteRTCRecordingConfig *config = [ByteRTCRecordingConfig bf_fromMap:arguments[@"config"]];
    ByteRTCRecordingType recordingType = [arguments[@"recordingType"] integerValue];
    int res = [self.rtcVideo startFileRecording:streamIndex
                            withRecordingConfig:config
                                           type:recordingType];
    result(@(res));
}

- (void)stopFileRecording:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamIndex = [arguments[@"streamIndex"] integerValue];
    int res = [self.rtcVideo stopFileRecording:streamIndex];
    result(@(res));
}

- (void)startAudioRecording:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCAudioRecordingConfig *config = [ByteRTCAudioRecordingConfig bf_fromMap:arguments[@"config"]];
    int res = [self.rtcVideo startAudioRecording:config];
    result(@(res));
}

- (void)stopAudioRecording:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.rtcVideo stopAudioRecording];
    result(@(res));
}

- (void)getAudioEffectPlayer:(NSDictionary *)arguments result:(FlutterResult)result {
    if (self.flutterPlugins[@"AudioEffectPlayer"] != nil) {
        result(@(YES));
        return;
    }
    ByteRTCAudioEffectPlayer *player = [self.rtcVideo getAudioEffectPlayer];
    BOOL res = !!player;
    if (res) {
        ByteRTCFlutterAudioEffectPlayerPlugin *plugin = [[ByteRTCFlutterAudioEffectPlayerPlugin alloc] initWithRTCAudioEffectPlayer:player];
        [plugin registerWithRegistrar:self.registrar];
        [self.flutterPlugins setValue:plugin forKey:@"AudioEffectPlayer"];
    }
    result(@(res));
}

- (void)getMediaPlayer:(NSDictionary *)arguments result:(FlutterResult)result {
    int playerId = [arguments[@"playerId"] intValue];
    NSString *key = [NSString stringWithFormat:@"MediaPlayer%d", playerId];
    if (self.flutterPlugins[key] != nil) {
        result(@(YES));
        return;
    }
    ByteRTCMediaPlayer *player = [self.rtcVideo getMediaPlayer:playerId];
    BOOL res = !!player;
    if (res) {
        ByteRTCFlutterrMediaPlayerPlugin *plugin = [[ByteRTCFlutterrMediaPlayerPlugin alloc] initWithRTCMediaPlayer:player
                                                                                                           playerId:playerId];
        [plugin registerWithRegistrar:self.registrar];
        [self.flutterPlugins setValue:plugin forKey:key];
    }
    result(@(res));
}

#pragma mark - Rtm

- (void)login:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *token = arguments[@"token"];
    NSString *uid = arguments[@"uid"];
    int res = [self.rtcVideo login:token uid:uid];
    result(@(res));
}

- (void)logout:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.rtcVideo logout];
    result(@(res));
}

- (void)updateLoginToken:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *token = arguments[@"token"];
    int res = [self.rtcVideo updateLoginToken:token];
    result(@(res));
}

- (void)setServerParams:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *signature = arguments[@"signature"];
    NSString *url = arguments[@"url"];
    int res = [self.rtcVideo setServerParams:signature url:url];
    result(@(res));
}

- (void)getPeerOnlineStatus:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *peerUserId = arguments[@"peerUid"];
    int res = [self.rtcVideo getPeerOnlineStatus:peerUserId];
    result(@(res));
}

- (void)sendUserMessageOutsideRoom:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *uid = arguments[@"uid"];
    NSString *message = arguments[@"message"];
    ByteRTCMessageConfig config = [arguments[@"config"] integerValue];
    NSInteger res = [self.rtcVideo sendUserMessageOutsideRoom:uid
                                                      message:message
                                                       config:config];
    result(@(res));
}

- (void)sendUserBinaryMessageOutsideRoom:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *uid = arguments[@"uid"];
    FlutterStandardTypedData *message = arguments[@"message"];
    ByteRTCMessageConfig config = [arguments[@"config"] integerValue];
    NSInteger res = [self.rtcVideo sendUserBinaryMessageOutsideRoom:uid
                                                            message:message.data
                                                             config:config];
    result(@(res));
}

- (void)sendServerMessage:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *message = arguments[@"message"];
    NSInteger res = [self.rtcVideo sendServerMessage:message];
    result(@(res));
}

- (void)sendServerBinaryMessage:(NSDictionary *)arguments result:(FlutterResult)result {
    FlutterStandardTypedData *message = arguments[@"message"];
    NSInteger res = [self.rtcVideo sendServerBinaryMessage:message.data];
    result(@(res));
}

- (void)startNetworkDetection:(NSDictionary *)arguments result:(FlutterResult)result {
    bool isTestUplink = [arguments[@"isTestUplink"] boolValue];
    int expectedUplinkBitrate = [arguments[@"expectedUplinkBitrate"] intValue];
    bool isTestDownlink = [arguments[@"isTestDownlink"] boolValue];
    int expectedDownlinkBitrate = [arguments[@"expectedDownlinkBitrate"] intValue];
    int res = [self.rtcVideo startNetworkDetection:isTestUplink
                                   uplinkBandwidth:expectedUplinkBitrate
                                          downlink:isTestDownlink
                                 downlinkBandwidth:expectedDownlinkBitrate];
    result(@(res));
}

- (void)stopNetworkDetection:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.rtcVideo stopNetworkDetection];
    result(@(res));
}

#pragma mark  ScreenAudio

- (void)setScreenAudioStreamIndex:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamIndex = [arguments[@"streamIndex"] integerValue];
    int res = [self.rtcVideo setScreenAudioStreamIndex:streamIndex];
    result(@(res));
}

#pragma mark StreamSyncInfo

- (void)sendStreamSyncInfo:(NSDictionary *)arguments result:(FlutterResult)result {
    FlutterStandardTypedData *data = arguments[@"data"];
    ByteRTCStreamSycnInfoConfig *config = [ByteRTCStreamSycnInfoConfig bf_fromMap:arguments[@"config"]];
    int res = [self.rtcVideo sendStreamSyncInfo:data.data config:config];
    result(@(res));
}

- (void)muteAudioPlayback:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCMuteState muteState = [arguments[@"muteState"] integerValue];
    int res = [self.rtcVideo muteAudioPlayback:muteState];
    result(@(res));
}

- (void)startEchoTest:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCEchoTestConfig *config = [ByteRTCEchoTestConfig bf_fromMap:arguments[@"config"]];
    NSInteger delayTime = [arguments[@"delayTime"] integerValue];
    config.view = [ByteRTCVideoManager shared].echoTestView;
    int res = [self.rtcVideo startEchoTest:config playDelay:delayTime];
    result(@(res));
}

- (void)stopEchoTest:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.rtcVideo stopEchoTest];
    result(@(res));
}

- (void)setVideoWatermark:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamIndex = [arguments[@"streamIndex"] integerValue];
    NSString *imagePath = arguments[@"imagePath"];
    ByteRTCVideoWatermarkConfig *config = [ByteRTCVideoWatermarkConfig bf_fromMap:arguments[@"watermarkConfig"]];
    int res = [self.rtcVideo setVideoWatermark:streamIndex withImagePath:imagePath withRtcWatermarkConfig:config];
    result(@(res));
}

- (void)clearVideoWatermark:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamIndex = [arguments[@"streamIndex"] integerValue];
    int res = [self.rtcVideo clearVideoWatermark:streamIndex];
    result(@(res));
}

- (void)takeLocalSnapshot:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamIndex = [arguments[@"streamIndex"] integerValue];
    NSString *filePath = arguments[@"filePath"];
    NSInteger taskId = [self.rtcVideo takeLocalSnapshot:streamIndex callback:self.snapshotEventObserver];
    [self.snapshotEventObserver addFilePath:filePath forId:taskId];
    result(@(taskId));
}

- (void)takeRemoteSnapshot:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCRemoteStreamKey *streamKey = [ByteRTCRemoteStreamKey bf_fromMap: arguments[@"streamKey"]];
    NSString *filePath = arguments[@"filePath"];
    NSInteger taskId = [self.rtcVideo takeRemoteSnapshot:streamKey callback:self.snapshotEventObserver];
    [self.snapshotEventObserver addFilePath:filePath forId:taskId];
    result(@(taskId));
}

- (void)startCloudProxy:(NSDictionary *)arguments result:(FlutterResult)result {
    NSArray *cloudProxies = arguments[@"cloudProxiesInfo"];
    NSMutableArray<ByteRTCCloudProxyInfo *> *cloudProxiesInfo = [NSMutableArray array];
    [cloudProxies enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ByteRTCCloudProxyInfo *info = [ByteRTCCloudProxyInfo bf_fromMap:obj];
        [cloudProxiesInfo addObject:info];
    }];
    int res = [self.rtcVideo startCloudProxy:cloudProxiesInfo];
    result(@(res));
}

- (void)stopCloudProxy:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.rtcVideo stopCloudProxy];
    result(@(res));
}

- (void)getSingScoringManager:(NSDictionary *)arguments result:(FlutterResult)result {
    if (self.flutterPlugins[@"SingScoring"] != nil) {
        result(@(YES));
        return;
    }
    ByteRTCSingScoringManager *manager = [self.rtcVideo getSingScoringManager];
    BOOL res = !!manager;
    if (res) {
        ByteRTCFlutterSingScoringPlugin *plugin = [[ByteRTCFlutterSingScoringPlugin alloc] initWithRTCSingScoringManager:manager];
        [plugin registerWithRegistrar:self.registrar];
        [self.flutterPlugins setValue:plugin forKey:@"SingScoring"];
    }
    result(@(res));
}

- (void)setDummyCaptureImagePath:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *filePath = arguments[@"filePath"];
    int res = [self.rtcVideo setDummyCaptureImagePath:filePath];
    result(@(res));
}

- (void)getNetworkTimeInfo:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCNetworkTimeInfo *info = [self.rtcVideo getNetworkTimeInfo];
    if (!info) {
        result(nil);
        return;
    }
    result(@{@"timestamp": @(info.timestamp)});
}

- (void)setAudioAlignmentProperty:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCRemoteStreamKey *streamKey = [ByteRTCRemoteStreamKey bf_fromMap: arguments[@"streamKey"]];
    ByteRTCAudioAlignmentMode mode = [arguments[@"mode"] integerValue];
    int res = [self.rtcVideo setAudioAlignmentProperty:streamKey withMode:mode];
    result(@(res));
}

- (void)invokeExperimentalAPI:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *param = arguments[@"param"];
    int res = [self.rtcVideo invokeExperimentalAPI:param];
    result(@(res));
}

#pragma mark - KTV
- (void)getKTVManager:(NSDictionary *)arguments result:(FlutterResult)result {
    if (self.flutterPlugins[@"KTVManager"] != nil) {
        result(@(YES));
        return;
    }
    ByteRTCKTVManager *ktvManager = [self.rtcVideo getKTVManager];
    BOOL res = !!ktvManager;
    if (res) {
        ByteRTCFlutterKTVManagerPlugin *plugin = [[ByteRTCFlutterKTVManagerPlugin alloc] initWithRTCKTVManager:ktvManager];
        [plugin registerWithRegistrar:self.registrar];
        [self.flutterPlugins setValue:plugin forKey:@"KTVManager"];
    }
    result(@(res));
}

- (void)startHardwareEchoDetection:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *testAudioFilePath = arguments[@"testAudioFilePath"];
    int res = [self.rtcVideo startHardwareEchoDetection:testAudioFilePath];
    result(@(res));
}

- (void)stopHardwareEchoDetection:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.rtcVideo stopHardwareEchoDetection];
    result(@(res));
}

- (void)setCellularEnhancement:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCMediaTypeEnhancementConfig *config = [ByteRTCMediaTypeEnhancementConfig bf_fromMap:arguments[@"config"]];
    int res = [self.rtcVideo setCellularEnhancement:config];
    result(@(res));
}

- (void)setLocalProxy:(NSDictionary *)arguments result:(FlutterResult)result {
    NSArray *configs = arguments[@"configurations"];
    NSMutableArray<ByteRTCLocalProxyInfo *> *configurations = [NSMutableArray array];
    [configs enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [configurations addObject:[ByteRTCLocalProxyInfo bf_fromMap:obj]];
    }];
    int res = [self.rtcVideo setLocalProxy:configurations];
    result(@(res));
}

@end
