import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grpc/grpc_web.dart';

// XXX: This whole file is unidiomatic and ugly. Really, this should be two
// blocs:
// - One to hold whether or not an operation is in progress.
// - One to hold whether or not the last operation was an error.
// However, this works well enough for the moment...

// Idle statuses mean that no operation is running right now, not that one
// didn't just complete or that there are no messages available. Even if
// an error occurs and the error message is available in the BLoC state, the
// status will still be "idle".

enum Status { idleOk, idleError, inProgress }

class StatusState {
  /// The current status.
  final Status status;

  /// The message from the last operaton, only non-null if idle.
  final String message;

  StatusState({this.status, this.message});

  bool get isIdle => status == Status.idleOk && message == null;
  bool get isProgress => status == Status.inProgress;
  bool get isMessage => status == Status.idleOk && message != null;
  bool get isError => status == Status.idleError;
}

abstract class StatusEvent {
  StatusState get nextState;
}

class IdleEvent extends StatusEvent {
  final String message;

  IdleEvent({this.message});

  @override
  StatusState get nextState =>
      StatusState(status: Status.idleOk, message: message);
}

class ErrorEvent extends StatusEvent {
  final String error;

  ErrorEvent({this.error});

  @override
  StatusState get nextState =>
      StatusState(status: Status.idleError, message: error);
}

class OperationStartedEvent extends StatusEvent {
  OperationStartedEvent();

  @override
  StatusState get nextState => StatusState(status: Status.inProgress);
}

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  @override
  StatusState get initialState => StatusState(status: Status.idleOk);

  @override
  Stream<StatusState> mapEventToState(StatusEvent event) async* {
    if (event.nextState.isIdle && state.isMessage) {
      // Do nothing to retain the same status message, if present.
      return;
    }

    yield event.nextState;
  }

  // XXX: Non-BLoC-like helpers, but the code is way more verbose without these.
  void beginOperation() => add(OperationStartedEvent());
  void finishOperationOk([String message]) => add(IdleEvent(message: message));
  void finishOperationError(String error) => add(ErrorEvent(error: error));

  Future<T> runOperationAsync<T>(Future<T> Function() func) async {
    beginOperation();

    try {
      return await func();
    } on GrpcError catch (ex) {
      finishOperationError(ex.message);
      rethrow;
    } catch (ex) {
      finishOperationError(ex.toString());
      rethrow;
    } finally {
      finishOperationOk();
    }
  }
}
