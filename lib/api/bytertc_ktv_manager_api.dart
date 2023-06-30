// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:async/async.dart';

import 'bytertc_ktv_defines.dart';
import 'bytertc_ktv_player_api.dart';

/// [error]：错误码，成功时返回 0
///
/// [totalSize]：数据条目总数
///
/// [musics]：歌曲数据数组
typedef OnMusicListResultType = void Function(
    KTVError error, int totalSize, List<KTVMusic>? musics);

/// [error]：错误码，成功时返回 0
///
/// [hotMusics]：热榜歌曲数据数组
typedef OnHotMusicResultType = void Function(
    KTVError error, List<KTVHotMusicInfo>? hotMusics);

/// [error]：错误码，成功时返回 0
///
/// [music]：歌曲数据
typedef OnMusicDetailResultType = void Function(
    KTVError error, KTVMusic? music);

/// KTV 事件回调类
class RTCKTVEventHandler {
  /// 歌曲列表回调
  OnMusicListResultType? onMusicListResult;

  /// 搜索歌曲结果回调
  OnMusicListResultType? onSearchMusicResult;

  /// 热榜歌曲结果回调
  OnHotMusicResultType? onHotMusicResult;

  /// 歌曲详细信息回调
  OnMusicDetailResultType? onMusicDetailResult;

  RTCKTVEventHandler({
    this.onMusicListResult,
    this.onSearchMusicResult,
    this.onHotMusicResult,
    this.onMusicDetailResult,
  });
}

/// KTV 管理接口类
abstract class RTCKTVManager {
  /// 设置 KTV 回调
  void setKTVEventHandler(RTCKTVEventHandler? eventHandler);

  /// 获取歌曲列表
  ///
  /// [pageNum]：页码，默认从 1 开始。<br>
  /// [pageSize]：每页显示歌曲的最大数量，取值范围 `[1,99]`。<br>
  /// [filters]：歌曲过滤方式。多个过滤方式可以按位或组合。
  ///
  /// 调用接口后，你会收到 [RTCKTVEventHandler.onMusicListResult] 回调歌曲列表。
  Future<void> getMusicList({
    int pageNum,
    int pageSize,
    List<KTVMusicFilterType> filters,
  });

  /// 根据关键词搜索歌曲
  ///
  /// [keyWord] 关键词，字符串长度最大为 20 个字符。<br>
  /// [pageNum]：页码，默认从 1 开始。<br>
  /// [pageSize]：每页显示歌曲的最大数量，取值范围 `[1,99]`。<br>
  /// [filters]：歌曲过滤方式。多个过滤方式可以按位或组合。
  ///
  /// 调用接口后，你会收到 [RTCKTVEventHandler.onSearchMusicResult] 回调歌曲列表。
  Future<void> searchMusic({
    required String keyWord,
    int pageNum,
    int pageSize,
    List<KTVMusicFilterType> filters,
  });

  /// 根据热榜类别获取每个榜单的歌曲列表
  ///
  /// [hotTypes]：热榜类别。多个热榜类别可以按位或组合。<br>
  /// [filters]：歌曲过滤方式。多个过滤方式可以按位或组合。
  ///
  /// 调用接口后，你会收到 [RTCKTVEventHandler.onHotMusicResult] 回调歌曲列表。
  Future<void> getHotMusic({
    List<KTVMusicHotType> hotTypes,
    List<KTVMusicFilterType> filters,
  });

  /// 获取音乐详细信息
  ///
  /// [musicId]：音乐 ID。
  ///
  /// 调用接口后，你会收到 [RTCKTVEventHandler.onMusicDetailResult] 回调。
  Future<void> getMusicDetail(String musicId);

  /// 下载音乐
  ///
  /// [musicId]：音乐 ID。<br>
  /// [onReceiveProgress]：音乐下载进度更新回调。设置后你会收到当前音乐文件的下载进度，单位 %，取值范围 [0,100]。
  ///
  /// 方法调用成功则收到 [KTVDownloadResult] 对象；若调用失败，则返回失败原因，具体参看 [KTVError]。
  CancelableOperation<KTVDownloadResult> downloadMusic(
    String musicId, {
    void Function(int downloadProgress)? onReceiveProgress,
  });

  /// 下载歌词
  ///
  /// [musicId]：音乐 ID。<br>
  /// [lyricType]：歌词文件类型。
  ///
  /// 方法调用成功则收到 [KTVDownloadResult] 对象；若调用失败，则返回失败原因，具体参看 [KTVError]。
  CancelableOperation<KTVDownloadResult> downloadLyric(
    String musicId, {
    KTVDownloadLyricType lyricType,
  });

  /// 下载 MIDI 文件
  ///
  /// [musicId]：音乐 ID。
  ///
  /// 方法调用成功则收到 [KTVDownloadResult] 对象；若调用失败，则返回失败原因，具体参看 [KTVError]。
  CancelableOperation<KTVDownloadResult> downloadMidi(String musicId);

  /// 清除当前音乐缓存文件，包括音乐音频和歌词
  Future<void> clearCache();

  /// 设置歌曲文件最大占用的本地缓存
  ///
  /// [maxCacheSizeMB]：本地缓存，单位 MB。<br>
  /// 设置值小于等于 0 时，使用默认值 1024 MB。
  Future<void> setMaxCacheSize(int maxCacheSizeMB);

  /// 获取 KTV 播放器
  FutureOr<RTCKTVPlayer?> getKTVPlayer();
}
