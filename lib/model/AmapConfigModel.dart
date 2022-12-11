import 'package:flutter/material.dart';

class AmapConfigModel {
  String androidKey;
  String iosKey;
  String webKey;
  Color? selectColor;
  bool isSnapshot;

  AmapConfigModel({
    this.androidKey = "",
    this.iosKey = "",
    this.webKey = "",
    this.selectColor,
    this.isSnapshot = false,
  });
}