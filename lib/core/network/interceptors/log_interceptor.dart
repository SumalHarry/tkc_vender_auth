import 'dart:convert';

import 'package:dio/dio.dart';

class NetworkLogInterceptor extends Interceptor {
  static const _line = '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final buf = StringBuffer();
    buf.writeln('┌$_line');
    buf.writeln('│ ▶ REQUEST  ${options.method}  ${options.uri}');
    if (options.data != null) _writeBody(buf, options.data);
    buf.write('└$_line');
    // ignore: avoid_print
    print(buf);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final code = response.statusCode ?? 0;
    final status = code < 300 ? '✓' : '!';
    final buf = StringBuffer();
    buf.writeln('┌$_line');
    buf.writeln('│ $status RESPONSE  $code  ${response.requestOptions.uri}');
    if (response.data != null) _writeBody(buf, response.data);
    buf.write('└$_line');
    // ignore: avoid_print
    print(buf);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final code = err.response?.statusCode;
    final buf = StringBuffer();
    buf.writeln('┌$_line');
    buf.writeln('│ ✕ ERROR  ${code ?? '---'}  ${err.requestOptions.uri}');
    buf.writeln('│  ${err.message}');
    if (err.response?.data != null) _writeBody(buf, err.response!.data);
    buf.write('└$_line');
    // ignore: avoid_print
    print(buf);
    handler.next(err);
  }

  void _writeBody(StringBuffer buf, dynamic data) {
    buf.writeln('│  Body:');
    for (final line in _prettyJson(data).split('\n')) {
      buf.writeln('│    $line');
    }
  }

  String _prettyJson(dynamic data) {
    try {
      if (data is String) {
        return const JsonEncoder.withIndent('  ').convert(jsonDecode(data));
      }
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}
