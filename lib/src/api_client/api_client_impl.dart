import 'package:dio/dio.dart';
import 'api_client_abs.dart';
import 'interceptor.dart';

class DioClientImpl implements ApiClientAbs {
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

  @override
  Future<Response> get(String path, {Map<String, dynamic>? params, Options? options}) {
    return _dio.get(path, queryParameters: params, options: options);
  }

  @override
  Future<Response> post(String path, {Map<String, dynamic>? params, Options? options, data}) {
    return _dio.post(path, data: data, queryParameters: params, options: options);
  }

  @override
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

  @override
  Future<Response> patch(String path, {Map<String, dynamic>? params, Options? options, data}) {
    return _dio.patch(path, data: data, queryParameters: params, options: options);
  }

  @override
  Future<Response> put(String path, {Map<String, dynamic>? params, Options? options, data}) {
    return _dio.put(path, data: data, queryParameters: params, options: options);
  }

  @override
  Future<Response> delete(String path, {Map<String, dynamic>? params, Options? options, data}) {
    return _dio.delete(path, data: data, queryParameters: params, options: options);
  }

  @override
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
