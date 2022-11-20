import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../error/failures.dart';
import 'connection_ckecker.dart';

abstract class ApiClientHelper {
  static Future<Either<KFailure, dynamic>> responseToModel({required Future<Response<dynamic>> func ,required Function(dynamic res) on200Error }) async {
    if (await ConnectivityCheck.call()) {
      try {
        final response = await func;
        if (response.statusCode == 200) {
          if (response.data['status'] == 'error') {
            on200Error(response.data['message']);
          }
          return right(response.data);
        } else if (response.statusCode == 409) {
          return left(KFailure.error409(error: response.data['message']));
        } else if (response.statusCode == 422) {
          return left(KFailure.error422(error422model: response.data));
        } else if (response.statusCode == 403) {
          return left(KFailure.error401(error: response.data['message']));
        } else if (response.statusCode == 401) {
          return left(KFailure.error401(error: response.data['message']));
        } else if (response.statusCode == 500) {
          return left(const KFailure.server());
        } else {
          return left(const KFailure.someThingWrongPleaseTryagain());
        }
      } on DioError catch (e) {
        debugPrint('=================>> DioError :  ${e.message}');
        switch (e.type) {
          case DioErrorType.connectTimeout:
            return left(const KFailure.error("Request Time out"));
          case DioErrorType.receiveTimeout:
            return left(const KFailure.error("Receive Time out"));
          case DioErrorType.other:
            if (e.error != null && e.error is SocketException) {
              return left( KFailure.offline(option: e.requestOptions));
            } else {
              debugPrint('=================> 1');
              return left(const KFailure.someThingWrongPleaseTryagain());
            }
          default:
            debugPrint('=================> 2');
            return left(const KFailure.someThingWrongPleaseTryagain());
        }
      } catch (e) {
        debugPrint('=================> 3');
        return left( KFailure.error(e.toString()));
      }
    }
    else {
      return left( const KFailure.offline());
    }
  }
}
