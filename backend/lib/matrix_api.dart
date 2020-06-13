import 'package:injectable/injectable.dart';

import 'homeserver_api.dart';

@injectable
class MatrixApi {
  final HomeserverApi _api;

  static const _apiPath = '_matrix/client/r0';

  MatrixApi(HomeserverApiFactory apiFactory)
      : _api = apiFactory.create(_apiPath);

  Future<LoginInformation> login(String username, String password) async {
    var loginRequest = {
      'type': 'm.login.password',
      'identifier': {
        'type': 'm.id.user',
        'user': username,
      },
      'initial_device_display_name': 'matrix-invite-code',
      'password': password,
    };

    try {
      return await _api.handleError('log in', () async {
        var response = await _api.post<Map>('login', data: loginRequest);
        return LoginInformation(
            userId: response.data['user_id'] as String,
            accessToken: response.data['access_token'] as String);
      });
    } on HomeserverApiException catch (ex) {
      if (ex.hadResponse) {
        return null;
      } else {
        rethrow;
      }
    }
  }

  Future<void> logout(
          LoginInformation information) async =>
      await _api.handleError(
          'log out',
          () async => await _api.post<void>('logout',
              queryParameters: information.accessTokenParams()));
}
