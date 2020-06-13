import 'package:bloc/bloc.dart';

/// Helpers for creating BLoCs that use double dispatch, i.e. the event class
/// is responsible for generating the next state, not the BLoC class itself.
/// This is notably cleaner than long `if (state is XyzEvent)` branches, though
/// not nearly as elegant as something like the freeze / built_union packages.
/// (Those are unusable here due to AngularDart's outdated analyzer
/// requirement.)

/// An event that can generate the next set of states.
abstract class DispatchBlocEvent<MixedBloc, State> {
  /// Returns a stream of future states.
  Stream<State> mapNextStates(MixedBloc bloc);
}

/// An event that can generate a single next state.
abstract class SingleStateDispatchBlocEvent<MixedBloc, State>
    extends DispatchBlocEvent<MixedBloc, State> {
  Future<State> mapNextState(MixedBloc bloc);

  @override
  Stream<State> mapNextStates(MixedBloc bloc) async* {
    yield await mapNextState(bloc);
  }
}

/// A mixin to implement dispatch-based BLoCs.
mixin DispatchBloc<MixedBloc, Event extends DispatchBlocEvent<MixedBloc, State>,
    State> on Bloc<Event, State> {
  @override
  Stream<State> mapEventToState(Event event) =>
      event.mapNextStates(this as MixedBloc);
}
