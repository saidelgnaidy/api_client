import 'package:dio/dio.dart';

abstract class ApiClientAbs {
  Future<Response> get(String path, {Map<String, dynamic>? params, Options? options});

  Future<Response> patch(String path, {Map<String, dynamic>? params, Options? options, dynamic data});

  Future<Response> post(String path, {Map<String, dynamic>? params, Options? options, dynamic data});
  Future<Response> postWithFiles(String path, {Map<String, dynamic>? params, Options? options, dynamic data});

  Future<Response> put(String path, {Map<String, dynamic>? params, Options? options, dynamic data});

  Future<Response> delete(String path, {Map<String, dynamic>? params, Options? options, dynamic data});
  Future<Response> request(
    String path, {
    data,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });
}
