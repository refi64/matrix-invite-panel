import 'package:bloc/bloc.dart';

import '../backend/invite_manager_backend.dart';
import 'auth_bloc.dart';
import 'dispatch_bloc_helper.dart';
import 'reporting_bloc_helper.dart';
import 'status_bloc.dart';

export '../backend/invite_manager_backend.dart' show NewInvite, Invite;

enum InvitesStateLastChange { load, add, remove }

/// A set of available invites. Note that the last change is stored, as the
/// invite list is updated in place on add/remove instead of refreshing the
/// entire invite list, as this is more efficient and gives largely
/// equivalent results.
class InvitesState {
  final Map<String, Invite> _invites;
  final InvitesStateLastChange lastChange;
  InvitesState._(this._invites, this.lastChange);

  List<Invite> get invites => _invites.values.toList()
    ..sort((a, b) => a.expiration.compareTo(b.expiration));

  factory InvitesState._fromList(List<Invite> invites) => InvitesState._(
      {for (var invite in invites) invite.code: invite},
      InvitesStateLastChange.load);

  // We do a mutable operation below, because:
  // - It's more efficient
  // - The wrapper object will be different, so BLoC change detection still works

  InvitesState _withInvite(Invite invite) {
    _invites[invite.code] = invite;
    return InvitesState._(_invites, InvitesStateLastChange.add);
  }

  InvitesState _withoutInvite(String code) {
    _invites.remove(code);
    return InvitesState._(_invites, InvitesStateLastChange.remove);
  }
}

/// A helper that automatically adds token rotation events with the result of
/// authenticated API calls.
abstract class InvitesEvent
    extends SingleStateDispatchBlocEvent<InvitesBloc, InvitesState>
    implements ReportingBlocEvent {
  Future<T> _runTokenRotatingOperation<T>(InvitesBloc bloc,
      Future<AuthenticatedReply<T>> Function(AuthToken token) func) async {
    var reply = await func(bloc._authBloc.state.token);
    bloc._authBloc.add(TokenRotatedEvent(reply.newToken));
    return reply.reply;
  }
}

/// An event that refreshes the list of invites.
class RefreshedInvitesEvent extends InvitesEvent {
  @override
  Future<InvitesState> mapNextState(InvitesBloc bloc) async =>
      InvitesState._fromList(
          await _runTokenRotatingOperation(bloc, bloc._backend.listInvites));
}

/// An event that adds a new invite.
class AddedInvitesEvent extends InvitesEvent {
  final NewInvite newInvite;
  AddedInvitesEvent(this.newInvite);

  @override
  Future<InvitesState> mapNextState(InvitesBloc bloc) async {
    var invite = await _runTokenRotatingOperation(
        bloc, (token) => bloc._backend.generateInvite(token, newInvite));
    return bloc.state._withInvite(invite);
  }
}

/// An event that revokes an invite.
class RevokedInvitesEvent extends InvitesEvent {
  final String inviteCode;
  RevokedInvitesEvent(this.inviteCode);

  @override
  Future<InvitesState> mapNextState(InvitesBloc bloc) async {
    await _runTokenRotatingOperation(
        bloc, (token) => bloc._backend.revokeInvite(token, inviteCode));
    return bloc.state._withoutInvite(inviteCode);
  }
}

class InvitesBloc extends Bloc<InvitesEvent, InvitesState>
    with
        DispatchBloc<InvitesBloc, InvitesEvent, InvitesState>,
        ReportingBloc<InvitesEvent, InvitesState> {
  @override
  final StatusBloc statusBloc;

  final AuthBloc _authBloc;
  final InviteManagerBackend _backend;

  InvitesBloc(this.statusBloc, this._authBloc, this._backend);

  @override
  InvitesState get initialState => InvitesState._fromList(<Invite>[]);
}
