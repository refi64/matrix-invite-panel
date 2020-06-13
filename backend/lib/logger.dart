import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:matrix_invite_common/logger.dart';

@module
abstract class LoggerModule {
  @singleton
  Logger get logger => createLogger(level: Level.debug);
}
