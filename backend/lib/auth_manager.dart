import 'package:grpc/grpc.dart';
import 'package:injectable/injectable.dart';
import 'package:matrix_invite_common/metadata.dart';

import 'jwt_manager.dart';

/// A helper class to authenticate users. Note that GRPC's native interceptors
/// are not used, as the grpc-dart interface only applies to *all* services and
/// isn't very ergonic (e.g. throwing GrpcError is treated as a regular
/// exception, only returning one has the proper semantics).
@injectable
class AuthManager {
  final JwtManager _jwtManager;
  AuthManager(this._jwtManager);

  JwtClaims validateCall(ServiceCall call) {
    var token = call.clientMetadata[authRpcMetadataKey];
    if (token == null) {
      throw GrpcError.unauthenticated('No auth metadata found');
    }

    JwtClaims claims;
    try {
      claims = _jwtManager.validate(token);
    } on AuthenticationError catch (ex) {
      throw GrpcError.unauthenticated(ex.toString());
    }

    return claims;
  }

  void injectRotatedToken(ServiceCall call, {JwtClaims preexistingClaims}) {
    call.headers[rotatedRpcMetadataKey] =
        _jwtManager.generate(preexistingClaims: preexistingClaims);
  }
}
