// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';

import '../api/bytertc_media_defines.dart';
import '../api/bytertc_video_defines.dart';
import 'base/bytertc_enum_convert.dart';

/// 视频截图结果回调
class TakeSnapshotResultObserver {
  /// 调用异常
  static const int ERROR_EXCEPTION = -100;

  /// 未返回 TASK ID
  static const int ERROR_NO_TASK_ID = -101;

  /// 文件写入失败
  static const int ERROR_WRITE_FILE_FAILED = -102;

  /// 图片格式错误
  static const int ERROR_IMAGE_FORMAT = -103;

  Map<int, CancelableCompleter<LocalSnapshot>> _localCompleters = Map();

  Map<int, CancelableCompleter<RemoteSnapshot>> _remoteCompleters = Map();

  void removeLocal(int taskId) => _localCompleters.remove(taskId);

  void putLocal(int taskId, CancelableCompleter<LocalSnapshot> completer) {
    _localCompleters[taskId] = completer;
  }

  void removeRemote(int taskId) => _remoteCompleters.remove(taskId);

  void putRemote(int taskId, CancelableCompleter<RemoteSnapshot> completer) {
    _remoteCompleters[taskId] = completer;
  }

  void process(String methodName, Map<dynamic, dynamic> dic) {
    switch (methodName) {
      case 'onTakeLocalSnapshotResult':
        int taskId = dic['taskId'] as int;
        StreamIndex streamIndex = (dic['streamIndex'] as int).streamIndex;
        String? filePath = dic['filePath'] as String?;
        int error = dic['error'] as int;
        int width = (dic['width'] as int?) ?? 0;
        int height = (dic['height'] as int?) ?? 0;

        var completer = _localCompleters.remove(taskId);
        if (completer == null) {
          debugPrint('Completer<LocalSnapshot> not found!');
          return;
        }
        if (completer.isCompleted || completer.isCanceled) {
          debugPrint('Completer<LocalSnapshot> is consumed!');
          return;
        }
        if (error == 0 && filePath != null) {
          completer.complete(LocalSnapshot(
            taskId: taskId,
            streamIndex: streamIndex,
            filePath: filePath,
            width: width,
            height: height,
          ));
        } else {
          completer.completeError(error);
        }
        break;

      case 'onTakeRemoteSnapshotResult':
        int taskId = dic['taskId'] as int;
        RemoteStreamKey streamKey = RemoteStreamKey.fromMap(dic['streamKey']);
        String? filePath = dic['filePath'] as String?;
        int error = dic['error'] as int;
        int width = (dic['width'] as int?) ?? 0;
        int height = (dic['height'] as int?) ?? 0;
        var completer = _remoteCompleters.remove(taskId);
        if (completer == null) {
          debugPrint('Completer<RemoteSnapshot> not found!');
          return;
        }
        if (completer.isCompleted || completer.isCanceled) {
          debugPrint('Completer<RemoteSnapshot> is consumed!');
          return;
        }
        if (error == 0 && filePath != null) {
          completer.complete(RemoteSnapshot(
            taskId: taskId,
            streamKey: streamKey,
            filePath: filePath,
            width: width,
            height: height,
          ));
        } else {
          completer.completeError(error);
        }
        break;
      default:
        debugPrint('unhandled: $methodName');
        break;
    }
  }
}
