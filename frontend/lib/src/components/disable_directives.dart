import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/interfaces/has_disabled.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:meta/meta.dart';

import '../blocs/status_bloc.dart';

/// Disable directives are an easy way of disabling individual controls on
/// various *composable* conditions.
/// A control is given the disableControl directive, followed by a list of one
/// or more "disable providers", e.g.:
/// ```html
/// <material-button disableControl disableOnProgress></material-button>
/// ```
/// The control directive will disable the component if *any* of the providers
/// say it should be disabled.

/// A single provider for a disabled status.
abstract class DisableProvider {
  bool get disabled;
  Stream<bool> get disabledChange;
}

const disableProviders = MultiToken<DisableProvider>('disableProviders');

@Directive(selector: '[disableControl]')
class DisableControlDirective implements OnInit, OnDestroy {
  final HasDisabled _element;
  final List<DisableProvider> _providers;
  final _providerSubscriptions = <StreamSubscription>[];
  final _activeDisabled = Set<DisableProvider>.identity();

  DisableControlDirective(
      this._element, @Inject(disableProviders) this._providers);

  void _updateDisabledState() {
    _element.disabled = _activeDisabled.isNotEmpty;
  }

  void _updateProviderState(DisableProvider provider,
      {@required bool setDisabled}) {
    if (provider.disabled) {
      _activeDisabled.add(provider);
    } else {
      _activeDisabled.remove(provider);
    }

    if (setDisabled) {
      _updateDisabledState();
    }
  }

  @override
  void ngOnInit() {
    for (var provider in _providers) {
      // Don't update the disabled state here, as it's more efficient to update
      // it at once when all the provider subscriptions are added.
      _updateProviderState(provider, setDisabled: false);
      _providerSubscriptions.add(provider.disabledChange.listen((_) {
        _updateProviderState(provider, setDisabled: true);
      }));
    }

    _updateDisabledState();
  }

  @override
  void ngOnDestroy() {
    for (var subscription in _providerSubscriptions) {
      subscription.cancel();
    }
  }
}

/// A disable provider that disables the component when the [StatusBloc] says
/// that an operation is in progress.
@Directive(
  selector: '[disableOnProgress]',
  providers: [
    ExistingProvider.forToken(disableProviders, DisableOnProgressDirective)
  ],
)
class DisableOnProgressDirective extends DisableProvider {
  final StatusBloc _statusBloc;

  DisableOnProgressDirective(this._statusBloc);

  @override
  bool get disabled => _statusBloc.state.isProgress;

  @override
  Stream<bool> get disabledChange =>
      _statusBloc.map((state) => state.isProgress);
}

/// A disable provider that disables the component when the enclsoing [NgForm]
/// is invalid.
@Directive(
  selector: '[disableWhenInvalid]',
  providers: [
    ExistingProvider.forToken(disableProviders, DisableWhenInvalidDirective)
  ],
)
class DisableWhenInvalidDirective extends DisableProvider
    implements OnInit, OnDestroy {
  final NgForm _form;

  DisableWhenInvalidDirective(this._form);

  @override
  bool get disabled => !_form.form.valid;

  final _disabledChangeController = StreamController<bool>();
  @override
  Stream<bool> get disabledChange => _disabledChangeController.stream;

  StreamSubscription _formSubscription;

  @override
  void ngOnInit() {
    _formSubscription = _form.form.valueChanges.listen((_) {
      _disabledChangeController.add(disabled);
    });

    _disabledChangeController.add(disabled);
  }

  @override
  void ngOnDestroy() {
    _formSubscription?.cancel();
  }
}

const disableDirectives = [
  DisableControlDirective,
  DisableOnProgressDirective,
  DisableWhenInvalidDirective
];
