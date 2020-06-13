import 'dart:io';

import 'package:grinder/grinder.dart';
import 'package:path/path.dart';

void main(List<String> args) => grind(args);

@DefaultTask()
void buildProtos() {
  Directory('lib/generated').createSync(recursive: true);

  var path = Platform.environment['PATH'];
  var env = Map<String, String>.from(Platform.environment)
    ..['PATH'] = '$path:${dirname(Platform.script.toString())}';

  var result = Process.runSync(
      'protoc',
      [
        '--dart_out=grpc:lib/generated',
        '-Iprotos',
        'protos/invite_manager.proto',
        'protos/registration.proto',
        // XXX: This is system-specific
        '/usr/include/google/protobuf/duration.proto',
        '/usr/include/google/protobuf/empty.proto',
        '/usr/include/google/protobuf/timestamp.proto',
      ],
      environment: env);
  if (result.exitCode != 0) {
    throw Exception('Failed with return code ${result.exitCode}');
  }
}
