import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:logger/logger.dart';
import 'package:stack_trace/stack_trace.dart';

import 'package:matrix_invite_backend/config.dart';
import 'package:matrix_invite_backend/inject.dart';
import 'package:matrix_invite_backend/invite_manager_service.dart';
import 'package:matrix_invite_backend/registration_service.dart';

void _setSslCerts() {
  // For some weird reason, Dart fails to check SSL certificates when
  // connecting to an HTTPS endpoint inside a distroless container image.
  // It seems to not respect $SSL_CERT_FILE, so that's checked manually here
  // to make it all work.
  var certFile = Platform.environment['SSL_CERT_FILE'];
  if (certFile != null) {
    SecurityContext.defaultContext.setTrustedCertificates(certFile);
  }
}

Future<void> asyncMain(List<String> args) async {
  Logger.level = Level.debug;
  _setSslCerts();

  getIt.registerSingleton(ConfigFile.fromPath(args[0]));
  configureDependencies();
  await getIt.allReady();

  var port = getIt<Config>().port;

  var server =
      Server([getIt<InviteManagerService>(), getIt<RegistrationService>()]);
  await server.serve(port: port);
  print('Server listening on port $port...');
}

Future<void> main(List<String> args) async =>
    Chain.capture(() => asyncMain(args));
