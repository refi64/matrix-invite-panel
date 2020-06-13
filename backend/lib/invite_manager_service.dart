import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:matrix_invite_common/proto_convert.dart';
import 'package:matrix_invite_common/generated/google/protobuf/empty.pb.dart';
import 'package:matrix_invite_common/generated/invite_manager.pb.dart' as proto;
import 'package:matrix_invite_common/generated/invite_manager.pbgrpc.dart'
    hide Invite;

import 'auth_manager.dart';
import 'invite.dart';
import 'homeserver_api.dart';
import 'matrix_api.dart';
import 'service_utils.dart';
import 'synapse_api.dart';

@injectable
class InviteManagerService extends InviteManagerServiceBase {
  final InviteStore _invites;
  final Logger _logger;
  final AuthManager _authManager;
  final MatrixApi _matrixApi;
  final SynapseApi _synapseApi;

  InviteManagerService(this._invites, this._logger, this._authManager,
      this._matrixApi, this._synapseApi);

  void _verifyAndRotateAuth(ServiceCall call) {
    var claims = _authManager.validateCall(call);
    _authManager.injectRotatedToken(call, preexistingClaims: claims);
  }

  Future<Empty> _login(ServiceCall call, LoginRequest request) async {
    _logger.d('login()');

    if (request.username == null || request.password == null) {
      throw GrpcError.invalidArgument('Username and password must not be null');
    }

    LoginInformation login;

    try {
      login = await _matrixApi.login(request.username, request.password);

      if (login == null) {
        throw GrpcError.unauthenticated('Invalid login information');
      }

      var isAdmin = await _synapseApi.isAdmin(login);
      if (!isAdmin) {
        throw GrpcError.unauthenticated('User must be admin');
      }
    } on HomeserverApiException {
      throw GrpcError.internal('Failed to talk to home server');
    } finally {
      if (login != null) {
        try {
          await _matrixApi.logout(login);
        } catch (ex) {
          _logger.e('Failed to log user back out', ex);
        }
      }
    }

    _authManager.injectRotatedToken(call);
    return Empty();
  }

  @override
  Future<Empty> login(ServiceCall call, LoginRequest request) async =>
      _logger.wrapHandler(call, request, _login);

  Future<Empty> _ping(ServiceCall call, Empty request) async {
    _verifyAndRotateAuth(call);
    return Empty();
  }

  @override
  Future<Empty> ping(ServiceCall call, Empty request) =>
      _logger.wrapHandler(call, request, _ping);

  Future<GenerateInviteReply> _generateInvite(
      ServiceCall call, GenerateInviteRequest request) async {
    _verifyAndRotateAuth(call);

    if (request.description == null || request.expiresAfter == null) {
      throw GrpcError.invalidArgument(
          'Description and expires_after must not be null');
    }

    if (request.description.isEmpty) {
      throw GrpcError.invalidArgument('Description must not be empty');
    }

    if (request.expiresAfter.toNativeDuration().inHours == 0) {
      throw GrpcError.invalidArgument('Duration must be at least an hour');
    }

    var invite = Invite.create(
        description: request.description,
        isAdmin: request.admin,
        expiresAfter: request.expiresAfter.toNativeDuration());
    var id = await _invites.generate(invite);

    return proto.GenerateInviteReply()
      ..invite = (proto.Invite()
        ..code = id
        ..description = invite.description
        ..admin = invite.isAdmin
        ..expiration = invite.expiration.toProtoTimestamp());
  }

  @override
  Future<GenerateInviteReply> generateInvite(
          ServiceCall call, GenerateInviteRequest request) =>
      _logger.wrapHandler(call, request, _generateInvite);

  Future<ListInvitesReply> _listInvites(ServiceCall call, Empty request) async {
    _verifyAndRotateAuth(call);

    return proto.ListInvitesReply()
      ..invites.addAll(_invites.invites.map((entry) => proto.Invite()
        ..code = entry.key
        ..description = entry.value.description
        ..admin = entry.value.isAdmin
        ..expiration = entry.value.expiration.toProtoTimestamp()));
  }

  @override
  Future<ListInvitesReply> listInvites(ServiceCall call, Empty request) =>
      _logger.wrapHandler(call, request, _listInvites);

  Future<RevokeInviteReply> _revokeInvite(
      ServiceCall call, RevokeInviteRequest request) async {
    _verifyAndRotateAuth(call);

    if (request.code == null) {
      throw GrpcError.invalidArgument('request must not be null');
    }

    await _invites.revoke(request.code);
    return RevokeInviteReply();
  }

  @override
  Future<RevokeInviteReply> revokeInvite(
          ServiceCall call, RevokeInviteRequest request) =>
      _logger.wrapHandler(call, request, _revokeInvite);
}
