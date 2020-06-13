import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_bloc/angular_bloc.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import '../../../blocs/invites_bloc.dart';
import '../../disable_directives.dart';
import '../../material_submit_component.dart';

/// A dialog to allow the admin to generate a new invite.
@Component(
  selector: 'new-invite-dialog',
  templateUrl: 'new_invite_dialog_component.html',
  styleUrls: ['new_invite_dialog_component.css'],
  providers: [overlayBindings, popupBindings],
  directives: [
    coreDirectives,
    disableDirectives,
    formDirectives,
    materialInputDirectives,
    materialNumberInputDirectives,
    MaterialButtonComponent,
    MaterialCheckboxComponent,
    MaterialDialogComponent,
    MaterialIconComponent,
    MaterialSubmitComponent,
    ModalComponent
  ],
  pipes: [BlocPipe],
)
class NewInviteDialogComponent implements OnInit, OnDestroy {
  @visibleForTemplate
  final InvitesBloc invitesBloc;

  NewInviteDialogComponent(this.invitesBloc);

  @visibleForTemplate
  var model = NewInvite(description: '', isAdmin: false, expiresAfter: null);

  StreamSubscription _invitesSubscription;

  @override
  void ngOnInit() {
    _invitesSubscription = invitesBloc.listen((state) {
      if (state.lastChange == InvitesStateLastChange.add) {
        visible = false;
      }
    });
  }

  @override
  void ngOnDestroy() {
    _invitesSubscription?.cancel();
  }

  // Reports the dialog's visibility state, for easy binding to the parent.
  bool _visible = false;
  bool get visible => _visible;
  @Input()
  set visible(bool value) {
    _visible = value;
    _visibleChange.add(value);
  }

  final _visibleChange = StreamController<bool>();
  @Output()
  Stream<bool> get visibleChange => _visibleChange.stream;

  @visibleForTemplate
  void onSubmit() {
    invitesBloc.add(AddedInvitesEvent(model));
  }

  @visibleForTemplate
  void updateDuration(String hoursString) {
    model.expiresAfter =
        hoursString.isNotEmpty ? Duration(hours: int.parse(hoursString)) : null;
  }
}
