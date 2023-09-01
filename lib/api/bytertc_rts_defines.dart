// Copyright (c) 2023 Beijing Volcano Engine Technology Ltd.
// SPDX-License-Identifier: MIT

import '../src/base/bytertc_enum_convert.dart';
import 'bytertc_room_api.dart';
import 'bytertc_video_api.dart';
import 'bytertc_video_event_handler.dart';

/// 远端用户离开房间的原因
enum UserOfflineReason {
  /// 远端用户调用 [RTCRoom.leaveRoom] 方法主动退出房间
  quit,

  /// 远端用户因网络等原因掉线
  dropped,

  /// 远端用户切换至隐身状态
  switchToInvisible,

  /// 服务端调用 OpenAPI，将远端用户踢出房间
  kickedByAdmin,
}

/// SDK 与 RTC 服务器连接状态
enum RTCConnectionState {
  /// 连接断开，且断开时长超过 12s，SDK 会自动重连
  disconnected,

  /// 首次请求建立连接，正在连接中
  connecting,

  /// 首次连接成功
  connected,

  /// 涵盖以下情况：
  /// + 首次连接时，10 秒内未连接成功；
  /// + 连接成功后，断连 10 秒。自动重连中。
  reconnecting,

  /// 连接断开后，重连成功
  reconnected,

  /// 处于 `disconnected` 状态超过 10 秒，且期间重连未成功，SDK 仍将继续尝试重连
  lost,

  /// 连接失败，服务端状态异常
  ///
  /// SDK 不会自动重连，请重新进房，或联系技术支持
  failed,
}

/// 网络类型
enum NetworkType {
  /// 未知网络链接类型
  unknown,

  /// 网络连接已断开
  disconnected,

  /// LAN
  lan,

  /// Wi-Fi，包含热点连接
  wifi,

  /// 2G 移动网络
  mobile2G,

  /// 3G 移动网络
  mobile3G,

  /// 4G 移动网络
  mobile4G,

  /// 5G 移动网络
  mobile5G,
}

/// 所属用户的媒体流网络质量
enum NetworkQuality {
  /// 媒体流网络质量未知
  unKnown,

  /// 媒体流网络质量极好
  excellent,

  /// 媒体流网络质量较好
  good,

  /// 媒体流网络质量较差，但不影响沟通
  poor,

  /// 媒体流网络质量较差，沟通不顺畅
  bad,

  /// 媒体流网络质量极差
  veryBad,

  /// 网络连接断开，无法通话。
  ///
  /// 网络可能由于 12s 内无应答、开启飞行模式、拔掉网线等原因断开。<br>
  /// 更多网络状态信息参见 [连接状态提示](https://www.volcengine.com/docs/6348/95376)。
  down,
}

/// 登录结果
///
/// 调用 [RTCVideo.login] 登录的结果，会通过 [RTCVideoEventHandler.onLoginResult] 回调通知用户。
enum LoginErrorCode {
  /// 登录成功
  success,

  /// Token 无效或过期失效，需要用户重新获取 Token
  invalidToken,

  /// 发生未知错误导致登录失败，需要重新登录
  loginFailed,

  /// 调用 [RTCVideo.login] 传入的用户 ID 有问题
  invalidUserId,

  /// 登录时服务器发生错误
  codeServerError,
}

/// 发送消息的可靠有序性
enum MessageConfig {
  /// 低延时可靠有序消息
  reliableOrdered,

  /// 超低延时有序消息
  unreliableOrdered,

  /// 超低延时无序消息
  unreliableUnordered,
}

/// 消息发送结果
enum UserMessageSendResult {
  /// 发送成功
  success,

  /// 发送超时，没有发送
  timeout,

  /// 通道断开，没有发送
  broken,

  /// 找不到接收方
  noReceiver,

  /// 获取级联路径失败
  noRelayPath,

  /// 超过 QPS 限制
  exceedQPS,

  /// 发送端用户未加入房间
  notJoin,

  /// 连接未完成初始化
  init,

  /// 没有可用的数据传输通道连接
  noConnection,

  /// 消息超过最大长度（64KB）
  exceedMaxLength,

  /// 消息接收的单个用户 ID 为空
  emptyUser,

  /// 房间外或应用服务器消息发送方没有登录
  notLogin,

  /// 发送消息给业务方服务器之前没有设置参数
  serverParamsNotSet,

  /// 发送失败，错误未知
  unknown,
}

/// 用户在线状态
enum UserOnlineStatus {
  /// 对端用户离线
  ///
  /// 对端用户已登出或尚未登录
  offline,

  /// 对端用户在线
  ///
  /// 对端已登录并且连接状态正常
  online,

  /// 无法获取对端用户在线状态
  ///
  /// 发生级联错误、对端用户在线状态异常时返回
  unreachable,
}

/// 房间内群发消息结果
enum RoomMessageSendResult {
  /// 发送成功
  success,

  /// 发送超时，没有发送
  timeout,

  /// 通道断开，没有发送
  networkDisconnected,

  /// 超过 QPS 限制
  exceedQPS,

  /// 发送失败，消息发送方没有加入房间
  notJoin,

  /// 发送失败，连接未完成初始化
  init,

  /// 发送失败，没有可用的数据传输通道连接
  noConnection,

  /// 发送失败，消息超过最大长度（64KB）
  exceedMaxLength,

  /// 发送失败，错误未知
  unknown,
}

/// CPU 和内存统计信息
class SysStats {
  /// 当前系统 CPU 核数
  final int? cpuCores;

  /// 当前应用的 CPU 使用率，取值范围为 `[0, 1]`
  final double? cpuAppUsage;

  /// 当前系统的 CPU 使用率，取值范围为 `[0, 1]`
  final double? cpuTotalUsage;

  /// 当前应用的内存使用量（MB）
  final double? memoryUsage;

  /// 设备的内存大小（MB）
  final int? fullMemory;

  /// 系统已使用内存（MB）
  final int? totalMemoryUsage;

  /// 系统当前空闲可分配内存 (MB)
  final int? freeMemory;

  /// 当前应用的内存使用率 (%)
  final double? memoryRatio;

  /// 系统内存使用率 (%)
  final double? totalMemoryRatio;

  /// @nodoc
  const SysStats({
    this.cpuCores,
    this.cpuAppUsage,
    this.cpuTotalUsage,
    this.memoryUsage,
    this.fullMemory,
    this.totalMemoryUsage,
    this.freeMemory,
    this.memoryRatio,
    this.totalMemoryRatio,
  });

  /// @nodoc
  factory SysStats.fromMap(Map<dynamic, dynamic> map) {
    return SysStats(
      cpuCores: map['cpuCores'],
      cpuAppUsage: map['cpuAppUsage'],
      cpuTotalUsage: map['cpuTotalUsage'],
      memoryUsage: map['memoryUsage'],
      fullMemory: map['fullMemory'],
      totalMemoryUsage: map['totalMemoryUsage'],
      freeMemory: map['freeMemory'],
      memoryRatio: map['memoryRatio'],
      totalMemoryRatio: map['totalMemoryRatio'],
    );
  }
}

/// 云代理信息
class CloudProxyInfo {
  /// 云代理服务器 IP
  String cloudProxyIp;

  /// 云代理服务器端口
  int cloudProxyPort;

  /// @nodoc
  CloudProxyInfo({
    required this.cloudProxyIp,
    required this.cloudProxyPort,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cloudProxyIp': cloudProxyIp,
      'cloudProxyPort': cloudProxyPort,
    };
  }
}

/// 本地代理的类型。
enum LocalProxyType {
  /// Socks5 代理。选用此代理服务器，需满足 Socks5 协议标准文档的要求。
  socks5,

  /// Http 隧道代理。
  httpTunnel,
}

/// 本地代理配置详细信息。
class LocalProxyConfiguration {
  /// 本地代理的类型。
  LocalProxyType localProxyType;

  /// 本地代理服务器 IP。
  String localProxyIp;

  /// 本地代理服务器端口。
  int localProxyPort;

  /// 本地代理用户名。
  String localProxyUsername;

  /// 本地代理密码。
  String localProxyPassword;

  /// @nodoc
  LocalProxyConfiguration({
    this.localProxyType = LocalProxyType.socks5,
    required this.localProxyIp,
    required this.localProxyPort,
    this.localProxyUsername = '',
    this.localProxyPassword = '',
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'localProxyType': localProxyType.value,
      'localProxyIp': localProxyIp,
      'localProxyPort': localProxyPort,
      'localProxyUsername': localProxyUsername,
      'localProxyPassword': localProxyPassword,
    };
  }
}

/// 本地代理连接状态。
enum LocalProxyState {
  /// TCP 代理服务器连接成功。
  inited,

  /// 本地代理连接成功。
  connected,

  /// 本地代理连接出现错误。
  error,
}

/// 本地代理错误。
enum LocalProxyError {
  /// 本地代理服务器无错误。
  ok,

  /// 代理服务器回复的版本号不符合 Socks5 协议标准文档的规定，导致 Socks5 代理连接失败。请检查代理服务器是否存在异常。
  socks5VersionError,

  /// 代理服务器回复的格式错误不符合 Socks5 协议标准文档的规定，导致 Socks5 代理连接失败。请检查代理服务器是否存在异常。
  socks5FormatError,

  /// 代理服务器回复的字段值不符合 Socks5 协议标准文档的规定，导致 Socks5 代理连接失败。请检查代理服务器是否存在异常。
  socks5InvalidValue,

  /// 未提供代理服务器的用户名及密码，导致 Socks5 代理连接失败。请重新调用 [RTCVideo.setLocalProxy]，在设置本地代理时填入用户名和密码。
  socks5UserPassNotGiven,

  /// TCP 关闭，导致 Socks5 代理连接失败。请检查网络或者代理服务器是否存在异常。
  socks5TcpClosed,

  /// Http 隧道代理错误。请检查 Http 隧道代理服务器或者网络是否存在异常。
  httpTunnelFailed,
}

/// 本地日志输出等级。
enum LocalLogLevel {
  /// 信息级别。
  info,

  /// 警告级别（默认值）。
  warning,

  /// 错误级别。
  error,

  /// 关闭日志。
  none,
}

/// 本地日志参数。
class RTCLogConfig {
  /// 日志存储路径。
  final String logPath;

  /// 日志等级。默认为警告级别。
  final LocalLogLevel logLevel;

  /// 日志可使用的最大缓存空间，单位为 MB。取值范围为 1～100 MB，默认值为 10 MB。
  final int logFileSize;

  /// @nodoc
  const RTCLogConfig({
    required this.logPath,
    this.logLevel = LocalLogLevel.warning,
    this.logFileSize = 10,
  });

  /// @nodoc
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'logPath': logPath,
      'logLevel': logLevel.index,
      'logFileSize': logFileSize,
    };
  }
}
