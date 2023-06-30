// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

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
      case 'onPlayStateChange':
        final data = OnPlayStateChangeData.fromMap(dic);
        onPlayStateChange?.call(data.musicId, data.playState, data.error);
        break;
      default:
        break;
    }
  }
}

extension RTCKTVEventProcessor on RTCKTVEventHandler {
  void process(String methodName, Map<dynamic, dynamic> dic) {
    switch (methodName) {
      case 'onMusicListResult':
        final data = OnMusicListResultData.fromMap(dic);
        onMusicListResult?.call(data.error, data.totalSize, data.musics);
        break;
      case 'onSearchMusicResult':
        final data = OnMusicListResultData.fromMap(dic);
        onSearchMusicResult?.call(data.error, data.totalSize, data.musics);
        break;
      case 'onHotMusicResult':
        final data = OnHotMusicResultData.fromMap(dic);
        onHotMusicResult?.call(data.error, data.hotMusics);
        break;
      case 'onMusicDetailResult':
        final data = OnMusicDetailResultData.fromMap(dic);
        onMusicDetailResult?.call(data.error, data.music);
        break;
      default:
        break;
    }
  }
}
