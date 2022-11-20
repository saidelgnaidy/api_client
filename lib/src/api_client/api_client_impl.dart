import 'dart:io';
import 'dart:async';
import 'interceptor.dart';
import 'package:dio/dio.dart';
import '../error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityCheck {
  static final Connectivity _connectivity = Connectivity();

  static Future<bool> call() async {
    var connectivityResult = await (_connectivity.checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  static Stream<ConnectivityResult> get connectionStream {
    return _connectivity.onConnectivityChanged;
  }
}

abstract class ApiClientHelper {
  static Future<Either<Failure, dynamic>> responseToModel({required Future<Response<dynamic>> func, required Function(dynamic res) on200Error}) async {
    if (await ConnectivityCheck.call()) {
      try {
        final response = await func;
        if (response.statusCode == 200) {
          if (response.data['status'] == 'error') {
            on200Error(response.data['message']);
          }
          return right(response.data);
        } else if (response.statusCode == 409) {
          return left(Failure.error409(error: response.data['message']));
        } else if (response.statusCode == 422) {
          return left(Failure.error422(error422model: response.data));
        } else if (response.statusCode == 403) {
          return left(Failure.error401(error: response.data['message']));
        } else if (response.statusCode == 401) {
          return left(Failure.error401(error: response.data['message']));
        } else if (response.statusCode == 500) {
          return left(const Failure.server());
        } else {
          return left(const Failure.someThingWrongPleaseTryagain());
        }
      } on DioError catch (e) {
        debugPrint('=================>> DioError :  ${e.message}');
        switch (e.type) {
          case DioErrorType.connectTimeout:
            return left(const Failure.error("Request Time out"));
          case DioErrorType.receiveTimeout:
            return left(const Failure.error("Receive Time out"));
          case DioErrorType.other:
            if (e.error != null && e.error is SocketException) {
              return left(Failure.offline(option: e.requestOptions));
            } else {
              debugPrint('=================> 1');
              return left(const Failure.someThingWrongPleaseTryagain());
            }
          default:
            debugPrint('=================> 2');
            return left(const Failure.someThingWrongPleaseTryagain());
        }
      } catch (e) {
        debugPrint('=================> 3');
        return left(Failure.error(e.toString()));
      }
    } else {
      return left(const Failure.offline());
    }
  }
}

class DioClientImpl {
  final List<Interceptor> otherInterceptors;
  final BaseOptions baseOptions;
  final String baseUrl;
  void Function(RequestOptions)? onRequestCallback;
  void Function(Response<dynamic>)? onResponseCallback;
  void Function(DioError)? onErrorCallback;
  Future<Response<dynamic>> Function(RequestOptions) onRetry;
  DioClientImpl(
    this.baseUrl, {
    this.otherInterceptors = const [],
    this.onRequestCallback,
    this.onResponseCallback,
    this.onErrorCallback,
    required this.baseOptions,
    required this.onRetry,
  }) {
    _dio.interceptors
      ..add(UserInterceptor(
        onRequestCallback: onRequestCallback,
        onResponseCallback: onResponseCallback,
        onErrorCallback: onErrorCallback,
        onRetry: onRetry,
      ))
      ..addAll(otherInterceptors)
      ..add(PrettyDioLogger());
  }

  Dio get _dio => Dio(baseOptions);

  Future<Response> get(String path, {Map<String, dynamic>? params, Options? options}) {
    return _dio.get(path, queryParameters: params, options: options);
  }

  Future<Response> post(String path, {Map<String, dynamic>? params, Options? options, data}) {
    return _dio.post(path, data: data, queryParameters: params, options: options);
  }

  Future<Response> postWithFiles(String path, {Map<String, dynamic>? params, Options? options, data}) {
    return _dio.post(
      path,
      data: FormData.fromMap(data),
      queryParameters: params,
      options: options
        ?..headers?.addAll(
          {
            "Accept": "application/json",
            "Content-Type": "multipart/form-data",
          },
        ),
    );
  }

  Future<Response> patch(String path, {Map<String, dynamic>? params, Options? options, data}) {
    return _dio.patch(path, data: data, queryParameters: params, options: options);
  }

  Future<Response> put(String path, {Map<String, dynamic>? params, Options? options, data}) {
    return _dio.put(path, data: data, queryParameters: params, options: options);
  }

  Future<Response> delete(String path, {Map<String, dynamic>? params, Options? options, data}) {
    return _dio.delete(path, data: data, queryParameters: params, options: options);
  }

  Future<Response> request(
    String path, {
    data,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.request(
      path,
      data: data,
      queryParameters: params,
      options: options,
      onReceiveProgress: onReceiveProgress,
      onSendProgress: onSendProgress,
      cancelToken: cancelToken,
    );
  }
}
