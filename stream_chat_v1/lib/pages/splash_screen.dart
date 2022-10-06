import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

mixin SplashScreenStateMixin<T extends StatefulWidget> on State<T>
    implements TickerProvider {
  late Animation<double> animation, scaleAnimation;
  late AnimationController _animationController, _scaleAnimationController;
  late Animation<Color?> colorAnimation;
  bool animationCompleted = false;

  void _createAnimations() {
    _scaleAnimationController = AnimationController(
      vsync: this,
      value: 0,
      duration: Duration(
        milliseconds: 500,
      ),
    );
    scaleAnimation = Tween(
      begin: 1.0,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.easeInOutBack,
    ));

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 1000,
      ),
    );
    animation = Tween(
      begin: 0.0,
      end: 1000.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    colorAnimation = ColorTween(
      begin: Color(0xff005FFF),
      end: Color(0xff005FFF),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    colorAnimation = ColorTween(
      begin: Color(0xff005FFF),
      end: Colors.transparent,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void forwardAnimations() {
    _scaleAnimationController.forward().whenComplete(() {
      _animationController.forward();
    });
  }

  Widget buildAnimation() => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: scaleAnimation,
            builder: (context, _) {
              return Transform.scale(
                scale: scaleAnimation.value,
                child: AnimatedBuilder(
                    animation: colorAnimation,
                    builder: (context, snapshot) {
                      return Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints.expand(),
                        color: colorAnimation.value,
                        child: !_animationController.isAnimating
                            ? Lottie.asset(
                                'assets/floating_boat.json',
                                alignment: Alignment.center,
                              )
                            : SizedBox(),
                      );
                    }),
              );
            },
          ),
          AnimatedBuilder(
            animation: animation,
            builder: (context, snapshot) {
              return Transform.scale(
                scale: animation.value,
                child: Container(
                  width: 1.0,
                  height: 1.0,
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

  @override
  void initState() {
    _createAnimations();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          animationCompleted = true;
        });
      }
    });
    super.initState();
  }
}
