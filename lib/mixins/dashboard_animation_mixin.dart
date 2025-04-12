import 'package:flutter/material.dart';

mixin DashboardAnimationMixin<T extends StatefulWidget> on State<T> {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this as TickerProvider,
      duration: const Duration(milliseconds: 800),
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget buildAnimatedCard({required double delay, required Widget child}) {
    final Animation<double> delayedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Interval(delay, delay + 0.4, curve: Curves.easeOut),
    );

    return AnimatedBuilder(
      animation: delayedAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - delayedAnimation.value)),
          child: Opacity(
            opacity: delayedAnimation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget buildAnimatedContent({required Widget child}) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget buildScaleAnimation({required Widget child}) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 1000),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  void resetAndForwardAnimation() {
    animationController.reset();
    animationController.forward();
  }
}
