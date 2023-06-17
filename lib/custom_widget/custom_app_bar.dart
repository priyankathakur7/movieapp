import 'package:flutter/material.dart';

AppBar customAppBar({String ? title,
PreferredSizeWidget? bottomWidget}) {
  return AppBar(
      title: Text("$title"),
    centerTitle : true,
    bottom: bottomWidget,
  );
}