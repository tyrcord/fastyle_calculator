import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:tstore_dart/tstore_dart.dart';

abstract class FastCalculatorDocument extends TDocument {
  const FastCalculatorDocument() : super();

  FastCalculatorFields toFields();
}
