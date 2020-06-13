import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/meta.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_components/material_icon/material_icon_toggle.dart';

/// A toggleable icon button that shows / hides text inside an element.
/// When the text is "hidden", the target element's contents will be replaced
/// by a string of password-style bullet points so its contents are not easily
/// visible, but it will be shown fully on click.
/// It is recommended that the target element is monospace to avoid the length
/// bouncing around on toggle.
@Component(
    selector: 'text-hide-toggle',
    templateUrl: 'text_hide_toggle_component.html',
    directives: [
      MaterialButtonComponent,
      MaterialIconComponent,
      MaterialIconToggleDirective,
    ],
    providers: [
      ExistingProvider<HasDisabled>(HasDisabled, TextHideToggleComponent),
    ])
class TextHideToggleComponent implements HasDisabled {
  @override
  @Input()
  bool disabled = false;

  @Input()
  bool light = false;

  @Input()
  String size;

  String _text;
  String get text => _text;
  @Input()
  set text(String value) {
    _text = value;
    _updateVisibility();
  }

  Element _target;
  Element get target => _target;
  @Input()
  set target(Element value) {
    _target = value;
    _updateVisibility();
  }

  @visibleForTemplate
  bool hidden = true;

  void _updateVisibility() {
    if (target == null || text == null) {
      return;
    }

    _target.text = hidden ? '•' * text.length : text;
  }

  @visibleForTemplate
  void toggleVisibility() {
    hidden = !hidden;
    _updateVisibility();
  }
}
