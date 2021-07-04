import 'package:flutter/material.dart';

import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:fastyle_calculator_example/logic/logic.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:tbloc_dart/tbloc_dart.dart';

class SumCalculatorPage extends StatefulWidget {
  @override
  _SumCalculatorPageState createState() => _SumCalculatorPageState();
}

class _SumCalculatorPageState extends State<SumCalculatorPage> {
  final _bloc = SumCalculatorBloc();

  @override
  void initState() {
    super.initState();
    _bloc.addEvent(FastCalculatorBlocEvent.init());
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return FastCalculatorPageLayout(
      calculatorBloc: _bloc,
      pageTitleText: 'Sum Calculator',
      requestFullApp: true,
      fieldsBuilder: (context) {
        return Column(
          children: [
            _buildNumberAField(),
            _buildNumberBField(),
          ],
        );
      },
      resultsBuilder: (context) {
        return Column(
          children: [_buildResults()],
        );
      },
    );
  }

  Widget _buildNumberAField() {
    String? currentValue;

    return BlocBuilderWidget<SumCalculatorBloState>(
      bloc: _bloc,
      buildWhen: (previous, next) {
        var previousValue = previous.fields.numberA;
        var nextValue = next.fields.numberA;

        return previousValue != nextValue && currentValue != nextValue;
      },
      builder: (_, SumCalculatorBloState state) {
        currentValue = state.fields.numberA;

        return _buildNumberField(
          labelText: 'Number A',
          onValueChanged: (String value) {
            currentValue = value;

            _bloc.addEvent(FastCalculatorBlocEvent.patchValue(
              key: 'numberA',
              value: value,
            ));
          },
          valueText: currentValue!,
        );
      },
    );
  }

  Widget _buildNumberBField() {
    String? currentValue;

    return BlocBuilderWidget<SumCalculatorBloState>(
      bloc: _bloc,
      buildWhen: (previous, next) {
        var previousValue = previous.fields.numberB;
        var nextValue = next.fields.numberB;

        return previousValue != nextValue && currentValue != nextValue;
      },
      builder: (_, SumCalculatorBloState state) {
        currentValue = state.fields.numberB;

        return _buildNumberField(
          labelText: 'Number B',
          onValueChanged: (String value) {
            currentValue = value;

            _bloc.addEvent(FastCalculatorBlocEvent.patchValue(
              key: 'numberB',
              value: value,
            ));
          },
          valueText: currentValue!,
        );
      },
    );
  }

  Widget _buildNumberField({
    required String labelText,
    required ValueChanged<String> onValueChanged,
    required String valueText,
  }) {
    return FastNumberField(
      onValueChanged: onValueChanged,
      transformInvalidNumber: false,
      valueText: valueText,
      shouldDebounceTime: true,
      allowAutocorrect: false,
      labelText: labelText,
      placeholderText: '0.00',
      acceptDecimal: true,
      isEnabled: true,
    );
  }

  Widget _buildResults() {
    return BlocBuilderWidget<SumCalculatorBloState>(
      bloc: _bloc,
      buildWhen: (previous, next) {
        return previous.results.sum != next.results.sum ||
            next.isBusy != previous.isBusy;
      },
      builder: (_, SumCalculatorBloState state) {
        return FastPendingReadOnlyTextField(
          labelText: 'Sum',
          valueText: state.results.sum,
          isPending: state.isBusy,
          pendingText: '0.00',
        );
      },
    );
  }
}
