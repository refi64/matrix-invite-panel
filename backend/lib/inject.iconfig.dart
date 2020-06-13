// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:matrix_invite_backend/config.dart';
import 'package:matrix_invite_backend/homeserver_api.dart';
import 'package:matrix_invite_backend/invite.dart';
import 'package:matrix_invite_backend/logger.dart';
import 'package:logger/logger.dart';
import 'package:matrix_invite_backend/jwt_manager.dart';
import 'package:matrix_invite_backend/matrix_api.dart';
import 'package:matrix_invite_backend/synapse_api.dart';
import 'package:matrix_invite_backend/auth_manager.dart';
import 'package:matrix_invite_backend/invite_manager_service.dart';
import 'package:matrix_invite_backend/registration_service.dart';
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  final homeserverConfigModule = _$HomeserverConfigModule();
  final loggerModule = _$LoggerModule();
  g.registerFactory<HomeserverConfig>(
      () => homeserverConfigModule.provideConfig(g<Config>()));
  g.registerFactory<HomeserverApiFactory>(
      () => HomeserverApiFactory(g<HomeserverConfig>(), g<Logger>()));
  g.registerFactory<JwtManager>(() => JwtManager(g<Config>(), g<Logger>()));
  g.registerFactory<MatrixApi>(() => MatrixApi(g<HomeserverApiFactory>()));
  g.registerFactory<SynapseApi>(
      () => SynapseApi(g<HomeserverConfig>(), g<HomeserverApiFactory>()));
  g.registerFactory<AuthManager>(() => AuthManager(g<JwtManager>()));
  g.registerFactory<InviteManagerService>(() => InviteManagerService(
        g<InviteStore>(),
        g<Logger>(),
        g<AuthManager>(),
        g<MatrixApi>(),
        g<SynapseApi>(),
      ));
  g.registerFactory<RegistrationService>(() => RegistrationService(
        g<InviteStore>(),
        g<SynapseApi>(),
        g<Logger>(),
      ));

  //Eager singletons must be registered in the right order
  g.registerSingletonAsync<Config>(() => Config.loadYamlFile());
  g.registerSingletonAsync<InviteStore>(() => InviteStore.create(g<Config>()),
      dependsOn: [Config]);
  g.registerSingleton<Logger>(loggerModule.logger);
}

class _$HomeserverConfigModule extends HomeserverConfigModule {}

class _$LoggerModule extends LoggerModule {}
