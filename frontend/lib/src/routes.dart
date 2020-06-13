// implicit-dynamic: false messes with the .template.dart imports:
// ignore_for_file: argument_type_not_assignable

import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';
import 'components/pages/register_page_component.template.dart'
    as register_page_component;
import 'components/pages/login_page_component.template.dart'
    as login_page_component;
import 'components/pages/invites_page_component.template.dart'
    as invites_page_component;

export 'route_paths.dart';

class Routes {
  static final register = RouteDefinition(
    routePath: RoutePaths.register,
    component: register_page_component.RegisterPageComponentNgFactory,
    useAsDefault: true,
  );

  static final login = RouteDefinition(
    routePath: RoutePaths.login,
    component: login_page_component.LoginPageComponentNgFactory,
  );

  static final invites = RouteDefinition(
    routePath: RoutePaths.invites,
    component: invites_page_component.InvitePageComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    register,
    login,
    invites,
  ];
}
