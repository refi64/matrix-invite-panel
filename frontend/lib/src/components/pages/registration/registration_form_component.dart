import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_bloc/angular_bloc.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../../blocs/registration_bloc.dart';
import '../../disable_directives.dart';
import '../../material_submit_component.dart';
import '../../text_hide_toggle_component.dart';

/// A form to allow a new user to register for a server account.
@Component(
  selector: 'registration-form',
  templateUrl: 'registration_form_component.html',
  styleUrls: ['registration_form_component.css'],
  directives: [
    coreDirectives,
    disableDirectives,
    formDirectives,
    materialInputDirectives,
    MaterialSubmitComponent,
    TextHideToggleComponent,
  ],
  pipes: [BlocPipe],
)
class RegistrationFormComponent {
  @visibleForTemplate
  final RegistrationBloc registrationBloc;

  RegistrationFormComponent(this.registrationBloc);

  @visibleForTemplate
  final model = RegistrationInfo(code: '', username: '', password: '');

  String _registrationCode;

  String get registrationCode => _registrationCode;
  @Input()
  set registrationCode(String value) {
    _registrationCode = model.code = value;
  }

  @visibleForTemplate
  void onSubmit() {
    registrationBloc.add(RegisteredEvent(model));
  }
}
