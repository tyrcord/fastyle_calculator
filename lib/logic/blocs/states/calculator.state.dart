import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:tmodel_dart/tmodel_dart.dart';
import 'package:tbloc_dart/tbloc_dart.dart';

class FastCalculatorBlocState<F extends FastCalculatorFields,
    R extends FastCalculatorResults> extends BlocState {
  final TModel? extras;
  final R results;
  final F fields;

  final bool isValid;
  final bool isDirty;
  final bool isBusy;

  const FastCalculatorBlocState({
    required this.results,
    required this.fields,
    bool isInitializing = false,
    bool isInitialized = false,
    this.isValid = false,
    this.isDirty = false,
    this.isBusy = false,
    this.extras,
  }) : super(
          isInitializing: isInitializing,
          isInitialized: isInitialized,
        );

  @override
  FastCalculatorBlocState<F, R> clone() {
    return FastCalculatorBlocState<F, R>(
      extras: extras,
      isInitializing: isInitializing,
      isInitialized: isInitialized,
      results: results.clone() as R,
      fields: fields.clone() as F,
      isValid: isValid,
      isDirty: isDirty,
      isBusy: isBusy,
    );
  }

  @override
  FastCalculatorBlocState<F, R> copyWith({
    TModel? extras,
    bool? isInitializing,
    bool? isInitialized,
    R? results,
    F? fields,
    bool? isValid,
    bool? isDirty,
    bool? isBusy,
  }) {
    return FastCalculatorBlocState<F, R>(
      extras: extras ?? this.extras,
      isInitializing: isInitializing ?? this.isInitializing,
      isInitialized: isInitialized ?? this.isInitialized,
      results: results ?? this.results,
      fields: fields ?? this.fields,
      isValid: isValid ?? this.isValid,
      isDirty: isDirty ?? this.isDirty,
      isBusy: isBusy ?? this.isBusy,
    );
  }

  @override
  FastCalculatorBlocState<F, R> merge(
    covariant FastCalculatorBlocState<F, R> state,
  ) {
    return FastCalculatorBlocState<F, R>(
      extras: state.extras != null ? extras?.merge(state.extras!) : null,
      isInitializing: state.isInitializing,
      isInitialized: state.isInitialized,
      results: results.merge(state.results) as R,
      fields: fields.merge(state.fields) as F,
      isValid: state.isValid,
      isDirty: state.isDirty,
      isBusy: state.isBusy,
    );
  }

  @override
  List<Object?> get props => [
        extras,
        isInitializing,
        isInitialized,
        results,
        fields,
        isValid,
        isDirty,
        isBusy,
      ];
}
