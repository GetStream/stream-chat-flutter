import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/MainAppColorHelper.dart';

class StreamUiUtils {


  static BoxDecoration getMsgBubbleDecor(bool reverse, bool isCall) {
    if (!isCall) {
      return null;
    }
    if (!reverse) {
      return BoxDecoration(
          border: Border(
              right: BorderSide(color: MainAppColorHelper.black(), width: 5)));
    } else {
      return BoxDecoration(
          border: Border(
              left: BorderSide(color: MainAppColorHelper.black(), width: 5)));
    }
  }

  static Decoration cardShadow = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(
      Radius.circular(8.0),
    ),
    boxShadow: <BoxShadow>[
      BoxShadow(
          color: Colors.black12,
          blurRadius: 16.0,
          offset: Offset(0.0, 14.0),
          spreadRadius: -9),
    ],
  );
}
