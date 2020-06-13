import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

/// A BLoC delegate that logs full error traces.
class ErrorReportingBlocDelegate extends BlocDelegate {
  final Logger _logger;
  ErrorReportingBlocDelegate(this._logger);

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    _logger.e('Internal error', error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  void install() {
    BlocSupervisor.delegate = this;
  }
}
