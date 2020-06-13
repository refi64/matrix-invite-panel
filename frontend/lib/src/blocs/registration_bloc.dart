import 'package:bloc/bloc.dart';

import '../backend/registration_backend.dart';
import 'dispatch_bloc_helper.dart';
import 'reporting_bloc_helper.dart';
import 'status_bloc.dart';

export '../backend/registration_backend.dart' show RegistrationInfo;

enum RegistrationStatus { registered, unregistered }

class RegistrationState {
  final RegistrationStatus status;
  final String username;

  RegistrationState._(this.status, [this.username]) {
    // Username *must* be given for a registered state.
    assert(status == RegistrationStatus.registered
        ? username != null
        : username == null);
  }

  factory RegistrationState.registered(String username) =>
      RegistrationState._(RegistrationStatus.registered, username);
  factory RegistrationState.unregistered() =>
      RegistrationState._(RegistrationStatus.unregistered);
}

/// An event that registers a user.
class RegisteredEvent
    extends SingleStateDispatchBlocEvent<RegistrationBloc, RegistrationState>
    implements ReportingBlocEvent {
  final RegistrationInfo registration;
  RegisteredEvent(this.registration);

  @override
  Future<RegistrationState> mapNextState(RegistrationBloc bloc) async {
    await bloc._backend.register(registration);
    return RegistrationState.registered(registration.username);
  }
}

class RegistrationBloc extends Bloc<RegisteredEvent, RegistrationState>
    with
        DispatchBloc<RegistrationBloc, RegisteredEvent, RegistrationState>,
        ReportingBloc<RegisteredEvent, RegistrationState> {
  @override
  final StatusBloc statusBloc;

  final RegistrationBackend _backend;

  RegistrationBloc(this.statusBloc, this._backend);

  @override
  RegistrationState get initialState => RegistrationState.unregistered();
}
