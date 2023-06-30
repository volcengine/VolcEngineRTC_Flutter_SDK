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
#import "ByteRTCFlutterPushSingleStreamToCDNObserver.h"
#import "ByteRTCVideoSnapshotEventObserver.h"
#import "ByteRTCFlutterVideoEffectPlugin.h"
#import "ByteRTCFlutterSingScoringPlugin.h"
#import "ByteRTCFlutterKTVManagerPlugin.h"

@interface ByteRTCFlutterVideoPlugin ()

@property (nonatomic, strong) ByteRTCVideo *rtcVideo;
@property (nonatomic, strong) NSMutableArray<ByteRTCFlutterPlugin *> *flutterPlugins;
@property (nonatomic, strong) NSMutableDictionary<NSNumber*, ByteRTCFlutterRoomPlugin*> *roomPlugins;
@property (nonatomic, strong) ByteRTCFlutterASREventHandler *asrEventHandler;
@property (nonatomic, strong) ByteRTCFlutterFaceDetectionHandler *faceDetectionHandler;
@property (nonatomic, strong) ByteRTCFlutterLiveTranscodingObserver *liveTranscodingObserver;
@property (nonatomic, strong) ByteRTCFlutterPushSingleStreamToCDNObserver *pushSingleStreamToCDNObserver;
@property (nonatomic, strong) ByteRTCVideoSnapshotEventObserver *snapshotEventObserver;
@property (nonatomic, strong, nullable) ByteRTCFlutterKTVManagerPlugin *ktvManager;

@end

@implementation ByteRTCFlutterVideoPlugin

- (instancetype)initWithRTCVideo:(ByteRTCVideo *)rtcVideo {
    self = [super init];
    if (self) {
        self.rtcVideo = rtcVideo;
        self.flutterPlugins = [NSMutableArray array];
        self.roomPlugins = [NSMutableDictionary dictionary];
        
        [self.flutterPlugins addObject:[[ByteRTCFlutterAudioMixingPlugin alloc] initWithRTCVideo:rtcVideo]];
        [self.flutterPlugins addObject:[[ByteRTCFlutterVideoEffectPlugin alloc] initWithRTCVideo:rtcVideo]];
        [self.flutterPlugins addObject:[[ByteRTCFlutterSingScoringPlugin alloc] initWithRTCVideo:rtcVideo]];
        
        self.asrEventHandler = [[ByteRTCFlutterASREventHandler alloc] init];
        self.faceDetectionHandler = [[ByteRTCFlutterFaceDetectionHandler alloc] init];
        self.liveTranscodingObserver = [[ByteRTCFlutterLiveTranscodingObserver alloc] init];
        self.pushSingleStreamToCDNObserver = [[ByteRTCFlutterPushSingleStreamToCDNObserver alloc] init];
        self.snapshotEventObserver = [[ByteRTCVideoSnapshotEventObserver alloc] init];
    }
    return self;
}

- (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [super registerWithRegistrar:registrar];
    
    [self.flutterPlugins enumerateObjectsUsingBlock:^(ByteRTCFlutterPlugin *obj, NSUInteger idx, BOOL *stop) {
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
    [self.pushSingleStreamToCDNObserver registerEventChannelWithName:@"com.bytedance.ve_rtc_push_single_stream_to_cdn"
                                                     binaryMessenger:[self.registrar messenger]];
    [self.snapshotEventObserver registerEventChannelWithName:@"com.bytedance.ve_rtc_snapshot_result"
                                             binaryMessenger:[self.registrar messenger]];
}

- (void)destroy {
    [super destroy];
    [self.flutterPlugins enumerateObjectsUsingBlock:^(ByteRTCFlutterPlugin *obj, NSUInteger idx, BOOL *stop) {
        [obj destroy];
    }];
    [self.roomPlugins enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, ByteRTCFlutterRoomPlugin *obj, BOOL *stop) {
        [obj destroy];
    }];
    [self.roomPlugins removeAllObjects];
    [self.asrEventHandler destroy];
    [self.faceDetectionHandler destroy];
    [self.liveTranscodingObserver destroy];
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
    [self.rtcVideo startAudioCapture];
    result(nil);
}

- (void)stopAudioCapture:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.rtcVideo stopAudioCapture];
    result(nil);
}

- (void)setAudioScenario:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCAudioScenarioType type = [arguments[@"audioScenario"] integerValue];
    [self.rtcVideo setAudioScenario:type];
    result(nil);
}

- (void)setAudioProfile:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCAudioProfileType type = [arguments[@"audioProfile"] integerValue];
    [self.rtcVideo setAudioProfile:type];
    result(nil);
}

- (void)setAnsMode:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCAnsMode ansMode = [arguments[@"ansMode"] integerValue];
    [self.rtcVideo setAnsMode:ansMode];
    result(nil);
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

- (void)setCaptureVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex index = [arguments[@"index"] integerValue];
    int volume = [arguments[@"volume"] intValue];
    [self.rtcVideo setCaptureVolume:index volume:volume];
    result(nil);
}

- (void)setPlaybackVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    NSInteger volume = [arguments[@"volume"] integerValue];
    [self.rtcVideo setPlaybackVolume:volume];
    result(nil);
}

- (void)enableAudioPropertiesReport:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCAudioPropertiesConfig *config = [ByteRTCAudioPropertiesConfig bf_fromMap:arguments[@"config"]];
    [self.rtcVideo enableAudioPropertiesReport:config];
    result(nil);
}

- (void)setRemoteAudioPlaybackVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *roomId = arguments[@"roomId"];
    NSString *uid = arguments[@"uid"];
    int volume = [arguments[@"volume"] intValue];
    [self.rtcVideo setRemoteAudioPlaybackVolume:roomId remoteUid:uid playVolume:volume];
    result(nil);
}

- (void)setEarMonitorMode:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCEarMonitorMode mode = [arguments[@"mode"] integerValue];
    [self.rtcVideo setEarMonitorMode:mode];
    result(nil);
}

- (void)setEarMonitorVolume:(NSDictionary *)arguments result:(FlutterResult)result {
    NSInteger volume = [arguments[@"volume"] integerValue];
    [self.rtcVideo setEarMonitorVolume:volume];
    result(nil);
}

- (void)setBluetoothMode:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCBluetoothMode mode = [arguments[@"mode"] integerValue];
    [self.rtcVideo setBluetoothMode:mode];
    result(nil);
}

- (void)setLocalVoicePitch:(NSDictionary *)arguments result:(FlutterResult)result {
    NSInteger pitch = [arguments[@"pitch"] integerValue];
    [self.rtcVideo setLocalVoicePitch:pitch];
    result(nil);
}

- (void)enableVocalInstrumentBalance:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL enable = [arguments[@"enable"] boolValue];
    [self.rtcVideo enableVocalInstrumentBalance:enable];
    result(nil);
}

- (void)enablePlaybackDucking:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL enable = [arguments[@"enable"] boolValue];
    [self.rtcVideo enablePlaybackDucking:enable];
    result(nil);
}

#pragma mark Core Video Methods

- (void)enableSimulcastMode:(NSDictionary *)arguments result:(FlutterResult)result {
    BOOL enable = [arguments[@"enable"] boolValue];
    [self.rtcVideo enableSimulcastMode:enable];
    result(nil);
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
    [self.rtcVideo setRemoteVideoCanvas:streamKey
                             withCanvas:canvas];
    result(nil);
}

- (void)startVideoCapture:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.rtcVideo startVideoCapture];
    result(nil);
}

- (void)stopVideoCapture:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.rtcVideo stopVideoCapture];
    result(nil);
}

- (void)setLocalVideoMirrorType:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCMirrorType mirrorType = [arguments[@"mirrorType"] integerValue];
    [self.rtcVideo setLocalVideoMirrorType:mirrorType];
    result(nil);
}

- (void)setVideoRotationMode:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVideoRotationMode rotationMode = [arguments[@"rotationMode"] integerValue];
    [self.rtcVideo setVideoRotationMode:rotationMode];
    result(nil);
}

- (void)setVideoOrientation:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVideoOrientation orientation = [arguments[@"orientation"] integerValue];
    [self.rtcVideo setVideoOrientation:orientation];
    result(nil);
}

- (void)switchCamera:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCCameraID cameraId = [arguments[@"cameraId"] integerValue];
    [self.rtcVideo switchCamera:cameraId];
    result(nil);
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

#pragma mark - VideoFrameObserver InnerVideoSource

- (void)setVideoDigitalZoomConfig:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCZoomConfigType type = [arguments[@"type"] integerValue];
    float size = [arguments[@"size"] floatValue];
    [self.rtcVideo setVideoDigitalZoomConfig:type size:size];
    result(nil);
}

- (void)setVideoDigitalZoomControl:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCZoomDirectionType direction = [arguments[@"direction"] integerValue];
    [self.rtcVideo setVideoDigitalZoomControl:direction];
    result(nil);
}

- (void)startVideoDigitalZoomControl:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCZoomDirectionType direction = [arguments[@"direction"] integerValue];
    [self.rtcVideo startVideoDigitalZoomControl:direction];
    result(nil);
}

- (void)stopVideoDigitalZoomControl:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.rtcVideo stopVideoDigitalZoomControl];
    result(nil);
}

#pragma mark Audio Routing Controller

- (void)setAudioRoute:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCAudioRoute audioRoute = [arguments[@"audioRoute"] integerValue];
    [self.rtcVideo setAudioRoute:audioRoute];
    result(nil);
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
    [self.rtcVideo enableExternalSoundCard:enable];
    result(nil);
}

#pragma mark Combined to Push

- (void)startLiveTranscoding:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *taskId = arguments[@"taskId"];
    NSDictionary *transcodingDict = arguments[@"transcoding"];
    [self.rtcVideo startLiveTranscoding:taskId
                            transcoding:[ByteRTCLiveTranscoding bf_fromMap:transcodingDict]
                               observer:self.liveTranscodingObserver];
    result(nil);
}

- (void)stopLiveTranscoding:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *taskId = arguments[@"taskId"];
    [self.rtcVideo stopLiveTranscoding:taskId];
    result(nil);
}

- (void)updateLiveTranscoding:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *taskId = arguments[@"taskId"];
    NSDictionary *transcodingDict = arguments[@"transcoding"];
    [self.rtcVideo updateLiveTranscoding:taskId
                             transcoding:[ByteRTCLiveTranscoding bf_fromMap:transcodingDict]];
    result(nil);
}

#pragma mark oush single streaming

- (void)startPushSingleStreamToCDN:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *taskId = arguments[@"taskId"];
    ByteRTCPushSingleStreamParam *param = [ByteRTCPushSingleStreamParam bf_fromMap:arguments[@"param"]];
    [self.rtcVideo startPushSingleStreamToCDN:taskId
                                 singleStream:param
                                     observer:self.pushSingleStreamToCDNObserver];
    result(nil);
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
    NSString *problemDesc = arguments[@"problemDesc"];
    NSMutableArray<ByteRTCProblemOption *> *options = [NSMutableArray array];
    [types enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ByteRTCProblemOption *option = [[ByteRTCProblemOption alloc] initWithOption:obj.integerValue];
        [options addObject:option];
    }];
    int res = [self.rtcVideo feedback:options desc:problemDesc];
    result(@(res));
}

#pragma mark Fallback Related

- (void)setPublishFallbackOption:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCPublishFallbackOption option = [arguments[@"option"] integerValue];
    [self.rtcVideo setPublishFallbackOption:option];
    result(nil);
}

- (void)setSubscribeFallbackOption:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCSubscribeFallbackOption option = [arguments[@"option"] integerValue];
    [self.rtcVideo setSubscribeFallbackOption:option];
    result(nil);
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
    [self.rtcVideo setEncryptInfo:aesType key:key];
    result(nil);
}

#pragma mark - ScreenCapture

- (void)startScreenCapture:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCScreenMediaType type = [arguments[@"type"] integerValue];
    [self.rtcVideo startScreenCapture:type bundleId:[ByteRTCVideoManager shared].bundleId];
    result(nil);
}

- (void)updateScreenCapture:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCScreenMediaType type = [arguments[@"type"] integerValue];
    [self.rtcVideo updateScreenCapture:type];
    result(nil);
}

- (void)stopScreenCapture:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.rtcVideo stopScreenCapture];
    result(nil);
}

- (void)sendScreenCaptureExtensionMessage:(NSDictionary *)arguments result:(FlutterResult)result {
    FlutterStandardTypedData *message = arguments[@"message"];
    [self.rtcVideo sendScreenCaptureExtensionMessage:message.data];
    result(nil);
}

- (void)setRuntimeParameters:(NSDictionary *)arguments result:(FlutterResult)result {
    NSDictionary *params = arguments[@"params"];
    [self.rtcVideo setRuntimeParameters:params];
    result(nil);
}

#pragma mark - ASR

- (void)startASR:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCASRConfig *asrConfig = [ByteRTCASRConfig bf_fromMap:arguments[@"asrConfig"]];
    [self.rtcVideo startASR:asrConfig handler:self.asrEventHandler];
    result(nil);
}

- (void)stopASR:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.rtcVideo stopASR];
    result(nil);
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
    [self.rtcVideo stopFileRecording:streamIndex];
    result(nil);
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

#pragma mark - Rtm

- (void)login:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *token = arguments[@"token"];
    NSString *uid = arguments[@"uid"];
    int res = [self.rtcVideo login:token uid:uid];
    result(@(res));
}

- (void)logout:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.rtcVideo logout];
    result(nil);
}

- (void)updateLoginToken:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *token = arguments[@"token"];
    [self.rtcVideo updateLoginToken:token];
    result(nil);
}

- (void)setServerParams:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *signature = arguments[@"signature"];
    NSString *url = arguments[@"url"];
    [self.rtcVideo setServerParams:signature url:url];
    result(nil);
}

- (void)getPeerOnlineStatus:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *peerUserId = arguments[@"peerUid"];
    [self.rtcVideo getPeerOnlineStatus:peerUserId];
    result(nil);
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
    NSInteger res = [self.rtcVideo startNetworkDetection:isTestUplink
                                         uplinkBandwidth:expectedUplinkBitrate
                                                downlink:isTestDownlink
                                       downlinkBandwidth:expectedDownlinkBitrate];
    result(@(res));
}

- (void)stopNetworkDetection:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.rtcVideo stopNetworkDetection];
    result(nil);
}

#pragma mark  ScreenAudio

- (void)setScreenAudioStreamIndex:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamIndex = [arguments[@"streamIndex"] integerValue];
    [self.rtcVideo setScreenAudioStreamIndex:streamIndex];
    result(nil);
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
    [self.rtcVideo muteAudioPlayback:muteState];
    result(nil);
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
    [self.rtcVideo setVideoWatermark:streamIndex withImagePath:imagePath withRtcWatermarkConfig:config];
    result(nil);
}

- (void)clearVideoWatermark:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamIndex = [arguments[@"streamIndex"] integerValue];
    [self.rtcVideo clearVideoWatermark:streamIndex];
    result(nil);
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
    [self.rtcVideo startCloudProxy:cloudProxiesInfo];
    result(nil);
}

- (void)stopCloudProxy:(NSDictionary *)arguments result:(FlutterResult)result {
    [self.rtcVideo stopCloudProxy];
    result(nil);
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
    [self.rtcVideo setAudioAlignmentProperty:streamKey withMode:mode];
    result(nil);
}

- (void)invokeExperimentalAPI:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *param = arguments[@"param"];
    int res = [self.rtcVideo invokeExperimentalAPI:param];
    result(@(res));
}

#pragma mark - KTV
- (void)getKTVManager:(NSDictionary *)arguments result:(FlutterResult)result {
    if (self.ktvManager != nil) {
        result(@(YES));
        return;
    }
    ByteRTCKTVManager *ktvManager = [self.rtcVideo getKTVManager];
    BOOL res = !!ktvManager;
    if (res) {
        self.ktvManager = [[ByteRTCFlutterKTVManagerPlugin alloc] initWithRTCKTVManager:ktvManager];
        [self.ktvManager registerWithRegistrar:self.registrar];
        [self.flutterPlugins addObject:self.ktvManager];
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

@end
