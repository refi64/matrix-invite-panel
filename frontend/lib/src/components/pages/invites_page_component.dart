import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_bloc/angular_bloc.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import 'invites/invites_table_component.dart';
import 'invites/new_invite_dialog_component.dart';
import '../../blocs/auth_bloc.dart';
import '../../blocs/invites_bloc.dart';
import '../../blocs/status_bloc.dart';
import '../../route_paths.dart';

/// The invite management panel page.
@Component(
  selector: 'invite-page',
  templateUrl: 'invites_page_component.html',
  styleUrls: ['invites_page_component.css'],
  directives: [
    coreDirectives,
    MaterialButtonComponent,
    MaterialIconComponent,
    InvitesTableComponent,
    NewInviteDialogComponent
  ],
  providers: [InvitesBloc],
  pipes: [BlocPipe],
)
class InvitePageComponent implements OnActivate {
  final AuthBloc _authBloc;
  @visibleForTemplate
  final InvitesBloc invitesBloc;
  @visibleForTemplate
  final StatusBloc statusBloc;
  final Router _router;

  InvitePageComponent(
      this._authBloc, this.invitesBloc, this.statusBloc, this._router);

  @visibleForTemplate
  bool isAuthenticated = false;
  @visibleForTemplate
  bool newInviteDialogVisible = false;

  @override
  void onActivate(_, RouterState current) {
    if (_authBloc.state.isAuthenticated) {
      isAuthenticated = true;
      onRefresh();
    } else {
      // Redirect to the login page if the user is not signed in.
      _router.navigate(RoutePaths.login.path);
    }
  }

  @visibleForTemplate
  void onRefresh() {
    invitesBloc.add(RefreshedInvitesEvent());
  }
}
