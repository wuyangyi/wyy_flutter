import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class GestureRecognizeApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new GestureRecognizeState();
  }

}

class GestureRecognizeState extends State<GestureRecognizeApp> {
  TapGestureRecognizer _tapGestureRecognizer = new TapGestureRecognizer();
  bool _toggle = false; //变色开关

  @override
  void dispose() {
    //用到GestureRecognizer的话一定要调用其dispose方法释放资源
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TapGestureRecognizer"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          //文字点击变色
          Center(
            child: Text.rich(TextSpan(
              children: [
                TextSpan(text: "世界你好，"),
                TextSpan(
                  text: "点击变色",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: _toggle ? Colors.blue : Colors.red,
                  ),
                  recognizer: _tapGestureRecognizer
                  ..onTap = () {
                    setState(() {
                      _toggle = !_toggle;
                    });
                  }
                ),
                TextSpan(text: "世界你好，"),
              ],
            )),
          ),
        ],
      ),
    );
  }

}