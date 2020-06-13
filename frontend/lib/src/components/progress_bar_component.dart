import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_bloc/angular_bloc.dart';
import 'package:angular_components/angular_components.dart';

import '../blocs/status_bloc.dart';

/// A small progress bar that runs when the [StatusBloc] reports that an
/// operation is in progress.
@Component(
  selector: 'progress-bar',
  templateUrl: 'progress_bar_component.html',
  styleUrls: ['progress_bar_component.css'],
  directives: [coreDirectives, MaterialProgressComponent],
  exports: [Status],
  pipes: [BlocPipe],
)
class ProgressBarComponent {
  @visibleForTemplate
  final StatusBloc statusBloc;

  ProgressBarComponent(this.statusBloc);
}
