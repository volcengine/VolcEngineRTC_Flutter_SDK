// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import '../src/base/bytertc_enum_convert.dart';

/// 歌曲过滤方式
enum KTVMusicFilterType {
  /// 不过滤
  none,

  /// 过滤没有歌词的歌曲
  withoutLyric,

  /// 过滤不支持打分的歌曲
  unsupportedScore,

  /// 过滤不支持伴唱切换的歌曲
  unsupportedAccompany,

  /// 过滤没有高潮片段的歌曲
  unsupportedClimax,
}

/// 榜单类别
enum KTVMusicHotType {
  /// 火山内容中心热歌榜
  contentCenter,

  /// 项目热歌榜
  project,
}

/// 音乐播放状态
enum KTVPlayState {
  /// 播放中
  playing,

  /// 暂停中
  paused,

  /// 已停止
  stopped,

  /// 播放失败
  failed,

  /// 播放结束
  finished,
}

/// 原唱伴唱类型
enum KTVAudioTrackType {
  /// 播放原唱
  original,

  /// 播放伴唱
  accompany,
}

///音乐播放类型
enum KTVAudioPlayType {
  /// 仅本地播放
  local,

  /// 仅远端播放
  remote,

  /// 本地、远端同时播放
  localAndRemote,
}

/// 歌词格式类型
enum KTVLyricStatus {
  /// 无歌词
  none,

  /// KRC 歌词
  krc,

  /// LRC 歌词
  lrc,

  /// KRC 歌词和 LRC 歌词均有
  krcAndLrc,
}

/// 下载文件类型
enum KTVDownloadFileType {
  /// 音频文件
  music,

  /// KRC 歌词文件
  krc,

  /// LRC 歌词文件
  lrc,

  /// MIDI 文件
  midi,
}

/// 歌词文件类型
enum KTVDownloadLyricType {
  /// KRC 歌词文件
  krc,

  /// LRC 歌词文件
  lrc,
}

/// KTV 功能相关错误码
enum KTVError {
  /// 成功
  ok,

  /// AppID 异常
  appIdInValid,

  /// 传入的参数不正确
  parasInValid,

  /// 获取歌曲资源失败
  getMusicFailed,

  /// 获取歌词失败
  getLyricFailed,

  /// 歌曲下架
  musicTakedown,

  /// 歌曲文件下载失败
  musicDownload,

  /// MIDI 文件下载失败
  midiDownloadFailed,

  /// 系统繁忙
  systemBusy,

  /// 网络异常
  network,

  /// KTV 功能未加入房间
  notJoinRoom,

  /// 解析数据失败
  parseData,

  /// 下载失败
  download,

  /// 已在下载中
  downloading,

  /// 内部错误，联系技术支持人员
  internal,
}

/// KTV 播放器错误码
enum KTVPlayerError {
  /// 成功
  ok,

  /// 播放错误，请下载后播放
  fileNotExist,

  /// 播放错误，请确认文件播放格式
  fileError,

  /// 播放错误，未进入房间
  notJoinRoom,

  /// 参数错误
  param,

  /// 播放失败，找不到文件或文件打开失败
  startError,

  /// 混音 ID 异常
  mixIdError,

  /// 设置播放位置出错
  positionError,

  /// 音量参数不合法，可设置的取值范围为 `[0,400]`
  audioVolumeError,

  /// 不支持此混音类型
  typeError,

  /// 音调文件不合法
  pitchError,

  /// 音轨不合法
  audioTrackError,

  /// 混音启动中
  startingError,
}

/// 歌曲数据
class KTVMusic {
  /// 音乐 ID
  final String musicId;

  /// 音乐名称
  final String musicName;

  /// 歌手
  final String singer;

  /// 版权商 ID
  final String vendorId;

  /// 版权商名称
  final String vendorName;

  /// 最新更新时间戳，单位为毫秒
  final int updateTimestamp;

  /// 封面地址
  final String posterUrl;

  /// 歌词格式类型
  final KTVLyricStatus lyricStatus;

  /// 歌曲长度，单位为毫秒
  final int duration;

  /// 歌曲是否支持打分
  final bool enableScore;

  /// 歌曲高潮片段开始时间，单位为毫秒
  final int climaxStartTime;

  /// 歌曲高潮片段停止时间，单位为毫秒
  final int climaxEndTime;

  const KTVMusic({
    required this.musicId,
    required this.musicName,
    required this.singer,
    required this.vendorId,
    required this.vendorName,
    required this.updateTimestamp,
    required this.posterUrl,
    required this.lyricStatus,
    required this.duration,
    required this.enableScore,
    required this.climaxStartTime,
    required this.climaxEndTime,
  });

  /// @nodoc
  factory KTVMusic.fromMap(Map<dynamic, dynamic> map) {
    return KTVMusic(
      musicId: map['musicId'],
      musicName: map['musicName'],
      singer: map['singer'],
      vendorId: map['vendorId'],
      vendorName: map['vendorName'],
      updateTimestamp: map['updateTimestamp'],
      posterUrl: map['posterUrl'],
      lyricStatus: (map['lyricStatus'] as int?).ktvLyricStatus,
      duration: map['duration'],
      enableScore: map['enableScore'],
      climaxStartTime: map['climaxStartTime'],
      climaxEndTime: map['climaxEndTime'],
    );
  }
}

/// 热榜歌曲数据
class KTVHotMusicInfo {
  /// 榜单类别
  final KTVMusicHotType hotType;

  /// 热榜名称
  final String? hotName;

  /// 歌曲数据
  final List<KTVMusic>? musics;

  const KTVHotMusicInfo({
    required this.hotType,
    this.hotName,
    this.musics,
  });

  /// @nodoc
  factory KTVHotMusicInfo.fromMap(Map<dynamic, dynamic> map) {
    return KTVHotMusicInfo(
      hotType: (map['hotType'] as int?).ktvMusicHotType,
      hotName: map['hotName'],
      musics: (map['musics'] as List?)
          ?.map((e) => KTVMusic.fromMap(e))
          .toList(growable: false),
    );
  }
}

/// 歌曲下载信息
class KTVDownloadResult {
  /// 音乐 ID
  final String musicId;

  /// 下载文件类型
  final KTVDownloadFileType fileType;

  /// 文件存放路径
  final String? filePath;

  const KTVDownloadResult({
    required this.musicId,
    required this.fileType,
    this.filePath,
  });

  /// @nodoc
  factory KTVDownloadResult.fromMap(Map<dynamic, dynamic> map) {
    return KTVDownloadResult(
      musicId: map['musicId'],
      fileType: (map['fileType'] as int?).ktvDownloadFileType,
      filePath: map['filePath'],
    );
  }
}
