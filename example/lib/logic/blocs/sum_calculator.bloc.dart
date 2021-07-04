import 'package:decimal/decimal.dart';

import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:fastyle_calculator_example/logic/logic.dart';

class SumCalculatorBloc extends HydratedFastCalculatorBloc<
    FastCalculatorBlocEvent, SumCalculatorBloState, SumCalculatorDocument> {
  SumCalculatorBloc({
    SumCalculatorBloState initialState = const FastCalculatorBlocState<
        SumCalculatorFields, SumCalculatorResults>(
      fields: SumCalculatorFields(),
      results: SumCalculatorResults(),
    ),
  }) : super(
          initialState: initialState,
          dataProvider: SumCalculatorDataProvider(),
          saveEntry: true,
        );

  @override
  Future<SumCalculatorDocument> retrieveDefaultCalculatorDocument() async {
    return SumCalculatorDocument();
  }

  @override
  Future<SumCalculatorResults> compute() async {
    if (await isCalculatorStateValid()) {
      final fields = currentState.fields;
      final dNumberA = Decimal.tryParse(fields.numberA);
      final dNumberB = Decimal.tryParse(fields.numberB);

      await Future.delayed(Duration(seconds: 2));

      if (dNumberA != null &&
          dNumberB != null &&
          dNumberA > Decimal.zero &&
          dNumberB > Decimal.zero) {
        return SumCalculatorResults(
          sum: (dNumberA + dNumberB).toStringAsFixed(2),
        );
      }
    }

    return SumCalculatorResults();
  }

  @override
  Future<SumCalculatorBloState?> patchCalculatorState(
    String key,
    dynamic value,
  ) async {
    await patchCalculatorDocument(key, value);

    if (key == 'numberA') {
      final fields = currentState.fields.copyWith(
        numberA: value as String,
      );

      return currentState.copyWith(fields: fields);
    } else if (key == 'numberB') {
      final fields = currentState.fields.copyWith(
        numberB: value as String,
      );

      return currentState.copyWith(fields: fields);
    }
  }

  @override
  Future<SumCalculatorDocument?> patchCalculatorDocument(
    String key,
    dynamic value,
  ) async {
    if (key == 'numberA') {
      return document.copyWith(numberA: value as String);
    } else if (key == 'numberB') {
      return document.copyWith(numberB: value as String);
    }
  }

  @override
  Future<bool> isCalculatorStateValid() async {
    final fields = currentState.fields;
    final numberA = fields.numberA;
    final numberB = fields.numberB;

    return isDecimal(numberA) && isDecimal(numberB);
  }

  @override
  Future<void> shareCalculatorState() async {
    log('Number A: ${currentState.fields.numberA}');
    log('Number B: ${currentState.fields.numberB}');
    log('Sum: ${currentState.results.sum}');
  }
}
