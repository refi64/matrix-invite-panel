import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import 'config.dart';

class AuthenticationError {
  final String message;
  AuthenticationError(this.message);

  @override
  String toString() => message;
}

class JwtClaimsLoadError {
  final String claim, value;
  JwtClaimsLoadError({this.claim, this.value});

  @override
  String toString() => 'Bad JWT claim $claim';

  String toPrivateString() => 'Bad JWT claim $claim: $value';
}

class JwtClaims {
  static const firstIssueClaim = 'first-issue';

  final DateTime firstIssue;
  JwtClaims(this.firstIssue);

  factory JwtClaims.fromJwt(JWT jwt) {
    dynamic firstIssueValue = jwt.claims[firstIssueClaim];
    if (firstIssueValue == null || firstIssueValue is! String) {
      throw JwtClaimsLoadError(
          claim: firstIssueClaim, value: firstIssueValue.toString());
    }

    DateTime firstIssue;
    try {
      firstIssue = DateTime.parse(firstIssueValue as String);
    } on FormatException {
      throw JwtClaimsLoadError(
          claim: firstIssueClaim, value: firstIssueValue.toString());
    }

    return JwtClaims(firstIssue);
  }
}

extension JwtAddClaims on JWTBuilder {
  void setClaims(JwtClaims claims) => setClaim(
      JwtClaims.firstIssueClaim, claims.firstIssue.toUtc().toIso8601String());
}

@injectable
class JwtManager {
  final JWTSigner _signer;
  final Logger _logger;

  JwtManager(Config config, this._logger)
      : _signer = JWTHmacSha256Signer(config.jwtSecret);

  static const _issuer = 'matrix-invites-issuer.refi64.com';

  static const _expiresAfter = Duration(minutes: 15);
  // JWTs cannot be renewed if the initial login occurred too long ago, to
  // avoid risks from a user losing their admin privileges while already
  // logged in.
  static const _unrenewableAfter = Duration(hours: 2);

  JwtClaims validate(String token) {
    JWT jwt;

    try {
      jwt = JWT.parse(token);
    } on JWTError catch (ex) {
      _logger.e('Invalid jwt: $token', ex);
      throw AuthenticationError('Failed to parse auth token');
    }

    var errors = <String>{};

    // XXX: corsac_jwt doesn't check the algorithm, which is a bad idea:
    // https://auth0.com/blog/critical-vulnerabilities-in-json-web-token-libraries/
    if (jwt.algorithm != _signer.algorithm) {
      errors.add('The token algorithm is invalid.');
    }

    errors.addAll(
        (JWTValidator()..issuer = _issuer).validate(jwt, signer: _signer));

    if (errors.isNotEmpty) {
      _logger.e('Bad jwt claims in $token: ${errors.join(', ')}');
      throw AuthenticationError('Invalid auth token');
    }

    JwtClaims claims;
    try {
      claims = JwtClaims.fromJwt(jwt);
    } on JwtClaimsLoadError catch (ex) {
      _logger.e('Jwt claims load error: ${ex.toPrivateString()}', ex);
      throw AuthenticationError('Loading JWT: $ex');
    }

    if (DateTime.now().isAfter(claims.firstIssue.add(_unrenewableAfter))) {
      _logger.e('Unrenewable jwt auth token $token');
      throw AuthenticationError('Signed in for too long');
    }

    return claims;
  }

  String generate({JwtClaims preexistingClaims}) => (JWTBuilder()
        ..issuer = _issuer
        ..expiresAt = DateTime.now().add(_expiresAfter)
        ..setClaims(preexistingClaims ?? JwtClaims(DateTime.now())))
      .getSignedToken(_signer)
      .toString();
}
