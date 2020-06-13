import 'package:bloc/bloc.dart';
import 'package:grpc/grpc_web.dart';

import 'status_bloc.dart';

/// A BLoC event should implement this interface if they want the status
/// reported to the user. See below for details.
abstract class ReportingBlocEvent {}

/// A helper mixin for BLoCs where any events that implement
/// [ReportingBlocEvent] will have their status reporting to a [StatusBloc].
/// In particular, event start, end, and error are all sent to the status.
mixin ReportingBloc<Event, State> on Bloc<Event, State> {
  StatusBloc get statusBloc;

  @override
  void onEvent(Event event) {
    if (event is ReportingBlocEvent) {
      statusBloc.beginOperation();
    }

    super.onEvent(event);
  }

  @override
  void onTransition(Transition<Event, State> transition) {
    if (transition.event is ReportingBlocEvent) {
      statusBloc.finishOperationOk();
    }

    super.onTransition(transition);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    var message = error is GrpcError ? error.message : error.toString();
    statusBloc.finishOperationError(message);

    super.onError(error, stackTrace);
  }
}
