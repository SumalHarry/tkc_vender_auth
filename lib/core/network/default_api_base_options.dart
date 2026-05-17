import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

BaseOptions defaultApiBaseOptions() {
  var baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:3000';
  if (!kIsWeb) {
    if (Platform.isAndroid) {
      baseUrl = baseUrl.replaceFirst('localhost', '10.0.2.2');
    }
  }
  return BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Content-Type': 'application/json'},
  );
}
