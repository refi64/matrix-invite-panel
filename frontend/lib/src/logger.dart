import 'package:angular/angular.dart';
import 'package:logger/logger.dart';
import 'package:matrix_invite_common/logger.dart';

import 'dart:html';

/// Logs all events to the browser console.
class _ConsoleLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    var message = event.lines.join('\n');
    switch (event.level) {
      case Level.nothing:
        break;
      case Level.verbose:
      case Level.debug:
        window.console.debug(message);
        break;
      case Level.info:
        window.console.info(message);
        break;
      case Level.warning:
        window.console.warn(message);
        break;
      case Level.error:
      case Level.wtf:
        window.console.error(message);
        break;
    }
  }
}

Logger loggerFactory() => createLogger(
    level: Level.debug, output: _ConsoleLogOutput(), colors: false);

const loggerProvider = FactoryProvider<Logger>(Logger, loggerFactory);
