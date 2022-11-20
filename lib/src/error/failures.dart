import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'failures.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  const factory Failure.server() = FailureServer ;
  const factory Failure.offline({RequestOptions? option}) = FailureOffline;
  const factory Failure.userNotFound() = FailureUserNotFound;
  const factory Failure.locationDenaid() = FailureLocationDenaid;
  const factory Failure.locationDiabled() = FailureLocationDiabled;
  const factory Failure.locationDenaidPermenetl() = FailureLocationDenaidPermenetl;
  const factory Failure.userLogetOut() = FailureUserLogedOut;
  const factory Failure.someThingWrongPleaseTryagain() = FailureSomeThingWrongPleaseTryagain;
  const factory Failure.unknownNetIssue() = FailureUnknownNetIssue;
  const factory Failure.error(String error) = FailureDecodingResponse;
  const factory Failure.error422({required String error422model}) = FailureError422;
  const factory Failure.error401({required String error}) = FailureError401;
  const factory Failure.error403({required String error}) = FailureError403;
  const factory Failure.error409({required String error}) = FailureError409;

}
// flutter pub run build_runner watch --delete-conflicting-outputs
