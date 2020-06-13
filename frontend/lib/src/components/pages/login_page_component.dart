import 'package:angular/angular.dart';

import 'login/login_form_component.dart';

/// A page to log in to the invite management console.
@Component(
  selector: 'login-page',
  templateUrl: 'login_page_component.html',
  directives: [LoginFormComponent],
)
class LoginPageComponent {}
