import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import 'config.dart';

// A logged in user's information for the home server.
class LoginInformation {
  final String userId;
  final String accessToken;

  LoginInformation({this.userId, this.accessToken});

  Map<String, String> accessTokenParams() => {'access_token': accessToken};
}

@module
abstract class HomeserverConfigModule {
  HomeserverConfig provideConfig(Config config) => config.homeserver;
}

class HomeserverApiException implements Exception {
  final String message;
  final bool hadResponse;
  HomeserverApiException(this.message, {this.hadResponse});

  @override
  String toString() => message;
}

class HomeserverApi extends DioForNative {
  final Logger _logger;
  HomeserverApi._(this._logger, BaseOptions options) : super(options);

  // Runs the given function, changing the error before re-throwing.
  Future<T> handleError<T>(String action, Future<T> Function() func) async {
    try {
      return await func();
    } on DioError catch (ex, stackTrace) {
      ContentType contentType;
      if (ex.response != null) {
        contentType = ContentType.parse(
            ex.response.headers[Headers.contentTypeHeader].first);
      }

      // If the content type is JSON, then the homeserver returned an API
      // error there, so log that instead of a generic error.
      if (contentType != null &&
          contentType.primaryType == 'application' &&
          contentType.subType == 'json') {
        print(ex.response.headers[Headers.contentTypeHeader]);
        _logger.e(
            'Homeserver error on $action to ${ex.request.uri}', ex, stackTrace);
        throw HomeserverApiException(
            'Failed to $action: ${ex.response.data['error']}',
            hadResponse: true);
      } else {
        _logger.e('Generic Dio error on $action to ${ex.request.uri}', ex,
            stackTrace);
        throw HomeserverApiException('Failed to $action: Internal error',
            hadResponse: false);
      }
    }
  }
}

@injectable
class HomeserverApiFactory {
  final HomeserverConfig _config;
  final Logger _logger;

  HomeserverApiFactory(this._config, this._logger);

  // Trailing slash is important, otherwise when Dio is called like
  // `dio.post('xyz')`, it will directly post to `${apiPath}xyz` without a
  // path separator in between.
  HomeserverApi create(String apiPath) => HomeserverApi._(
      _logger, BaseOptions(baseUrl: '${_config.url}/$apiPath/'));
}
