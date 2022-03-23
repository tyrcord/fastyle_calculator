import 'package:flutter/material.dart';

import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:fastyle_dart/fastyle_dart.dart';

class FastCalculatorPageLayout<B extends FastCalculatorBloc,
    R extends FastCalculatorResults> extends StatelessWidget {
  final List<Widget>? calculatorActions;
  final List<Widget>? resultsActions;
  final WidgetBuilder? dividerBuilder;
  final WidgetBuilder? footerBuilder;
  final WidgetBuilder resultsBuilder;
  final WidgetBuilder fieldsBuilder;
  final String? resultsTitleText;
  final String? fieldsTitleText;
  final String? pageTitleText;
  final bool showRefreshIcon;
  final bool requestFullApp;
  final Widget? refreshIcon;
  final bool showClearIcon;
  final Widget? backButton;
  final Widget? shareIcon;
  final Widget? clearIcon;
  final B calculatorBloc;
  final Widget? leading;

  FastCalculatorPageLayout({
    Key? key,
    required this.calculatorBloc,
    required this.resultsBuilder,
    required this.fieldsBuilder,
    this.requestFullApp = false,
    this.showRefreshIcon = true,
    this.showClearIcon = true,
    this.calculatorActions,
    this.resultsTitleText,
    this.fieldsTitleText,
    this.resultsActions,
    this.dividerBuilder,
    this.footerBuilder,
    this.pageTitleText,
    this.refreshIcon,
    this.backButton,
    this.shareIcon,
    this.clearIcon,
    this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      isTitlePositionBelowAppBar: !requestFullApp,
      titleText: pageTitleText,
      backButton: backButton,
      actions: _buildActions(),
      leading: leading,
      isViewScrollable: true,
      child: Column(
        children: [
          _buildFormFields(context),
          _buildDivider(),
          _buildResults(context),
          if (footerBuilder != null) Builder(builder: footerBuilder!),
        ],
      ),
    );
  }

  List<Widget> _buildActions() {
    return [
      FastCalculatorShareAction<B, R>(
        calculatorBloc: calculatorBloc,
        icon: shareIcon,
      ),
    ];
  }

  Widget _buildFormFields(BuildContext context) {
    final primaryColor = ThemeHelper.colors.getPrimaryColor(context);

    return FastCard(
      titleText: fieldsTitleText ?? kFastCalculatorTitle,
      titleTextColor: primaryColor,
      headerActions: <Widget>[
        ...?calculatorActions,
        if (showClearIcon)
          FastCalculatorClearAction<B, R>(
            calculatorBloc: calculatorBloc,
            icon: clearIcon,
          )
      ],
      child: Builder(builder: fieldsBuilder),
    );
  }

  Widget _buildDivider() {
    return dividerBuilder != null
        ? Builder(builder: dividerBuilder!)
        : kFastSizedBox16;
  }

  Widget _buildResults(BuildContext context) {
    final primaryColor = ThemeHelper.colors.getPrimaryColor(context);

    return FastCard(
      titleText: resultsTitleText ?? kFastCalculatorResultsTitle,
      titleTextColor: primaryColor,
      headerActions: <Widget>[
        ...?resultsActions,
        if (showRefreshIcon)
          FastCalculatorRefreshAction<B, R>(
            calculatorBloc: calculatorBloc,
            icon: refreshIcon,
          ),
      ],
      child: Builder(builder: resultsBuilder),
    );
  }
}
