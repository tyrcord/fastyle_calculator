import 'package:flutter/material.dart';

import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:tbloc_dart/tbloc_dart.dart';

abstract class FastCalculatorBloc<E extends FastCalculatorBlocEvent,
    S extends FastCalculatorBlocState> extends BidirectionalBloc<E, S> {
  @protected
  late S defaultCalculatorState;

  @protected
  bool get isCalculatorStateDirty =>
      defaultCalculatorState.fields != currentState.fields;

  FastCalculatorBloc({
    required S initialState,
  }) : super(initialState: initialState);

  @protected
  Future<S?> patchCalculatorState(String key, dynamic value);

  @protected
  Future<S> initializeCalculatorState();

  @protected
  Future<bool> isCalculatorStateValid();

  @protected
  Future<FastCalculatorResults> compute();

  @protected
  Future<S> initializeDefaultCalculatorState() async => currentState;

  @protected
  Future<S> clearCalculatorState() async => defaultCalculatorState;

  @protected
  Future<bool> saveCalculatorState() async => true;

  @protected
  Future<void> shareCalculatorState() async => null;

  @override
  Stream<S> mapEventToState(FastCalculatorBlocEvent event) async* {
    final payload = event.payload;
    final eventType = event.type;

    if (eventType == FastCalculatorBlocEventType.init &&
        !isInitializing &&
        !isInitialized) {
      yield* _handleInitializeEvent();
    } else if (eventType == FastCalculatorBlocEventType.initialized &&
        isInitializing &&
        !isInitialized) {
      yield* _handleInitializedEvent();
    } else if (isInitialized) {
      if (eventType == FastCalculatorBlocEventType.patchValue) {
        var state = await patchCalculatorState(payload!.key!, payload.value);

        if (state != null) {
          await saveCalculatorState();
          yield state;
          addEvent(FastCalculatorBlocEvent.compute());
        }
      } else if (eventType == FastCalculatorBlocEventType.compute) {
        yield currentState.copyWith(
          isValid: await isCalculatorStateValid(),
          isDirty: isCalculatorStateDirty,
          isBusy: true,
        ) as S;

        final results = await compute();
        addEvent(FastCalculatorBlocEvent.computed(results));
      } else if (eventType == FastCalculatorBlocEventType.computed) {
        yield currentState.copyWith(
          isBusy: false,
          results: payload!.results,
        ) as S;
      } else if (eventType == FastCalculatorBlocEventType.clear) {
        var state = await clearCalculatorState();
        await saveCalculatorState();
        yield state;
        addEvent(FastCalculatorBlocEvent.compute());
      } else if (eventType == FastCalculatorBlocEventType.share) {
        await shareCalculatorState();
      }
    }
  }

  Stream<S> _handleInitializeEvent() async* {
    isInitializing = true;

    yield currentState.copyWith(isInitializing: true) as S;

    // TODO: check for errors
    defaultCalculatorState = await initializeDefaultCalculatorState();
    var state = await initializeCalculatorState();

    yield currentState
        .merge(defaultCalculatorState)
        .merge(state)
        .copyWith(isInitializing: true) as S;

    addEvent(FastCalculatorBlocEvent.initialized());
  }

  Stream<S> _handleInitializedEvent() async* {
    isInitializing = false;
    isInitialized = true;

    defaultCalculatorState = defaultCalculatorState.copyWith(
      isInitializing: false,
      isInitialized: true,
    ) as S;

    yield currentState.copyWith(
      isInitializing: false,
      isInitialized: true,
    ) as S;

    addEvent(FastCalculatorBlocEvent.compute());
  }
}
