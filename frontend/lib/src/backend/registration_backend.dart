import 'package:grpc/grpc_web.dart';
import 'package:matrix_invite_common/generated/registration.pbgrpc.dart';

class RegistrationInfo {
  String code;
  String username;
  String password;

  RegistrationInfo({this.code, this.username, this.password});
}

class RegistrationBackend {
  final RegistrationClient _client;

  RegistrationBackend(GrpcWebClientChannel channel)
      : _client = RegistrationClient(channel);

  Future<void> register(RegistrationInfo registration) async {
    var request = RegisterRequest()
      ..code = registration.code
      ..username = registration.username
      ..password = registration.password;
    await _client.register(request);
  }
}
