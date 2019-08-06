import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//Toast工具类
class ToastUtil {
  ToastUtil(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(0xFF9E9E9E),
        textColor: Color(0xFFFFFFFF)
    );
  }
}