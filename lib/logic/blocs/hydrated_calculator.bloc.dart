import 'package:flutter/material.dart';

import 'package:fastyle_calculator/fastyle_calculator.dart';

abstract class HydratedFastCalculatorBloc<
    E extends FastCalculatorBlocEvent,
    S extends FastCalculatorBlocState,
    D extends FastCalculatorDocument,
    R extends FastCalculatorResults> extends FastCalculatorBloc<E, S, R> {
  @protected
  final FastCalculatorDataProvider<D> dataProvider;
  @protected
  final bool saveEntry;
  @protected
  late D document;

  HydratedFastCalculatorBloc({
    required S initialState,
    required this.dataProvider,
    this.saveEntry = false,
  }) : super(initialState: initialState);

  @protected
  Future<D> retrieveDefaultCalculatorDocument();

  @protected
  Future<D?> patchCalculatorDocument(String key, dynamic value);

  @override
  void close() {
    super.close();
    dataProvider.disconnect();
  }

  @override
  @mustCallSuper
  Future<S> initializeCalculatorState() async {
    await dataProvider.connect();
    document = await retrieveCalculatorDocument();

    final fields = defaultCalculatorState.fields.merge(
      document.toFields(),
    ) as FastCalculatorFields?;

    return defaultCalculatorState.copyWith(fields: fields) as S;
  }

  @override
  @mustCallSuper
  Future<bool> saveCalculatorState() async {
    await persistCalculatorDocument();

    return super.saveCalculatorState();
  }

  @override
  @mustCallSuper
  Future<S> clearCalculatorState() async {
    await clearCalculatorDocument();
    document = await retrieveCalculatorDocument();

    return super.clearCalculatorState();
  }

  @protected
  Future<D> retrieveCalculatorDocument() async {
    D? document;

    if (saveEntry) {
      document = await dataProvider.retrieveCalculatorDocument();
    }

    if (document == null) {
      return retrieveDefaultCalculatorDocument();
    }

    return document;
  }

  @protected
  Future<void> persistCalculatorDocument() async {
    if (saveEntry) {
      return dataProvider.persistCalculatorDocument(document);
    }
  }

  @protected
  Future<void> clearCalculatorDocument() async {
    if (saveEntry) {
      return dataProvider.clearCalculatorDocument();
    }
  }

  @override
  Stream<S> mapEventToState(FastCalculatorBlocEvent event) async* {
    final payload = event.payload;
    final eventType = event.type;

    if (eventType == FastCalculatorBlocEventType.patchValue) {
      var newDocument = await patchCalculatorDocument(
        payload!.key!,
        payload.value!,
      );

      if (newDocument != null) {
        document = newDocument;
      }
    }

    yield* super.mapEventToState(event);
  }
}
