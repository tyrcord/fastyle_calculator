import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:flutter/material.dart';
import 'package:tbloc_dart/tbloc_dart.dart';

abstract class FastCalculatorBloc<
    E extends FastCalculatorBlocEvent,
    S extends FastCalculatorBlocState,
    R extends FastCalculatorResults> extends BidirectionalBloc<E, S> {
  @protected
  late S defaultCalculatorState;

  FastCalculatorBloc({
    required S initialState,
  }) : super(initialState: initialState);

  @protected
  Future<S?> patchCalculatorState(String key, dynamic value);

  @protected
  Future<S> initializeCalculatorState();

  @protected
  Future<R> compute();

  @protected
  Future<R> retrieveDefaultResult();

  @protected
  // ignore: no-empty-block
  Future<void> initialize() async {}

  @protected
  Future<bool> isCalculatorStateValid() async => true;

  @protected
  Future<bool> isCalculatorStateDirty() async {
    return defaultCalculatorState.fields != currentState.fields;
  }

  @protected
  Future<S> initializeDefaultCalculatorState() async => currentState;

  @protected
  Future<S> clearCalculatorState() async => defaultCalculatorState;

  @protected
  Future<bool> saveCalculatorState() async => true;

  @protected
  Future<void> shareCalculatorState() async {
    throw '`shareCalculatorState` function is not implemented';
  }

  @override
  bool shouldProcessEventInOrder() => false;

  @override
  Stream<S> mapEventToState(FastCalculatorBlocEvent event) async* {
    final payload = event.payload;
    final eventType = event.type;

    if (isInitialized) {
      if (eventType == FastCalculatorBlocEventType.patchValue) {
        yield* _handlePatchValueEvent(payload!);
      } else if (eventType == FastCalculatorBlocEventType.compute) {
        yield* _handleComputeEvent();
      } else if (eventType == FastCalculatorBlocEventType.computed) {
        yield currentState.copyWith(
          results: payload!.results,
          isBusy: false,
        ) as S;
      } else if (eventType == FastCalculatorBlocEventType.computeFailed) {
        yield currentState.copyWith(
          results: await retrieveDefaultResult(),
          isBusy: false,
        ) as S;
      } else if (eventType == FastCalculatorBlocEventType.clear) {
        final nextState = await clearCalculatorState();
        await saveCalculatorState();
        yield nextState.copyWith(
          isInitialized: true,
        ) as S;
        addEvent(FastCalculatorBlocEvent.compute<R>());
      } else if (eventType == FastCalculatorBlocEventType.custom) {
        if (payload!.key == 'share') {
          await shareCalculatorState();
        }
      } else if (eventType == FastCalculatorBlocEventType.reset) {
        yield* _handleResetEvent();
      }
    } else if (eventType == FastCalculatorBlocEventType.init &&
        !isInitializing &&
        !isInitialized) {
      yield* _handleInitializeEvent();
    } else if (eventType == FastCalculatorBlocEventType.initialized &&
        isInitializing &&
        !isInitialized) {
      yield* _handleInitializedEvent();
    } else if (eventType == FastCalculatorBlocEventType.initFailed &&
        isInitializing &&
        !isInitialized) {
      yield* _handleInitializeFailedEvent();
    }
  }

  Stream<S> _handleInitializeEvent() async* {
    isInitializing = true;
    yield currentState.copyWith(isInitializing: isInitializing) as S;

    try {
      await initialize();
      defaultCalculatorState = await initializeDefaultCalculatorState();
      final nextState = await initializeCalculatorState();

      yield currentState
          .merge(defaultCalculatorState)
          .merge(nextState)
          .copyWith(isInitializing: isInitializing) as S;

      addEvent(FastCalculatorBlocEvent.initialized<R>());
    } catch (error) {
      addEvent(FastCalculatorBlocEvent.initFailed<R>(error));
    }
  }

  Stream<S> _handleInitializedEvent() async* {
    isInitializing = false;
    isInitialized = true;

    defaultCalculatorState = defaultCalculatorState.copyWith(
      isInitializing: isInitializing,
      isInitialized: isInitialized,
    ) as S;

    yield currentState.copyWith(
      isInitializing: isInitializing,
      isInitialized: isInitialized,
    ) as S;

    addEvent(FastCalculatorBlocEvent.compute<R>());
  }

  Stream<S> _handleInitializeFailedEvent() async* {
    isInitializing = false;
    isInitialized = false;

    yield currentState.copyWith(
      isInitializing: isInitializing,
      isInitialized: isInitialized,
    ) as S;
  }

  Stream<S> _handleResetEvent() async* {
    isInitialized = false;
    isInitializing = false;

    yield currentState.copyWith(
      isInitialized: isInitialized,
      isInitializing: isInitializing,
    ) as S;

    addEvent(FastCalculatorBlocEvent.init<R>());
  }

  Stream<S> _handlePatchValueEvent(
    FastCalculatorBlocEventPayload payload,
  ) async* {
    var state = await patchCalculatorState(payload.key!, payload.value);

    if (state != null) {
      await saveCalculatorState();
      yield state;
      addEvent(FastCalculatorBlocEvent.compute<R>());
    }
  }

  Stream<S> _handleComputeEvent() async* {
    yield currentState.copyWith(
      isValid: await isCalculatorStateValid(),
      isDirty: await isCalculatorStateDirty(),
      isBusy: true,
    ) as S;

    try {
      final results = await performCancellableAsyncOperation(compute());

      if (results != null) {
        addEvent(FastCalculatorBlocEvent.computed<R>(results));
      }
    } catch (error) {
      addEvent(FastCalculatorBlocEvent.computeFailed<R>(error));
    }
  }
}
