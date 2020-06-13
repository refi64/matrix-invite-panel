import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:meta/meta.dart';

/// A wrapper over material-button that allows it to receive form submit
/// events. Normally it cannot, as it is not implemented as a butotn.
/// https://github.com/dart-lang/angular_components/issues/269
@Component(
  selector: 'material-submit',
  templateUrl: 'material_submit_component.html',
  styleUrls: ['material_submit_component.css'],
  providers: [
    AcxDarkTheme,
    ExistingProvider<ButtonDirective>(ButtonDirective, MaterialSubmitComponent),
    ExistingProvider<HasDisabled>(HasDisabled, MaterialSubmitComponent)
  ],
  directives: [MaterialButtonComponent],
)
class MaterialSubmitComponent implements MaterialButtonComponent {
  @visibleForTemplate
  final NgForm form;

  MaterialSubmitComponent(this.form);

  @ViewChild('button')
  @visibleForTemplate
  MaterialButtonComponent button;

  @override
  String get ariaLabel => button.ariaLabel;
  @override
  String get ariaRole => button.ariaRole;

  @override
  bool get disabled => button.disabled;
  @override
  @Input()
  set disabled(bool value) => button.disabled = value;

  @override
  String get disabledStr => button.disabledStr;
  @override
  bool get focused => button.focused;

  // The values here don't really matter, but these properties have to be
  // present in order to implement the material-button interface.
  @override
  @visibleForTemplate
  bool get hostClassIsFocused => null;
  @override
  @visibleForTemplate
  String get hostDisabled => null;
  @override
  @visibleForTemplate
  String get hostElevation => null;
  @override
  @visibleForTemplate
  String get hostRaised => null;

  @override
  String get hostTabIndex => button.hostTabIndex;
  @override
  bool get isMouseDown => button.isMouseDown;

  @override
  bool get raised => button.raised;
  @override
  @Input()
  set raised(bool value) => button.raised = value;

  @override
  String get role => button.role;
  @override
  @Input()
  set role(String value) => button.role = value;

  @override
  bool get tabbable => button.tabbable;
  @override
  @Input()
  set tabbable(bool value) => button.tabbable = value;

  @override
  String get tabIndex => button.tabIndex;

  @override
  @Input()
  set tabindex(String value) => button.tabindex = value;

  @override
  Stream<UIEvent> get trigger => button.trigger;

  @override
  bool get visualFocus => button.visualFocus;

  @override
  int get zElevation => button.zElevation;

  @override
  void dispose() => button.dispose();

  @override
  void focus() => button.focus();

  @override
  @visibleForOverriding
  void focusedStateChanged() {}

  @override
  @visibleForOverriding
  void handleClick(MouseEvent mouseEvent) {}

  @override
  @visibleForOverriding
  void handleKeyPress(KeyboardEvent keyboardEvent) {}

  @override
  @visibleForOverriding
  void onBlur(UIEvent event) {}

  @override
  @visibleForOverriding
  void onFocus(UIEvent event) {}

  @override
  @visibleForOverriding
  void onMouseDown(dynamic _) {}

  @override
  @visibleForOverriding
  void onMouseUp(dynamic _) {}

  @override
  void updateTabIndex() => button.updateTabIndex();
}
