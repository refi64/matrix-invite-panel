import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_bloc/angular_bloc.dart';

import '../../../blocs/invites_bloc.dart';
import 'invite_card_component.dart';

/// A list of invites.
/// TODO: rename to "invites-list" or similar, this name is a holdover from
/// when this was a Skawa table, but that was far messier and uglier overall.
@Component(
  selector: 'invites-table',
  templateUrl: 'invites_table_component.html',
  styleUrls: ['invites_table_component.css'],
  directives: [coreDirectives, InviteCardComponent],
  pipes: [BlocPipe],
)
class InvitesTableComponent {
  @visibleForTemplate
  final InvitesBloc invitesBloc;

  InvitesTableComponent(this.invitesBloc);

  @visibleForTemplate
  Object trackInvitesByCode(int index, dynamic invite) =>
      (invite as Invite).code;
}
