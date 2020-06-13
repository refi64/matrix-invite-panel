import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_bloc/angular_bloc.dart';
import 'package:angular_router/angular_router.dart';

import '../../../config.dart';
import '../../route_paths.dart';
import '../../backend/registration_backend.dart';
import '../../blocs/registration_bloc.dart';
import 'registration/registration_form_component.dart';

/// A page to register for a new account.
@Component(
  selector: 'register-page',
  templateUrl: 'register_page_component.html',
  styleUrls: ['register_page_component.css'],
  directives: [coreDirectives, RegistrationFormComponent],
  providers: [RegistrationBackend, RegistrationBloc],
  pipes: [BlocPipe],
  exports: [RegistrationStatus],
)
class RegisterPageComponent implements OnActivate, OnDestroy {
  @visibleForTemplate
  final Config config;
  @visibleForTemplate
  final RegistrationBloc registrationBloc;

  RegisterPageComponent(this.config, this.registrationBloc);

  String get registrationCode => _registrationCode;
  String _registrationCode;

  @override
  void onActivate(_, RouterState current) {
    _registrationCode = current.queryParameters[registrationCodeQueryParameter];
  }

  @override
  void ngOnDestroy() {
    registrationBloc.close();
  }
}
