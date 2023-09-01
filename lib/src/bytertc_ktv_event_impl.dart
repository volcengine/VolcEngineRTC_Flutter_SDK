// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

// ignore_for_file: public_member_api_docs
import '../api/bytertc_ktv_manager_api.dart';
import '../api/bytertc_ktv_player_api.dart';
import 'base/bytertc_event_serialize.dart';

extension RTCKTVPlayerEventProcessor on RTCKTVPlayerEventHandler {
  void process(String methodName, Map<dynamic, dynamic> dic) {
    switch (methodName) {
      case 'onPlayProgress':
        final data = OnPlayProgressData.fromMap(dic);
        onPlayProgress?.call(data.musicId, data.progress);
        break;
      case 'onPlayStateChanged':
        final data = OnPlayStateChangedData.fromMap(dic);
        onPlayStateChanged?.call(data.musicId, data.playState, data.error);
        break;
      default:
        break;
    }
  }
}

extension RTCKTVManagerEventProcessor on RTCKTVManagerEventHandler {
  void process(String methodName, Map<dynamic, dynamic> dic) {
    switch (methodName) {
      case 'onMusicListResult':
        final data = OnMusicListResultData.fromMap(dic);
        onMusicListResult?.call(data.musics, data.totalSize, data.error);
        break;
      case 'onSearchMusicResult':
        final data = OnMusicListResultData.fromMap(dic);
        onSearchMusicResult?.call(data.musics, data.totalSize, data.error);
        break;
      case 'onHotMusicResult':
        final data = OnHotMusicResultData.fromMap(dic);
        onHotMusicResult?.call(data.hotMusics, data.error);
        break;
      case 'onMusicDetailResult':
        final data = OnMusicDetailResultData.fromMap(dic);
        onMusicDetailResult?.call(data.music, data.error);
        break;
      case 'onClearCacheResult':
        final data = OnClearCacheResultData.fromMap(dic);
        onClearCacheResult?.call(data.error);
        break;
      default:
        break;
    }
  }
}
