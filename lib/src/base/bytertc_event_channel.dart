// Copyright (c) 2022 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import 'dart:async';

import 'package:flutter/services.dart';

class RTCEventChannel {
  final Stream<dynamic> _stream;
  StreamSubscription? _subscription;

  StreamSubscription? get subscription => _subscription;

  RTCEventChannel(String name)
      : _stream = EventChannel(name).receiveBroadcastStream();

  void listen(
      void Function(String methodName, Map<dynamic, dynamic> dic)? onData,
      {Function? onError,
      void Function()? onDone,
      bool? cancelOnError}) {
    cancel();
    _subscription = _stream.listen((event) {
      final methodName = event['methodName'] as String;
      onData?.call(methodName, event);
    }, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  void cancel() {
    _subscription?.cancel();
    _subscription = null;
  }

  void pause([Future<void>? resumeSignal]) {
    _subscription?.pause(resumeSignal);
  }

  void resume() {
    _subscription?.resume();
  }

  bool? get isPaused => _subscription?.isPaused;
}
