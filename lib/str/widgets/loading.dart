import 'dart:math';

import 'package:flutter/material.dart';

enum DotType { square, circle, diamond, icon }

class SMELoading extends StatefulWidget {
  const SMELoading({
    Key? key,
    required this.dotOneColor,
    required this.dotTwoColor,
    required this.dotThreeColor,
    this.duration = const Duration(milliseconds: 1000),
    this.dotType = DotType.circle,
    this.dotIcon = const Icon(Icons.blur_on),
  }) : super(key: key);

  final Color dotOneColor;
  final Color dotTwoColor;
  final Color dotThreeColor;
  final Duration duration;
  final DotType dotType;
  final Icon dotIcon;

  @override
  State<SMELoading> createState() => _SMELoadingState();
}

class _SMELoadingState extends State<SMELoading>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation_1;
  late Animation<double> animation_2;
  late Animation<double> animation_3;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: widget.duration, vsync: this);

    animation_1 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.80, curve: Curves.ease),
      ),
    );

    animation_2 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.1, 0.9, curve: Curves.ease),
      ),
    );

    animation_3 = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 1.0, curve: Curves.ease),
      ),
    );

    controller.addListener(() {
      setState(() {
        //print(animation_1.value);
      });
    });

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.translate(
          offset: Offset(
            0.0,
            -30 *
                (animation_1.value <= 0.50
                    ? animation_1.value
                    : 1.0 - animation_1.value),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Dot(
              radius: 10.0,
              color: widget.dotOneColor,
              type: widget.dotType,
              icon: widget.dotIcon,
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(
            0.0,
            -30 *
                (animation_2.value <= 0.50
                    ? animation_2.value
                    : 1.0 - animation_2.value),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Dot(
              radius: 10.0,
              color: widget.dotTwoColor,
              type: widget.dotType,
              icon: widget.dotIcon,
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(
            0.0,
            -30 *
                (animation_3.value <= 0.50
                    ? animation_3.value
                    : 1.0 - animation_3.value),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Dot(
              radius: 10.0,
              color: widget.dotThreeColor,
              type: widget.dotType,
              icon: widget.dotIcon,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class Dot extends StatelessWidget {
  const Dot({
    Key? key,
    this.radius,
    this.color,
    this.type,
    this.icon,
  }) : super(key: key);

  final double? radius;
  final Color? color;
  final DotType? type;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: type == DotType.icon
          ? Icon(
              icon!.icon,
              color: color,
              size: 1.3 * radius!,
            )
          : Transform.rotate(
              angle: type == DotType.diamond ? pi / 4 : 0.0,
              child: Container(
                width: radius,
                height: radius,
                decoration: BoxDecoration(
                  color: color,
                  shape: type == DotType.circle
                      ? BoxShape.circle
                      : BoxShape.rectangle,
                ),
              ),
            ),
    );
  }
}
