import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:tbloc_dart/tbloc_dart.dart';

class FastCalculatorBlocEvent extends BlocEvent<FastCalculatorBlocEventType,
    FastCalculatorBlocEventPayload> {
  FastCalculatorBlocEvent({
    required FastCalculatorBlocEventType type,
    FastCalculatorBlocEventPayload? payload,
  }) : super(type: type, payload: payload);

  FastCalculatorBlocEvent.init()
      : super(type: FastCalculatorBlocEventType.init);

  FastCalculatorBlocEvent.initialized()
      : super(type: FastCalculatorBlocEventType.initialized);

  FastCalculatorBlocEvent.initFailed()
      : super(type: FastCalculatorBlocEventType.initFailed);

  FastCalculatorBlocEvent.patchValue({
    required String key,
    dynamic value,
  }) : super(
          type: FastCalculatorBlocEventType.patchValue,
          payload: FastCalculatorBlocEventPayload(key: key, value: value),
        );

  FastCalculatorBlocEvent.compute()
      : super(type: FastCalculatorBlocEventType.compute);

  FastCalculatorBlocEvent.computed(FastCalculatorResults results)
      : super(
          type: FastCalculatorBlocEventType.computed,
          payload: FastCalculatorBlocEventPayload(results: results),
        );

  FastCalculatorBlocEvent.computeFailed(dynamic error)
      : super(
          type: FastCalculatorBlocEventType.computeFailed,
          payload: FastCalculatorBlocEventPayload(error: error),
        );

  FastCalculatorBlocEvent.clear()
      : super(type: FastCalculatorBlocEventType.clear);

  FastCalculatorBlocEvent.share()
      : super(type: FastCalculatorBlocEventType.share);

  FastCalculatorBlocEvent.save()
      : super(type: FastCalculatorBlocEventType.save);

  FastCalculatorBlocEvent.advancedMode()
      : super(type: FastCalculatorBlocEventType.advancedMode);

  FastCalculatorBlocEvent.asyncOperation()
      : super(type: FastCalculatorBlocEventType.asyncOperation);

  FastCalculatorBlocEvent.asyncOperationDone()
      : super(type: FastCalculatorBlocEventType.asyncOperationDone);

  FastCalculatorBlocEvent.asyncOperationFailed()
      : super(type: FastCalculatorBlocEventType.asyncOperationFailed);
}
