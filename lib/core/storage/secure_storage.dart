import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

const accessTokenKey = 'accessToken';
const refreshTokenKey = 'refreshToken';
const accessTokenExpiresAtKey = 'accessTokenExpiresAt';
const refreshTokenExpiresAtKey = 'refreshTokenExpiresAt';
const deviceIdKey = 'deviceId';

@Riverpod(keepAlive: true)
FlutterSecureStorage secureStorage(Ref ref) {
  return const FlutterSecureStorage();
}

@Riverpod(keepAlive: true)
SecureStorageService secureStorageService(Ref ref) {
  return SecureStorageService(ref.watch(secureStorageProvider));
}

class SecureStorageService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  Future<String?> read(String key) async {
    try {
      return _storage.read(key: key);
    } catch (e) {
      return null;
    }
  }

  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<void> deleteAll() => _storage.deleteAll();

  Future<String?> get accessToken => read(accessTokenKey);
  Future<String?> get refreshToken => read(refreshTokenKey);
  Future<String?> get accessTokenExpiresAt => read(accessTokenExpiresAtKey);
  Future<String?> get refreshTokenExpiresAt => read(refreshTokenExpiresAtKey);
  Future<String?> get deviceId => read(deviceIdKey);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String accessTokenExpiresAt,
    required String refreshTokenExpiresAt,
  }) async {
    await write(accessTokenKey, accessToken);
    await write(refreshTokenKey, refreshToken);
    await write(accessTokenExpiresAtKey, accessTokenExpiresAt);
    await write(refreshTokenExpiresAtKey, refreshTokenExpiresAt);
  }

  Future<void> clearTokens() async {
    await delete(accessTokenKey);
    await delete(refreshTokenKey);
    await delete(accessTokenExpiresAtKey);
    await delete(refreshTokenExpiresAtKey);
  }
}
