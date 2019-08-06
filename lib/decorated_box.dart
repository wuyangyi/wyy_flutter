import 'package:flutter/material.dart';
import 'dart:math' as math;

/**
 * 使用Transform变换时，无论子控件如何变换，容器（layout）的大小是确定的，而子控件只在绘制层改变
 *
 * 而RotatedBox与Transform相似，但RotatedBox会影响widget的位置和大小
 */
class DecBoxApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("装饰容器"),
      ),
      body: Column(
        children: <Widget>[
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF5479FF), Color(0xFF9A84FF)]), //渐变色
                borderRadius: BorderRadius.circular(5.0), //圆角
                boxShadow: [  //阴影
                  BoxShadow(
                    color: Colors.black45, //阴影颜色
                    offset: Offset(2.0, 2.0),  //外扩
                    blurRadius: 5.0,
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  "精选内推",
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
          //旋转
          Container(
            color: Colors.black,
            margin: const EdgeInsets.all(30.0),
            child: new Transform(
              transform: new Matrix4.skewY(0.3), //沿Y轴倾倒0.3弧度
              alignment: Alignment.topRight,
              child: new Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.deepOrange,
                child: Text(
                  "Transform变换",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          //平移
          DecoratedBox(
            decoration: BoxDecoration(color: Color(0xFF777EFF)),
            child: Transform.translate(
              //默认左上角为原点，这里子控件向左50像素，向上10像素
              offset: Offset(-50.0, -10.0), //平移
              child: Text(
                "平移效果",
              ),
            ),
          ),
          //旋转
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF777EFF),
            ),
            child: Transform.rotate(
              angle: math.pi/2, //旋转90度
              child: Text(
                "子控件旋转",
              ),
            ),
          ),
          //放缩
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFF777EFF),
                ),
              child: Transform.scale(
                scale: 2.0, //放大2倍
                child: Text("放缩"),
              ),
            ),
          ),

          /**
           * 容器Container
           * 它是DecoratedBox、ConstrainedBox、Transform、Padding、Align等widget的一个组合widget。
           * 所以我们只需通过一个Container可以实现同时需要装饰、变换、限制的场景
           */
          Container(
            margin: const EdgeInsets.only(top: 50.0, left: 120.0),
            constraints: BoxConstraints.tightFor(width: 200.0, height: 150.0), //卡片的大小
            decoration: BoxDecoration( //背景装饰
              gradient: RadialGradient(
                colors: [Color(0xFF9A84FF), Color(0xFFA0AAFC)], //颜色渐变
                center: Alignment.topLeft,
                radius: 0.98,
              ),
              boxShadow: [
                BoxShadow( //外阴影
                  color: Colors.black45,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 5.0,
                )
              ],
            ),
            transform: Matrix4.rotationZ(0.2), //卡片倾斜变换
            alignment: Alignment.center, //卡片内子控件居中
            child: Text(
              "容器Container",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}