import 'package:logger/logger.dart';
import 'package:stack_trace/stack_trace.dart';

class _StackTracePrettyPrinter extends LogPrinter {
  final PrettyPrinter _prettyPrinter;
  _StackTracePrettyPrinter(this._prettyPrinter);

  @override
  List<String> log(LogEvent event) => _prettyPrinter.log(LogEvent(event.level,
      event.message, event.error, Chain.forTrace(event.stackTrace).terse));
}

/// Creates a chain-enabled logger, backed by a PrettyPrinter instance with
/// unlimited traceback length.
Logger createLogger({Level level, LogOutput output, bool colors = true}) =>
    Logger(
        filter: ProductionFilter(),
        printer: _StackTracePrettyPrinter(PrettyPrinter(
            colors: colors, methodCount: 999, errorMethodCount: 999)),
        output: output,
        level: level);
