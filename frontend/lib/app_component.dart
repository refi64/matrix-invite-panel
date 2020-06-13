import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';

import 'config.dart';
import 'src/blocs/auth_bloc.dart';
import 'src/blocs/error_reporting_delegate.dart';
import 'src/blocs/status_bloc.dart';
import 'src/backend/channel.dart';
import 'src/backend/invite_manager_backend.dart';
import 'src/components/error_bar_component.dart';
import 'src/components/progress_bar_component.dart';
import 'src/logger.dart';
import 'src/routes.dart';
import 'src/route_paths.dart';

@Component(
  selector: 'my-app',
  templateUrl: 'app_component.html',
  styleUrls: ['app_component.css'],
  directives: [ErrorBarComponent, ProgressBarComponent, routerDirectives],
  providers: [
    AuthBloc,
    StatusBloc,
    ErrorReportingBlocDelegate,
    InviteManagerBackend,
    channelProvider,
    loggerProvider,
    materialProviders,
  ],
  exports: [Routes, RoutePaths],
)
class AppComponent implements OnInit {
  @visibleForTemplate
  final Config config;
  final ErrorReportingBlocDelegate _delegate;

  AppComponent(this.config, this._delegate);

  @override
  void ngOnInit() {
    _delegate.install();
  }
}
