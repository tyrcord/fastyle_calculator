import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:flutter/material.dart';

abstract class HydratedFastCalculatorBloc<
    E extends FastCalculatorBlocEvent,
    S extends FastCalculatorBlocState,
    D extends FastCalculatorDocument,
    R extends FastCalculatorResults> extends FastCalculatorBloc<E, S, R> {
  @protected
  final FastCalculatorDataProvider<D> dataProvider;

  @protected
  late D defaultDocument;

  @protected
  late D document;

  HydratedFastCalculatorBloc({
    required S initialState,
    required this.dataProvider,
  }) : super(initialState: initialState);

  @protected
  Future<D> retrieveDefaultCalculatorDocument();

  @protected
  Future<D?> patchCalculatorDocument(String key, dynamic value);

  @protected
  Future<bool> canSaveUserEntry() async => true;

  @override
  void close() {
    super.close();
    dataProvider.disconnect();
  }

  @override
  @mustCallSuper
  Future<void> initialize() async {
    await dataProvider.connect();
    defaultDocument = await retrieveDefaultCalculatorDocument();
    document = await retrieveCalculatorDocument();
  }

  @override
  @mustCallSuper
  Future<S> initializeCalculatorState() async {
    return initialState!.copyWith(fields: document.toFields()) as S;
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
    if (await canSaveUserEntry()) {
      final savedDocument = await dataProvider.retrieveCalculatorDocument();

      return defaultDocument.merge(savedDocument) as D;
    }

    return defaultDocument;
  }

  @protected
  Future<void> persistCalculatorDocument() async {
    if (await canSaveUserEntry()) {
      return dataProvider.persistCalculatorDocument(document);
    }
  }

  @protected
  Future<void> clearCalculatorDocument() async {
    if (await canSaveUserEntry()) {
      return dataProvider.clearCalculatorDocument();
    }
  }

  @override
  Stream<S> mapEventToState(FastCalculatorBlocEvent event) async* {
    final payload = event.payload;
    final eventType = event.type;
    final saveUserEntry = await canSaveUserEntry();

    if (saveUserEntry && eventType == FastCalculatorBlocEventType.patchValue) {
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
