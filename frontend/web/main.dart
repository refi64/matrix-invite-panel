// implicit-dynamic: false messes with the .template.dart imports:
// ignore_for_file: argument_type_not_assignable, implicit_dynamic_function, invalid_assignment

import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:matrix_invite_frontend/app_component.template.dart' as ng;
import 'package:matrix_invite_frontend/config.dart';
import 'package:stack_trace/stack_trace.dart';

import 'main.template.dart' as self;

bool _isDevMode() {
  var isDev = false;
  assert(isDev = true);
  return isDev;
}

LocationStrategy locationStrategyFactory(PlatformLocation platformLocation,
        @Optional() @Inject(appBaseHref) String baseHref) =>
    _isDevMode()
        ? HashLocationStrategy(platformLocation, baseHref)
        : PathLocationStrategy(platformLocation, baseHref);

@GenerateInjector([
  configProvider,
  routerProviders,
  FactoryProvider<LocationStrategy>(LocationStrategy, locationStrategyFactory),
])
final InjectorFactory rootInjector = self.rootInjector$Injector;

void main() {
  Chain.capture(() {
    runApp(ng.AppComponentNgFactory, createInjector: rootInjector);
  });
}
