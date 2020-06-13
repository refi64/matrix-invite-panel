import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_bloc/angular_bloc.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../../../blocs/auth_bloc.dart';
import '../../../route_paths.dart';
import '../../disable_directives.dart';
import '../../material_submit_component.dart';

/// A form to allow an admin to log in to access the invites management panel.
@Component(
  selector: 'login-form',
  templateUrl: 'login_form_component.html',
  directives: [
    coreDirectives,
    disableDirectives,
    formDirectives,
    materialInputDirectives,
    MaterialSubmitComponent,
  ],
  pipes: [BlocPipe],
)
class LoginFormComponent implements OnInit, OnDestroy {
  @visibleForTemplate
  final AuthBloc authBloc;
  final Router _router;

  StreamSubscription _authSubscription;

  LoginFormComponent(this.authBloc, this._router);

  @override
  void ngOnInit() {
    _authSubscription = authBloc.listen((state) {
      if (state.isAuthenticated) {
        _router.navigate(RoutePaths.invites.path);
      }
    });
  }

  @override
  void ngOnDestroy() {
    _authSubscription?.cancel();
  }

  @visibleForTemplate
  final model = LoginInfo();

  @visibleForTemplate
  void onSubmit() {
    authBloc.add(LoggedInEvent(model));
  }
}
