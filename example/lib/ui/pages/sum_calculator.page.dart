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
      dividerBuilder: (context) => _buildExtra(context, 'Divider'),
      footerBuilder: (context) => _buildExtra(context, 'Footer'),
      fieldsBuilder: (context) {
        return Column(
          children: [
            _buildNumberAField(),
            _buildNumberBField(),
            FastExpansionPanel(
              titleText: 'Advanced',
              bodyBuilder: (BuildContext context) {
                return Column(children: [
                  _buildAsyncField(context),
                ]);
              },
            ),
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
            _patchValue('numberA', value);
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
            _patchValue('numberB', value);
          },
          valueText: currentValue!,
        );
      },
    );
  }

  void _patchValue(String key, dynamic value) {
    _bloc.addEvent(FastCalculatorBlocEvent.patchValue(
      key: key,
      value: value,
    ));
  }

  Widget _buildNumberField({
    required String labelText,
    required ValueChanged<String> onValueChanged,
    required String valueText,
    Widget? suffixIcon,
    bool isEnabled = true,
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
      isEnabled: isEnabled,
      suffixIcon: suffixIcon,
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

  Widget _buildExtra(BuildContext context, String labelText) {
    return Container(
      color: ThemeHelper.colors.getBlueGrayColor(context),
      margin: const EdgeInsets.symmetric(vertical: 16),
      height: 50,
      child: Center(
        child: FastBody(
          textColor: ThemeHelper.colors.getWhiteColor(context),
          text: labelText,
        ),
      ),
    );
  }

  Widget _buildAsyncField(BuildContext context) {
    return BlocBuilderWidget<SumCalculatorBloState>(
      bloc: _bloc,
      buildWhen: (previous, next) {
        var oldExtras = (previous.extras as SumCalculatorBlocStateExtras);
        var newExtras = (next.extras as SumCalculatorBlocStateExtras);

        return oldExtras.isFetchingAsyncValue !=
                newExtras.isFetchingAsyncValue ||
            oldExtras.asyncValue != newExtras.asyncValue;
      },
      builder: (_, SumCalculatorBloState state) {
        var extras = (state.extras as SumCalculatorBlocStateExtras);

        return _buildNumberField(
          labelText: 'Async value',
          onValueChanged: (_) {},
          valueText: extras.asyncValue,
          isEnabled: !extras.isFetchingAsyncValue,
          suffixIcon: FastAnimatedRotationIconButton(
            isEnabled: !extras.isFetchingAsyncValue,
            rotate: extras.isFetchingAsyncValue,
            onTap: () {
              _bloc.addEvent(FastCalculatorBlocEvent.custom('async'));
            },
          ),
        );
      },
    );
  }
}
