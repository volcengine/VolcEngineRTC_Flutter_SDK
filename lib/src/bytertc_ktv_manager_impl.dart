// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

// ignore_for_file: public_member_api_docs
import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/services.dart';

import '../api/bytertc_ktv_defines.dart';
import '../api/bytertc_ktv_manager_api.dart';
import '../api/bytertc_ktv_player_api.dart';
import 'base/bytertc_enum_convert.dart';
import 'base/bytertc_event_channel.dart';
import 'base/bytertc_event_serialize.dart';
import 'bytertc_ktv_event_impl.dart';
import 'bytertc_ktv_player_impl.dart';

class RTCKTVManagerImpl implements RTCKTVManager {
  final MethodChannel _channel =
      const MethodChannel('com.bytedance.ve_rtc_ktv_manager');
  final RTCEventChannel _eventChannel =
      RTCEventChannel('com.bytedance.ve_rtc_ktv_manager_event');

  final Map<int, CancelableCompleter<DownloadResult>> _downloadCompleters = {};

  final Map<int, void Function(int)> _downloadProgressCallbacks = {};

  RTCKTVManagerEventHandler? _eventHandler;

  RTCKTVPlayerImpl? _ktvPlayerImpl;

  RTCKTVManagerImpl() {
    _listenEvent();
  }

  void _listenEvent() {
    _eventChannel.subscription ??
        _eventChannel.listen((String methodName, Map<dynamic, dynamic> dic) {
          switch (methodName) {
            case 'onDownloadSuccess':
              _onDownloadSuccess(dic);
              break;
            case 'onDownloadFailed':
              _onDownloadFailed(dic);
              break;
            case 'onDownloadMusicProgress':
              _onDownloadMusicProgress(dic);
              break;
            default:
              _eventHandler?.process(methodName, dic);
              break;
          }
        });
  }

  Future<T?> _invokeMethod<T>(String method,
      [Map<String, dynamic>? arguments]) {
    return _channel.invokeMethod(method, arguments);
  }

  void _onDownloadSuccess(Map<dynamic, dynamic> dic) {
    final data = OnDownloadSuccessData.fromMap(dic);
    CancelableCompleter<DownloadResult>? completer =
        _downloadCompleters.remove(data.downloadId);
    _downloadProgressCallbacks.remove(data.downloadId);
    if (completer == null || completer.isCanceled || completer.isCompleted) {
      return;
    }
    completer.complete(data.result);
  }

  void _onDownloadFailed(Map<dynamic, dynamic> dic) {
    final data = OnDownloadFailedData.fromMap(dic);
    CancelableCompleter<DownloadResult>? completer =
        _downloadCompleters.remove(data.downloadId);
    _downloadProgressCallbacks.remove(data.downloadId);
    if (completer == null || completer.isCanceled || completer.isCompleted) {
      return;
    }
    completer.completeError(data.error);
  }

  void _onDownloadMusicProgress(Map<dynamic, dynamic> dic) {
    final data = OnDownloadMusicProgressData.fromMap(dic);
    _downloadProgressCallbacks[data.downloadId]?.call(data.downloadProgress);
  }

  CancelableOperation<DownloadResult> _download(
    String method, [
    Map<String, dynamic>? arguments,
    void Function(int downloadProgress)? onReceiveProgress,
  ]) {
    StackTrace stackTrace = StackTrace.current;
    int? _downloadId;
    CancelableCompleter<DownloadResult> completer =
        CancelableCompleter<DownloadResult>(onCancel: () {
      int? downloadId = _downloadId;
      if (downloadId != null) {
        _downloadCompleters.remove(downloadId);
        _downloadProgressCallbacks.remove(downloadId);
        _cancelDownload(downloadId);
      }
    });

    _invokeMethod<int>(method, arguments).then((value) {
      if (completer.isCanceled || completer.isCompleted) return;
      _downloadId = value;
      if (_downloadId == null) {
        completer.completeError(KTVErrorCode.internal, stackTrace);
        return;
      }
      _downloadCompleters[_downloadId!] = completer;
      if (onReceiveProgress != null) {
        _downloadProgressCallbacks[_downloadId!] = onReceiveProgress;
      }
    }, onError: (error) {
      completer.completeError(KTVErrorCode.internal, stackTrace);
    });

    return completer.operation;
  }

  Future<void> _cancelDownload(int downloadId) {
    return _invokeMethod('cancelDownload', {
      'downloadId': downloadId,
    });
  }

  void destroy() {
    _ktvPlayerImpl?.destroy();
    _eventChannel.cancel();
    _eventHandler = null;
    _downloadCompleters.clear();
    _downloadProgressCallbacks.clear();
  }

  @override
  void setKTVManagerEventHandler(RTCKTVManagerEventHandler? eventHandler) {
    _eventHandler = eventHandler;
  }

  @override
  Future<void> getMusicList({
    int pageNum = 1,
    int pageSize = 20,
    List<MusicFilterType> filters = const [MusicFilterType.none],
  }) {
    return _invokeMethod('getMusicList', {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'filters': filters.map((e) => e.value).toList(growable: false),
    });
  }

  @override
  Future<void> searchMusic({
    required String keyWord,
    int pageNum = 1,
    int pageSize = 20,
    List<MusicFilterType> filters = const [MusicFilterType.none],
  }) {
    return _invokeMethod('searchMusic', {
      'keyWord': keyWord,
      'pageNum': pageNum,
      'pageSize': pageSize,
      'filters': filters.map((e) => e.value).toList(growable: false),
    });
  }

  @override
  Future<void> getHotMusic({
    List<MusicHotType> hotTypes = const [
      MusicHotType.contentCenter,
      MusicHotType.project
    ],
    List<MusicFilterType> filters = const [MusicFilterType.none],
  }) {
    return _invokeMethod('getHotMusic', {
      'hotTypes': hotTypes.map((e) => e.value).toList(growable: false),
      'filters': filters.map((e) => e.value).toList(growable: false),
    });
  }

  @override
  Future<void> getMusicDetail(String musicId) {
    return _invokeMethod('getMusicDetail', {
      'musicId': musicId,
    });
  }

  @override
  CancelableOperation<DownloadResult> downloadMusic(String musicId,
      {void Function(int downloadProgress)? onReceiveProgress}) {
    return _download(
      'downloadMusic',
      {'musicId': musicId},
      onReceiveProgress,
    );
  }

  @override
  CancelableOperation<DownloadResult> downloadLyric(
    String musicId, {
    DownloadLyricType lyricType = DownloadLyricType.krc,
  }) {
    return _download('downloadLyric', {
      'musicId': musicId,
      'lyricType': lyricType.index,
    });
  }

  @override
  CancelableOperation<DownloadResult> downloadMidi(String musicId) {
    return _download('downloadMidi', {
      'musicId': musicId,
    });
  }

  @override
  Future<void> clearCache() {
    return _invokeMethod('clearCache');
  }

  @override
  Future<void> setMaxCacheSize(int maxCacheSizeMB) {
    return _invokeMethod('setMaxCacheSize', {
      'maxCacheSizeMB': maxCacheSizeMB,
    });
  }

  @override
  FutureOr<RTCKTVPlayer?> getKTVPlayer() {
    if (_ktvPlayerImpl != null) return _ktvPlayerImpl;
    return _invokeMethod<bool>('getKTVPlayer').then((value) {
      if (value != true) return null;
      return _ktvPlayerImpl ??= RTCKTVPlayerImpl();
    });
  }
}
