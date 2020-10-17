import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AniProps { opacity, translateY, translateX }

class FadeIn extends StatelessWidget {
  final double delay;
  final Widget child;
  final Curve curve = Curves.easeOutCubic;

  FadeIn(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AniProps>()
      ..add(AniProps.opacity, 0.0.tweenTo(1.0), 500.milliseconds, curve)
      ..add(AniProps.translateY, 30.0.tweenTo(0.0), 500.milliseconds, curve);

    return CustomAnimation(
        delay: Duration(milliseconds: (400 * delay).round()),
        duration: tween.duration,
        tween: tween,
        child: child,
        builder: (context, child, value) {
          return Opacity(
            opacity: value.get(AniProps.opacity),
            child: Transform.translate(
                offset: Offset(
                  0,
                  value.get(AniProps.translateY),
                ),
                child: child),
          );
        });
  }
}

class FadeInLTR extends StatelessWidget {
  final double delay;
  final Widget child;
  final Curve curve = Curves.easeOutCubic;

  FadeInLTR(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AniProps>()
      ..add(AniProps.opacity, 0.0.tweenTo(1.0), 500.milliseconds, curve)
      ..add(AniProps.translateX, 30.0.tweenTo(0.0), 500.milliseconds, curve);

    return CustomAnimation(
        delay: Duration(milliseconds: (300 * delay).round()),
        duration: tween.duration,
        tween: tween,
        child: child,
        builder: (context, child, value) {
          return Opacity(
            opacity: value.get(AniProps.opacity),
            child: Transform.translate(
                offset: Offset(value.get(AniProps.translateX), 0),
                child: child),
          );
        });
  }
}
