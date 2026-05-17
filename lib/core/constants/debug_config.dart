import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tkc_vender_auth/core/network/proxyman_override.dart';

bool get isProxymanEnabled =>
    kDebugMode && dotenv.env['ENABLE_PROXYMAN'] == 'true';

/// Host IP for Proxyman. Override with [PROXYMAN_IP] in `.env`.
/// Defaults: iOS/macOS → 127.0.0.1, Android emulator → 10.0.2.2 (host loopback).
String get proxymanIp {
  final fromEnv = dotenv.env['PROXYMAN_IP'];
  if (fromEnv != null && fromEnv.isNotEmpty) return fromEnv;
  if (!kIsWeb && Platform.isAndroid) return '10.0.2.2';
  return '127.0.0.1';
}

void setupProxymanIfEnabled() {
  if (!isProxymanEnabled) return;
  HttpOverrides.global = ProxymanOverride(proxyIp: proxymanIp);
}
