import 'package:dio/dio.dart';
import 'package:tkc_vender_auth/core/network/models/app_exception.dart';
import 'package:tkc_vender_auth/core/network/models/either.dart';
import 'package:tkc_vender_auth/core/network/network_service.dart';

class DioNetworkService implements NetworkService {
  DioNetworkService(this._dio);

  final Dio _dio;

  @override
  Future<Either<AppException, Response<dynamic>>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) =>
      _runGuarded(
        () => _dio.get<dynamic>(path, queryParameters: queryParameters),
      );

  @override
  Future<Either<AppException, Response<dynamic>>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _runGuarded(
        () => _dio.post<dynamic>(path,
            data: data, queryParameters: queryParameters),
      );

  @override
  Future<Either<AppException, Response<dynamic>>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _runGuarded(
        () => _dio.put<dynamic>(path,
            data: data, queryParameters: queryParameters),
      );

  @override
  Future<Either<AppException, Response<dynamic>>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _runGuarded(
        () => _dio.patch<dynamic>(path,
            data: data, queryParameters: queryParameters),
      );

  @override
  Future<Either<AppException, Response<dynamic>>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) =>
      _runGuarded(
        () => _dio.delete<dynamic>(
          path,
          data: data,
          queryParameters: queryParameters,
        ),
      );

  Future<Either<AppException, Response<dynamic>>> _runGuarded(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      final response = await request();
      return Right(response);
    } on DioException catch (error) {
      return Left(_mapDioException(error));
    } catch (error) {
      return Left(AppException(error.toString()));
    }
  }

  AppException _mapDioException(DioException error) {
    final response = error.response;
    final data = response?.data;
    if (data is Map<String, dynamic> && data['message'] != null) {
      return AppException(
        data['message'].toString(),
        code: response?.statusCode?.toString(),
      );
    }
    return AppException(
      error.message ?? 'Network error',
      code: response?.statusCode?.toString(),
    );
  }
}
