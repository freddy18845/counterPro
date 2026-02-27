import "package:flutter/material.dart";

class ScreenUtil {

  static double width = 0.0;
  static double height = 0.0;

  ScreenUtil._();

  static void init({required BuildContext context}) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }
  
}
