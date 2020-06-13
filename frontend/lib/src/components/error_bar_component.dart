import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_bloc/angular_bloc.dart';

import 'package:skawa_material_components/snackbar/snackbar.dart';

import '../blocs/status_bloc.dart';

/// A snackbar that shows a message when one is sent to the [StatusBloc].
/// TODO: rename to status-bar or similar, this is a holdover from when it only
/// reported errors.
@Component(
  selector: 'error-bar',
  templateUrl: 'error_bar_component.html',
  styleUrls: ['error_bar_component.css'],
  directives: [SkawaSnackbarComponent],
  providers: [SnackbarService],
  pipes: [BlocPipe],
)
class ErrorBarComponent implements OnInit {
  static const _messageDuration = Duration(seconds: 15);
  // Show the error pretty much forever, until it's dismissed.
  static const _errorDuration = Duration(days: 1);

  @visibleForTemplate
  bool isError = false;

  @visibleForTemplate
  final StatusBloc statusBloc;
  final SnackbarService _snackbarService;

  ErrorBarComponent(this.statusBloc, this._snackbarService);

  @visibleForTemplate
  @ViewChild('snackbar')
  SkawaSnackbarComponent snackbarComponent;

  @override
  void ngOnInit() {
    statusBloc.listen((StatusState state) {
      if (state.isMessage || state.isError) {
        // Note that we track isError here, to avoid the following problem:
        // - User encounters an error, leaves the snackbar showing.
        // - User performs an operation that involves progress.
        // Due to the stupid StatusBloc architecture, using something like:
        // (statusBloc | bloc).isError
        // in the template file won't work, because once a progress event is
        // sent out that no longer is an error. Thus, the "Error" text will
        // be removed from the snackbar while it's still showing.

        // TODO: make StatusBloc not stupid so this isn't a problem

        isError = state.isError;

        _snackbarService.showMessage(state.message,
            duration: isError ? _errorDuration : _messageDuration,
            action: SnackAction()
              ..label = 'Close'
              ..callback = () {
                snackbarComponent.show = false;
              });
      }
    });
  }
}
