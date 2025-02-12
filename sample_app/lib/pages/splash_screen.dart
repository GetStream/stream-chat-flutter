// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

mixin SplashScreenStateMixin<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 1000,
    ),
  );

  late final _scaleAnimationController = AnimationController(
    vsync: this,
    value: 0,
    duration: const Duration(
      milliseconds: 500,
    ),
  );

  late final _circleAnimation = Tween<double>(
    begin: 0,
    end: 1000,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  ));

  late final _colorAnimation = ColorTween(
    begin: const Color(0xff005FFF),
    end: Colors.transparent,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  ));

  late final _scaleAnimation = Tween<double>(
    begin: 1,
    end: 1.5,
  ).animate(CurvedAnimation(
    parent: _scaleAnimationController,
    curve: Curves.easeInOutCubic,
  ));

  bool animationCompleted = false;

  void forwardAnimations() {
    _scaleAnimationController.forward().whenComplete(() {
      _animationController.forward();
    });
  }

  void _onAnimationComplete(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        animationCompleted = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController.addStatusListener(_onAnimationComplete);
  }

  @override
  void dispose() {
    _animationController.removeStatusListener(_onAnimationComplete);
    _animationController.dispose();
    _scaleAnimationController.dispose();
    super.dispose();
  }

  Widget buildAnimation() => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) =>
                Transform.scale(scale: _scaleAnimation.value, child: child),
            child: AnimatedBuilder(
              animation: _colorAnimation,
              builder: (context, child) {
                return DecoratedBox(
                  decoration: BoxDecoration(color: _colorAnimation.value),
                  child: Center(
                    child: !_animationController.isAnimating
                        ? child
                        : const SizedBox(),
                  ),
                );
              },
              child: RepaintBoundary(
                child: Lottie.asset(
                  'assets/floating_boat.json',
                  alignment: Alignment.center,
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _circleAnimation,
            builder: (context, snapshot) {
              return Transform.scale(
                scale: _circleAnimation.value,
                child: Container(
                  width: 1,
                  height: 1,
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(1 - _animationController.value),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ],
      );
}
