import 'dart:html' hide Location;

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import '../../../blocs/invites_bloc.dart';
import '../../../blocs/status_bloc.dart';
import '../../disable_directives.dart';
import '../../text_hide_toggle_component.dart';
import '../../../route_paths.dart';

/// A display of a single invite.
@Component(
  selector: 'invite-card',
  templateUrl: 'invite_card_component.html',
  styleUrls: ['invite_card_component.css'],
  directives: [
    coreDirectives,
    disableDirectives,
    MaterialButtonComponent,
    MaterialIconComponent,
    TextHideToggleComponent,
  ],
)
class InviteCardComponent {
  @visibleForTemplate
  final InvitesBloc invitesBloc;
  @visibleForTemplate
  final StatusBloc statusBloc;
  final Location _location;

  InviteCardComponent(this.invitesBloc, this.statusBloc, this._location);

  @Input()
  Invite invite;

  @visibleForTemplate
  void onRevoke() {
    invitesBloc.add(RevokedInvitesEvent(invite.code));
  }

  @visibleForTemplate
  void onCopy() async {
    var path = _location.prepareExternalUrl(RoutePaths.register
        .toUrl(queryParameters: {registrationCodeQueryParameter: invite.code}));
    await window.navigator.clipboard
        .writeText(Location.joinWithSlash(window.location.origin, path));
    statusBloc.finishOperationOk('Invite URL copied to clipboard');
  }
}
