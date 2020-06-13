import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:matrix_invite_common/generated/registration.pbgrpc.dart';

import 'invite.dart';
import 'homeserver_api.dart';
import 'service_utils.dart';
import 'synapse_api.dart';

@injectable
class RegistrationService extends RegistrationServiceBase {
  final InviteStore _invites;
  final SynapseApi _synapse;
  final Logger _logger;

  RegistrationService(this._invites, this._synapse, this._logger);

  Future<RegisterReply> _register(
      ServiceCall call, RegisterRequest request) async {
    _logger.d('register()');

    if (request.code == null ||
        request.username == null ||
        request.password == null) {
      throw GrpcError.invalidArgument('All arguments must be non-null');
    }

    if (request.username.isEmpty || request.password.isEmpty) {
      throw GrpcError.invalidArgument(
          'Username and password must be non-empty');
    }

    var invite = _invites.find(request.code);
    if (invite == null) {
      throw GrpcError.unauthenticated('Invalid invite code');
    }

    try {
      await _synapse.registerUser(
          username: request.username,
          password: request.password,
          isAdmin: invite.isAdmin);
    } on HomeserverApiException catch (ex) {
      throw GrpcError.unknown(ex.toString());
    }

    // NOTE: If this fails, the user would have been registered but the invite
    // code remains. However, that's considerably less annoying that the
    // alternative of having a valid invite code that then doesn't work, and
    // the invite expirations can help avoid abuse here.
    _invites.revoke(request.code);

    return RegisterReply();
  }

  @override
  Future<RegisterReply> register(ServiceCall call, RegisterRequest request) =>
      _logger.wrapHandler(call, request, _register);
}
