import 'package:flutter/material.dart';

import 'package:fastyle_dart/fastyle_dart.dart';

// Should be moved to fastyle
class FastAnimatedRefreshIconButton extends StatefulWidget {
  final AnimationController? animationController;
  final EdgeInsetsGeometry padding;
  final Alignment? iconAlignment;
  final bool shouldTrottleTime;
  final VoidCallback onTap;
  final Color? iconColor;
  final double iconSize;
  final bool isEnabled;
  final Widget? icon;
  final bool rotate;

  const FastAnimatedRefreshIconButton({
    Key? key,
    required this.onTap,
    this.iconSize = kFastIconSizeSmall,
    this.padding = kFastEdgeInsets8,
    this.shouldTrottleTime = false,
    this.isEnabled = true,
    this.rotate = false,
    this.animationController,
    this.iconAlignment,
    this.iconColor,
    this.icon,
  }) : super(key: key);

  @override
  _FastAnimatedRefreshIconButtonState createState() =>
      _FastAnimatedRefreshIconButtonState();
}

class _FastAnimatedRefreshIconButtonState
    extends State<FastAnimatedRefreshIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.animationController ??
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _rotateIcon(widget.rotate);
  }

  @override
  void dispose() {
    super.dispose();

    if (widget.animationController != _controller) {
      _controller.dispose();
    }
  }

  @override
  void didUpdateWidget(covariant FastAnimatedRefreshIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.rotate != widget.rotate) {
      _rotateIcon(widget.rotate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FastIconButton(
      shouldTrottleTime: widget.shouldTrottleTime,
      iconColor: widget.iconColor,
      isEnabled: widget.isEnabled,
      iconSize: widget.iconSize,
      padding: widget.padding,
      onTap: widget.onTap,
      icon: Align(
        alignment: widget.iconAlignment ?? Alignment.center,
        child: RotationTransition(
          turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
          child: widget.icon ?? const Icon(Icons.sync),
        ),
      ),
    );
  }

  void _rotateIcon(bool animate) {
    if (animate) {
      _controller.repeat();
    } else {
      _controller.reset();
    }
  }
}
