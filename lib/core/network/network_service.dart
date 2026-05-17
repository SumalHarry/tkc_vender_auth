import 'package:dio/dio.dart';
import 'package:tkc_vender_auth/core/network/models/app_exception.dart';
import 'package:tkc_vender_auth/core/network/models/either.dart';

abstract class NetworkService {
  Future<Either<AppException, Response<dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  });

  Future<Either<AppException, Response<dynamic>>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  Future<Either<AppException, Response<dynamic>>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  Future<Either<AppException, Response<dynamic>>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });

  Future<Either<AppException, Response<dynamic>>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  });
}
