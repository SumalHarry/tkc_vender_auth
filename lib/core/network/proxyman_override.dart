import 'dart:io';

/// Routes [dart:io] HTTP traffic through Proxyman (default port 9090).
class ProxymanOverride extends HttpOverrides {
  ProxymanOverride({required this.proxyIp});

  final String proxyIp;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (cert, host, port) => Platform.isAndroid;
    client.findProxy = (_) => 'PROXY $proxyIp:9090';
    return client;
  }
}
