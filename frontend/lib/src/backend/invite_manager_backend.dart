import 'package:grpc/grpc_web.dart';
import 'package:matrix_invite_common/metadata.dart';
import 'package:matrix_invite_common/proto_convert.dart';
import 'package:matrix_invite_common/generated/google/protobuf/empty.pb.dart';
import 'package:matrix_invite_common/generated/invite_manager.pb.dart' as proto;
import 'package:matrix_invite_common/generated/invite_manager.pbgrpc.dart';

class LoginInfo {
  String username;
  String password;

  LoginInfo({this.username, this.password});
}

/// A JWT auth token, to authenticate server requests.
class AuthToken {
  final String token;
  AuthToken(this.token);
}

/// A model representing a new invite that will be created.
class NewInvite {
  String description;
  bool isAdmin = false;
  Duration expiresAfter;

  NewInvite({this.description, this.isAdmin, this.expiresAfter});
}

/// A model representing an existing invite.
class Invite {
  final String code;
  final String description;
  final bool isAdmin;
  final DateTime expiration;

  Invite({this.code, this.description, this.isAdmin, this.expiration});

  static Invite _fromProtoInvite(proto.Invite p) => Invite(
      code: p.code,
      description: p.description,
      isAdmin: p.admin,
      expiration: p.expiration.toNativeDateTime());
}

/// A GRPC server reply with a JWT token in the result metadata, which can
/// then be used to rotate the current token.
class AuthenticatedReply<T> {
  final T reply;
  final AuthToken newToken;

  AuthenticatedReply({this.reply, this.newToken});

  AuthenticatedReply<R> mapReply<R>(R Function(T value) func) =>
      AuthenticatedReply(reply: func(reply), newToken: newToken);
}

class InviteManagerBackend {
  final InviteManagerClient _client;

  InviteManagerBackend(GrpcWebClientChannel channel)
      : _client = InviteManagerClient(channel);

  CallOptions _authenticatedCallOptions(AuthToken token) =>
      CallOptions(metadata: {authRpcMetadataKey: token.token});

  Future<AuthenticatedReply<T>> _readAuthenticatedReply<T>(
      ResponseFuture<T> responseFuture) async {
    var resp = await responseFuture;

    var headers = await responseFuture.headers;
    var token = AuthToken(headers[rotatedRpcMetadataKey]);

    return AuthenticatedReply(reply: resp, newToken: token);
  }

  Future<AuthToken> login(LoginInfo login) async {
    var request = LoginRequest()
      ..username = login.username
      ..password = login.password;

    var reply = await _readAuthenticatedReply(_client.login(request));
    return reply.newToken;
  }

  Future<AuthenticatedReply<Invite>> generateInvite(
      AuthToken token, NewInvite newInvite) async {
    var request = GenerateInviteRequest()
      ..description = newInvite.description
      ..admin = newInvite.isAdmin
      ..expiresAfter = newInvite.expiresAfter.toProtoDuration();

    var reply = await _readAuthenticatedReply(_client.generateInvite(request,
        options: _authenticatedCallOptions(token)));
    return reply.mapReply((r) => Invite._fromProtoInvite(r.invite));
  }

  Future<AuthenticatedReply<List<Invite>>> listInvites(AuthToken token) async {
    var reply = await _readAuthenticatedReply(_client.listInvites(Empty(),
        options: _authenticatedCallOptions(token)));
    return reply
        .mapReply((r) => r.invites.map(Invite._fromProtoInvite).toList());
  }

  Future<AuthenticatedReply<void>> revokeInvite(
      AuthToken token, String code) async {
    var request = proto.RevokeInviteRequest()..code = code;

    var reply = await _readAuthenticatedReply(_client.revokeInvite(request,
        options: _authenticatedCallOptions(token)));
    return reply.mapReply((_) => null);
  }

  Future<AuthenticatedReply<void>> ping(AuthToken token) async {
    var reply = await _readAuthenticatedReply(
        _client.ping(Empty(), options: _authenticatedCallOptions(token)));
    return reply.mapReply((_) => null);
  }
}
