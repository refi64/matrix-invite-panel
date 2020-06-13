///
//  Generated code. Do not modify.
//  source: invite_manager.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core show int, String, List;

import 'package:grpc/service_api.dart' as $grpc;
import 'invite_manager.pb.dart' as $0;
import 'google/protobuf/empty.pb.dart' as $1;
export 'invite_manager.pb.dart';

class InviteManagerClient extends $grpc.Client {
  static final _$login = $grpc.ClientMethod<$0.LoginRequest, $1.Empty>(
      '/InviteManager/Login',
      ($0.LoginRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$ping = $grpc.ClientMethod<$1.Empty, $1.Empty>(
      '/InviteManager/Ping',
      ($1.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));
  static final _$generateInvite =
      $grpc.ClientMethod<$0.GenerateInviteRequest, $0.GenerateInviteReply>(
          '/InviteManager/GenerateInvite',
          ($0.GenerateInviteRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GenerateInviteReply.fromBuffer(value));
  static final _$listInvites =
      $grpc.ClientMethod<$1.Empty, $0.ListInvitesReply>(
          '/InviteManager/ListInvites',
          ($1.Empty value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ListInvitesReply.fromBuffer(value));
  static final _$revokeInvite =
      $grpc.ClientMethod<$0.RevokeInviteRequest, $0.RevokeInviteReply>(
          '/InviteManager/RevokeInvite',
          ($0.RevokeInviteRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.RevokeInviteReply.fromBuffer(value));

  InviteManagerClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$1.Empty> login($0.LoginRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$login, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$1.Empty> ping($1.Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$ping, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.GenerateInviteReply> generateInvite(
      $0.GenerateInviteRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$generateInvite, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.ListInvitesReply> listInvites($1.Empty request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$listInvites, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.RevokeInviteReply> revokeInvite(
      $0.RevokeInviteRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$revokeInvite, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class InviteManagerServiceBase extends $grpc.Service {
  $core.String get $name => 'InviteManager';

  InviteManagerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.LoginRequest, $1.Empty>(
        'Login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginRequest.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.Empty, $1.Empty>(
        'Ping',
        ping_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.Empty.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GenerateInviteRequest, $0.GenerateInviteReply>(
            'GenerateInvite',
            generateInvite_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GenerateInviteRequest.fromBuffer(value),
            ($0.GenerateInviteReply value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$1.Empty, $0.ListInvitesReply>(
        'ListInvites',
        listInvites_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $1.Empty.fromBuffer(value),
        ($0.ListInvitesReply value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.RevokeInviteRequest, $0.RevokeInviteReply>(
            'RevokeInvite',
            revokeInvite_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.RevokeInviteRequest.fromBuffer(value),
            ($0.RevokeInviteReply value) => value.writeToBuffer()));
  }

  $async.Future<$1.Empty> login_Pre(
      $grpc.ServiceCall call, $async.Future<$0.LoginRequest> request) async {
    return login(call, await request);
  }

  $async.Future<$1.Empty> ping_Pre(
      $grpc.ServiceCall call, $async.Future<$1.Empty> request) async {
    return ping(call, await request);
  }

  $async.Future<$0.GenerateInviteReply> generateInvite_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.GenerateInviteRequest> request) async {
    return generateInvite(call, await request);
  }

  $async.Future<$0.ListInvitesReply> listInvites_Pre(
      $grpc.ServiceCall call, $async.Future<$1.Empty> request) async {
    return listInvites(call, await request);
  }

  $async.Future<$0.RevokeInviteReply> revokeInvite_Pre($grpc.ServiceCall call,
      $async.Future<$0.RevokeInviteRequest> request) async {
    return revokeInvite(call, await request);
  }

  $async.Future<$1.Empty> login(
      $grpc.ServiceCall call, $0.LoginRequest request);
  $async.Future<$1.Empty> ping($grpc.ServiceCall call, $1.Empty request);
  $async.Future<$0.GenerateInviteReply> generateInvite(
      $grpc.ServiceCall call, $0.GenerateInviteRequest request);
  $async.Future<$0.ListInvitesReply> listInvites(
      $grpc.ServiceCall call, $1.Empty request);
  $async.Future<$0.RevokeInviteReply> revokeInvite(
      $grpc.ServiceCall call, $0.RevokeInviteRequest request);
}
