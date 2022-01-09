import 'package:flutter/material.dart';

enum DrawerIndex {
  // ignore: constant_identifier_names
  HOME,
  // ignore: constant_identifier_names
  Profile,
  // ignore: constant_identifier_names
  Message,
  // ignore: constant_identifier_names
  Notification,
  // ignore: constant_identifier_names
  About,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    required this.icon,
    required this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool? isAssetsImage;
  String imageName;
  DrawerIndex index;
}
