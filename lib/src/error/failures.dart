// ignore_for_file: depend_on_referenced_packages

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'failures.freezed.dart';

@freezed
abstract class KFailure with _$KFailure {
  const factory KFailure.server() = KFailureServer;
  const factory KFailure.offline({RequestOptions? option}) = KFailureOffline;
  const factory KFailure.userNotFound() = KFailureUserNotFound;
  const factory KFailure.locationDenaid() = KFailureLocationDenaid;
  const factory KFailure.locationDiabled() = KFailureLocationDiabled;
  const factory KFailure.locationDenaidPermenetl() = KFailureLocationDenaidPermenetl;
  const factory KFailure.userLogetOut() = KFailureUserLogedOut;
  const factory KFailure.someThingWrongPleaseTryagain() = KFailureSomeThingWrongPleaseTryagain;
  const factory KFailure.unknownNetIssue() = KFailureUnknownNetIssue;
  const factory KFailure.error(String error) = KFailureDecodingResponse;
  const factory KFailure.error422({required String error422model}) = KFailureError422;
  const factory KFailure.error401({required String error}) = KFailureError401;
  const factory KFailure.error403({required String error}) = KFailureError403;
  const factory KFailure.error409({required String error}) = KFailureError409;
}
// flutter pub run build_runner watch --delete-conflicting-outputs
