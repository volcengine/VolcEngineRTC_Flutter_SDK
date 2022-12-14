/*
 * Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
 * SPDX-License-Identifier: MIT
 */

#import <VolcEngineRTC/objc/rtc/ByteRTCCommonDefines.h>
#import <VolcEngineRTC/objc/rtc/ByteRTCAudioDefines.h>
#import <VolcEngineRTC/objc/rtc/ByteRTCVideoDefines.h>
#import <VolcEngineRTC/objc/rtc/ByteRTCSpatialAudio.h>
#import <VolcEngineRTC/objc/rtc/ByteRTCRangeAudio.h>

NS_ASSUME_NONNULL_BEGIN

@interface ByteRTCFlutterEventfactory : NSObject

+ (NSDictionary *)networkQualityStatsToMap:(ByteRTCNetworkQualityStats *)stats;

@end

@interface ByteRTCUser (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCLocalStreamStats (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCRemoteStreamStats (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCRemoteAudioStats (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCRemoteVideoStats (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCSysStats (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCSourceWantedData (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCRemoteStreamSwitchEvent (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCRemoteStreamKey (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCVideoFrameInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCTranscoderLayoutRegionDataParam (ByteRTCFlutterMapCategory)

+ (ByteRTCTranscoderLayoutRegionDataParam *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCVideoCompositingRegion (ByteRTCFlutterMapCategory)

+ (ByteRTCVideoCompositingRegion *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCLiveTranscoding (ByteRTCFlutterMapCategory)

+ (ByteRTCLiveTranscoding *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCRoomStats (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCAudioMixingConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCAudioMixingConfig *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ReceiveRange (ByteRTCFlutterMapCategory)

+ (ReceiveRange *)bf_fromMap:(NSDictionary *)dict;

@end

@interface Position (ByteRTCFlutterMapCategory)

+ (Position *)bf_fromMap:(NSDictionary *)dict;

@end

@interface Orientation (ByteRTCFlutterMapCategory)

+ (Orientation *)bf_fromMap:(NSDictionary *)dict;

@end

@interface HumanOrientation (ByteRTCFlutterMapCategory)

+ (HumanOrientation *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCRangeAudioInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCVideoCaptureConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCVideoCaptureConfig *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCRecordingConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCRecordingConfig *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCASRConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCASRConfig *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCAudioPropertiesConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCAudioPropertiesConfig *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCStreamSycnInfoConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCStreamSycnInfoConfig *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCRecordingInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCRecordingProgress (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCAudioPropertiesInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCLocalAudioPropertiesInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCRemoteAudioPropertiesInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end


@interface ByteRTCRemoteVideoConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCRemoteVideoConfig *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCVideoEncoderConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCVideoEncoderConfig *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCVirtualBackgroundSource (ByteRTCFlutterMapCategory)

+ (ByteRTCVirtualBackgroundSource *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCSourceCropInfo (ByteRTCFlutterMapCategory)

+ (ByteRTCSourceCropInfo *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCPublicStreamRegion (ByteRTCFlutterMapCategory)

+ (ByteRTCPublicStreamRegion *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCPublicStreamLayout (ByteRTCFlutterMapCategory)

+ (ByteRTCPublicStreamLayout *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCPublicStreamVideoConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCPublicStreamVideoConfig *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCPublicStreamAudioConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCPublicStreamAudioConfig *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCPublicStreaming (ByteRTCFlutterMapCategory)

+ (ByteRTCPublicStreaming *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ForwardStreamConfiguration (ByteRTCFlutterMapCategory)

+ (ForwardStreamConfiguration *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ForwardStreamStateInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ForwardStreamEventInfo (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCVideoByteWatermark (ByteRTCFlutterMapCategory)

+ (ByteRTCVideoByteWatermark *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCVideoWatermarkConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCVideoWatermarkConfig *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCSubscribeConfig (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCRectangle (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCFaceDetectionResult (ByteRTCFlutterMapCategory)

- (NSDictionary *)bf_toMap;

@end

@interface ByteRTCCloudProxyInfo (ByteRTCFlutterMapCategory)

+ (ByteRTCCloudProxyInfo *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCEchoTestConfig (ByteRTCFlutterMapCategory)

+ (ByteRTCEchoTestConfig *)bf_fromMap:(NSDictionary *)dict;

@end

@interface ByteRTCPushSingleStreamParam (ByteRTCFlutterMapCategory)

+ (ByteRTCPushSingleStreamParam *)bf_fromMap:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
