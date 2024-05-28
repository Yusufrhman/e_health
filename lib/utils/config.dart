import 'package:flutter/material.dart';

class Config {
  static MediaQueryData? mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;

  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData!.size.width;
    screenHeight = mediaQueryData!.size.height;
  }

  static get widthSize {
    return screenWidth;
  }

  static get heightSize {
    return screenHeight;
  }

  static const spaceSmall = SizedBox(
    height: 12,
  );
  static const spaceMedium = SizedBox(
    height: 24,
  );
  static const spaceBig = SizedBox(
    height: 36,
  );
  static const spaceHorizontalSmall = SizedBox(
    width: 6,
  );
  static const spaceHorizontalMedium = SizedBox(
    width: 12,
  );
  static const spaceHorizontalBig = SizedBox(
    width: 24,
  );

  static var outlinedBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Config.primaryColor),
    borderRadius: BorderRadius.circular(12),
  );

  static var focusBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Config.primaryColor),
    borderRadius: BorderRadius.circular(12),
  );
  static const errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(
      color: Colors.red,
    ),
  );

  static const primaryColor = Color.fromRGBO(22, 160, 133, 1);
  static const backgroundColor = Color.fromRGBO(241, 245, 245, 1);
}
