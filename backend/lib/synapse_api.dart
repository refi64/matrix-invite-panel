import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:injectable/injectable.dart';

import 'config.dart';
import 'homeserver_api.dart';

@injectable
class SynapseApi {
  final HomeserverApi _api;
  final HomeserverConfig _config;

  static const _apiPath = '_synapse/admin/v1';

  SynapseApi(this._config, HomeserverApiFactory apiFactory)
      : _api = apiFactory.create(_apiPath);

  // This format is documented here:
  // https://github.com/matrix-org/synapse/blob/master/docs/admin_api/register_api.rst
  Digest _buildRegistrationDigest(
      {String nonce, String username, String password, bool isAdmin}) {
    var digestSink = AccumulatorSink<Digest>();
    var hmac = Hmac(sha1, utf8.encode(_config.registrationSecret));

    var messageSink = hmac.startChunkedConversion(digestSink);
    try {
      var parts = [nonce, username, password, isAdmin ? 'admin' : 'notadmin'];

      for (var i = 0; i < parts.length; i++) {
        if (i > 0) {
          messageSink.add([0]);
        }

        messageSink.add(utf8.encode(parts[i]));
      }
    } finally {
      messageSink.close();
    }

    return digestSink.events.first;
  }

  Future<void> registerUser(
      {String username, String password, bool isAdmin = false}) async {
    var nonce = await _api.handleError<String>('acquire nonce', () async {
      var response = await _api.get<Map>('register');
      return response.data['nonce'] as String;
    });

    var digest = _buildRegistrationDigest(
        nonce: nonce, username: username, password: password, isAdmin: isAdmin);

    var requestData = {
      'nonce': nonce,
      'username': username,
      'password': password,
      'admin': isAdmin,
      'mac': digest.toString(),
    };

    await _api.handleError('register user', () async {
      await _api.post<void>('register', data: requestData);
    });
  }

  Future<bool> isAdmin(LoginInformation information) async {
    try {
      return await _api.handleError('check admin status', () async {
        var response = await _api.get<Map>('users/${information.userId}/admin',
            queryParameters: information.accessTokenParams());
        return response.data['admin'] as bool;
      });
    } on HomeserverApiException catch (ex) {
      if (ex.hadResponse) {
        return false;
      } else {
        rethrow;
      }
    }
  }
}
