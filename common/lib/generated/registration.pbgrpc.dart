///
//  Generated code. Do not modify.
//  source: registration.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core show int, String, List;

import 'package:grpc/service_api.dart' as $grpc;
import 'registration.pb.dart' as $2;
export 'registration.pb.dart';

class RegistrationClient extends $grpc.Client {
  static final _$register =
      $grpc.ClientMethod<$2.RegisterRequest, $2.RegisterReply>(
          '/Registration/Register',
          ($2.RegisterRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $2.RegisterReply.fromBuffer(value));

  RegistrationClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$2.RegisterReply> register($2.RegisterRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$register, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class RegistrationServiceBase extends $grpc.Service {
  $core.String get $name => 'Registration';

  RegistrationServiceBase() {
    $addMethod($grpc.ServiceMethod<$2.RegisterRequest, $2.RegisterReply>(
        'Register',
        register_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.RegisterRequest.fromBuffer(value),
        ($2.RegisterReply value) => value.writeToBuffer()));
  }

  $async.Future<$2.RegisterReply> register_Pre(
      $grpc.ServiceCall call, $async.Future<$2.RegisterRequest> request) async {
    return register(call, await request);
  }

  $async.Future<$2.RegisterReply> register(
      $grpc.ServiceCall call, $2.RegisterRequest request);
}
