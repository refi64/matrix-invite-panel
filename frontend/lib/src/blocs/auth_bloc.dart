import 'dart:async';

import 'package:bloc/bloc.dart';

import '../backend/invite_manager_backend.dart';
import 'dispatch_bloc_helper.dart';
import 'reporting_bloc_helper.dart';
import 'status_bloc.dart';

export '../backend/invite_manager_backend.dart' show AuthToken, LoginInfo;

class AuthState {
  final AuthToken token;
  AuthState._(this.token);

  Timer _refreshTimer;

  factory AuthState.authenticated(AuthToken token) => AuthState._(token);
  factory AuthState.unauthenticated() => AuthState._(null);

  bool get isAuthenticated => token != null;
}

abstract class AuthEvent
    extends SingleStateDispatchBlocEvent<AuthBloc, AuthState> {}

/// An event for a user login.
class LoggedInEvent extends AuthEvent implements ReportingBlocEvent {
  final LoginInfo login;
  LoggedInEvent(this.login);

  @override
  Future<AuthState> mapNextState(AuthBloc bloc) async {
    var token = await bloc._backend.login(login);
    return AuthState.authenticated(token);
  }
}

/// An event for when an API call results in a new, rotated auth token.
class TokenRotatedEvent extends AuthEvent implements ReportingBlocEvent {
  final AuthToken newToken;
  TokenRotatedEvent(this.newToken);

  static TokenRotatedEvent fromAuthenticatedReply<T>(
          AuthenticatedReply<T> reply) =>
      TokenRotatedEvent(reply.newToken);

  @override
  Future<AuthState> mapNextState(AuthBloc bloc) async =>
      AuthState.authenticated(newToken);
}

/// An event for when a new auth token should be requested to keep the user
/// signed in.
class TokenRefreshRequestedEvent extends AuthEvent {
  @override
  Future<AuthState> mapNextState(AuthBloc bloc) async {
    var delegatingEvent = TokenRotatedEvent.fromAuthenticatedReply(
        await bloc._backend.ping(bloc.state.token));
    return await delegatingEvent.mapNextState(bloc);
  }
}

/// An event to log out the user.
class LoggedOutEvent extends AuthEvent {
  @override
  Future<AuthState> mapNextState(AuthBloc bloc) async =>
      AuthState.unauthenticated();
}

class AuthBloc extends Bloc<AuthEvent, AuthState>
    with
        DispatchBloc<AuthBloc, AuthEvent, AuthState>,
        ReportingBloc<AuthEvent, AuthState> {
  @override
  final StatusBloc statusBloc;

  final InviteManagerBackend _backend;

  AuthBloc(this.statusBloc, this._backend);

  @override
  AuthState get initialState => AuthState.unauthenticated();

  static const _refreshDuration = Duration(minutes: 5);
  static const _refreshRetryDuration = Duration(minutes: 1);

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) {
    if (transition.currentState._refreshTimer != null) {
      transition.currentState._refreshTimer?.cancel();
      transition.currentState._refreshTimer = null;
    }

    // If moving into some form of authenticated state, then re-arm a fresh timer.
    if (transition.nextState.isAuthenticated) {
      transition.currentState._refreshTimer = Timer(_refreshDuration, () {
        add(TokenRefreshRequestedEvent());
        // Set the timer to be the retry timer. If the token refresh succeeds,
        // then this timer will be reset to the normal refresh handler / duration,
        // otherwise the refresh timed out / errored and this will try again.
        transition.currentState._refreshTimer = Timer.periodic(
            _refreshRetryDuration,
            (timer) => add(TokenRefreshRequestedEvent()));
      });
    }

    super.onTransition(transition);
  }
}
