import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle display4(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontFamily: 'Style1',
        );
  }

  static TextStyle display3(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontFamily: 'Style1',
        );
  }

  static TextStyle display2(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontFamily: 'Style1',
        );
  }

  static TextStyle display1(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontFamily: 'Style1',
        );
  }

  static TextStyle display0(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontFamily: 'Style2',
        );
  }

  static TextStyle display5(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontFamily: 'Style3',
        );
  }

  static TextStyle headline(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontFamily: 'Style1',
        );
  }

  static TextStyle title(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontFamily: 'Style1',
        );
  }

  static TextStyle medium(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontSize: 18,
          fontFamily: 'Style1',
        );
  }

  static TextStyle subhead(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontFamily: 'Style1',
          fontSize: 13,
        );
  }

  static TextStyle body2(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontFamily: 'Style1',
        );
  }

  static TextStyle body1(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontFamily: 'Style1',
        );
  }

  static TextStyle caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          fontFamily: 'Style1',
        );
  }

  static TextStyle button(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(
          fontFamily: 'Style1',
        );
  }

  static TextStyle subtitle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall!.copyWith(
          fontFamily: 'Style1',
        );
  }

  static TextStyle overline(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          fontFamily: 'Style1',
        );
  }
}
