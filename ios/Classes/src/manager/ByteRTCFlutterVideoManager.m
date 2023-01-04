/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/ByteRTCVideo.h>
#import <Flutter/Flutter.h>
#import "ByteRTCVideoManager+Extension.h"
#import "ByteRTCFlutterVideoManager.h"
#import "ByteRTCFlutterRoomManager.h"
#import "ByteRTCFlutterMapCategory.h"

@interface ByteRTCFlutterVideoManager ()

@property (nonatomic, strong, nullable) ByteRTCVideo *rtcVideo;

@end

@implementation ByteRTCFlutterVideoManager

- (ByteRTCVideo *)getRTCVideo {
    return self.rtcVideo;
}

- (ByteRTCRoom *)createRTCRoom:(NSString *)roomId {
    return [self.rtcVideo createRTCRoom:roomId];
}

- (void)destroy {
    [ByteRTCVideo destroyRTCVideo];
    self.rtcVideo = nil;
}

#pragma mark - method
#pragma mark Core Methods

- (void)createRTCVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *appId = arguments[@"appId"];
    NSDictionary *origParameters = arguments[@"parameters"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (origParameters.count != 0) {
        [parameters addEntriesFromDictionary:origParameters];
    }
    parameters[@"rtc.platform"] = @6;
    self.rtcVideo = [ByteRTCVideo createRTCVideo:appId
                                        delegate:self.delegate
                                      parameters:parameters];
    [self.rtcVideo setExtensionConfig:[ByteRTCVideoManager shared].groupId];
    [ByteRTCVideoManager shared].rtcVideo = self.rtcVideo;
    result(@((BOOL)(self.rtcVideo != nil)));
}

- (void)destroyRTCVideo:(NSDictionary *)arguments result:(FlutterResult)result {
    [self destroy];
    result(nil);
}

- (void)getSdkVersion:(NSDictionary *)arguments result:(FlutterResult)result {
    result([ByteRTCVideo getSdkVersion]);
}

- (void)getErrorDescription:(NSDictionary *)arguments result:(FlutterResult)result {
    NSInteger code = [arguments[@"code"] integerValue];
    NSString *description = [ByteRTCVideo getErrorDescription:code];
    result(description);
}

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

- (void)setVoiceChangerType:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVoiceChangerType voiceChanger = [arguments[@"voiceChanger"] integerValue];
    [self.rtcVideo setVoiceChangerType:voiceChanger];
    result(nil);
}

- (void)setVoiceReverbType:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVoiceReverbType voiceReverb = [arguments[@"voiceReverb"] integerValue];
    [self.rtcVideo setVoiceReverbType:voiceReverb];
    result(nil);
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
    int res = [self.rtcVideo enableSimulcastMode:enable];
    result(@(res));
}

- (void)setMaxVideoEncoderConfig:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVideoEncoderConfig *maxSolution = [ByteRTCVideoEncoderConfig bf_fromMap:arguments[@"maxSolution"]];
    int res = [self.rtcVideo SetMaxVideoEncoderConfig:maxSolution];
    result(@(res));
}

- (void)setVideoEncoderConfig:(NSDictionary *)arguments result:(FlutterResult)result {
    NSMutableArray<ByteRTCVideoEncoderConfig *> *channelSolutions = [NSMutableArray new];
    for (NSDictionary *dic in arguments[@"channelSolutions"]) {
        ByteRTCVideoEncoderConfig *videoEncoderConfig = [ByteRTCVideoEncoderConfig bf_fromMap:dic];
        [channelSolutions addObject:videoEncoderConfig];
    }
    int res = [self.rtcVideo SetVideoEncoderConfig:channelSolutions.copy];
    result(@(res));
}

- (void)setScreenVideoEncoderConfig:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVideoEncoderConfig *screenSolution = [ByteRTCVideoEncoderConfig bf_fromMap:arguments[@"screenSolution"]];
    int res = [self.rtcVideo SetScreenVideoEncoderConfig:screenSolution];
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
    NSString *roomId = arguments[@"roomId"];
    NSString *uid = arguments[@"uid"];
    ByteRTCStreamIndex streamType = [arguments[@"streamType"] integerValue];
    ByteRTCVideoCanvas *canvas = [[ByteRTCVideoCanvas alloc] init];
    canvas.roomId = roomId;
    canvas.uid = uid;
    int res = [self.rtcVideo setRemoteVideoCanvas:uid
                                        withIndex:streamType
                                       withCanvas:canvas];
    result(@(res));
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
    int res = [self.rtcVideo setLocalVideoMirrorType:mirrorType];
    result(@(res));
}

- (void)setVideoRotationMode:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVideoRotationMode rotationMode = [arguments[@"rotationMode"] integerValue];
    int res = [self.rtcVideo setVideoRotationMode:rotationMode];
    result(@(res));
}

- (void)setVideoOrientation:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCVideoOrientation orientation = [arguments[@"orientation"] integerValue];
    [self.rtcVideo setVideoOrientation:orientation];
    result(nil);
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
        res = [self.rtcVideo registerFaceDetectionObserver:self.faceDetectionObserver
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
    int res = [self.rtcVideo sendSEIMessage:streamIndex
                                 andMessage:message.data
                             andRepeatCount:repeatCount];
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
    [self.rtcVideo enableExternalSoundCard:enable];
    result(nil);
}

#pragma mark Combined to Push

- (void)startLiveTranscoding:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *taskId = arguments[@"taskId"];
    NSDictionary *transcodingDict = arguments[@"transcoding"];
    int res = [self.rtcVideo startLiveTranscoding:taskId
                                      transcoding:[ByteRTCLiveTranscoding bf_fromMap:transcodingDict]
                                         observer:self.liveTranscodingDelegate];
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

#pragma mark oush single streaming

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
    [self.rtcVideo setEncryptType:aesType key:key];
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
    [self.rtcVideo startASR:asrConfig handler:self.asrEventDelegate];
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

#pragma mark - Rtm

- (void)login:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *token = arguments[@"token"];
    NSString *uid = arguments[@"uid"];
    [self.rtcVideo login:token uid:uid];
    result(0);
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
    int64_t res = [self.rtcVideo sendUserMessageOutsideRoom:uid
                                                    message:message
                                                     config:config];
    result(@(res));
}

- (void)sendUserBinaryMessageOutsideRoom:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *uid = arguments[@"uid"];
    FlutterStandardTypedData *message = arguments[@"message"];
    ByteRTCMessageConfig config = [arguments[@"config"] integerValue];
    int64_t res = [self.rtcVideo sendUserBinaryMessageOutsideRoom:uid
                                                          message:message.data
                                                           config:config];
    result(@(res));
}

- (void)sendServerMessage:(NSDictionary *)arguments result:(FlutterResult)result {
    NSString *message = arguments[@"message"];
    int64_t res = [self.rtcVideo sendServerMessage:message];
    result(@(res));
}

- (void)sendServerBinaryMessage:(NSDictionary *)arguments result:(FlutterResult)result {
    FlutterStandardTypedData *message = arguments[@"message"];
    int64_t res = [self.rtcVideo sendServerBinaryMessage:message.data];
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

- (void)setVideoWatermark:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamIndex = [arguments[@"streamIndex"] integerValue];
    NSString *imagePath = arguments[@"imagePath"];
    ByteRTCVideoWatermarkConfig *config = [ByteRTCVideoWatermarkConfig bf_fromMap:arguments[@"watermarkConfig"]];
    [self.rtcVideo SetVideoWatermark:streamIndex WithImagePath:imagePath WithRtcWatermarkConfig:config];
    result(nil);
}

- (void)clearVideoWatermark:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCStreamIndex streamIndex = [arguments[@"streamIndex"] integerValue];
    [self.rtcVideo ClearVideoWatermark:streamIndex];
    result(nil);
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

- (void)startEchoTest:(NSDictionary *)arguments result:(FlutterResult)result {
    ByteRTCEchoTestConfig *config = [ByteRTCEchoTestConfig bf_fromMap:arguments[@"config"]];
    NSInteger delayTime = [arguments[@"delayTime"] integerValue];
    config.view = self.echoTestView;
    int res = [self.rtcVideo startEchoTest:config playDelay:delayTime];
    result(@(res));
}

- (void)stopEchoTest:(NSDictionary *)arguments result:(FlutterResult)result {
    int res = [self.rtcVideo stopEchoTest];
    result(@(res));
}

//- (void)setDummyCaptureImagePath:(NSDictionary *)arguments result:(FlutterResult)result {
//    NSString *filePath = arguments[@"filePath"];
//    int res = [self.rtcVideo setDummyCaptureImagePath:filePath];
//    result(@(res));
//}

@end
