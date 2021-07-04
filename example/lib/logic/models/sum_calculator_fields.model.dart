import 'package:fastyle_calculator/fastyle_calculator.dart';

class SumCalculatorFields extends FastCalculatorFields {
  final String numberA;
  final String numberB;

  const SumCalculatorFields({
    this.numberA = '',
    this.numberB = '',
  });

  @override
  SumCalculatorFields clone() {
    return SumCalculatorFields(numberA: numberA, numberB: numberB);
  }

  @override
  SumCalculatorFields copyWith({
    String? numberA,
    String? numberB,
  }) {
    return SumCalculatorFields(
      numberA: numberA ?? this.numberA,
      numberB: numberB ?? this.numberB,
    );
  }

  @override
  SumCalculatorFields merge(covariant SumCalculatorFields model) {
    return model.clone();
  }

  @override
  List<Object?> get props => [numberA, numberB];
}
