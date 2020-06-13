import 'package:angular_router/angular_router.dart';

class RoutePaths {
  static final register = RoutePath(path: 'register');
  static final login = RoutePath(path: 'login');
  static final invites = RoutePath(path: 'invites');
}

const registrationCodeQueryParameter = 'code';
