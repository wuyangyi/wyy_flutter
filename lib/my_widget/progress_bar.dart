import 'package:flutter/material.dart';
import 'dart:math';

//进度条
class ProgressIndicator extends StatelessWidget {

  ProgressIndicator(
      this.strokeWidth,
      this.radius,
      this.strokeCapRount,
      this.value,
      this.backgroundColor,
      this.totalAngle,
      this.colors,
      this.stops
      );
  //粗细
  final double strokeWidth;

  //圆的半径
  final double radius;

  //两端是否为圆角
  final bool strokeCapRount;

  //当前进度，取值范围[0.0-1.0]
  final double value;

  //进度条背景色
  final Color backgroundColor;

  //进度条的总弧度，2*PI为整圆
  final double totalAngle;

  //渐变色数组
  final List<Color> colors;

  //渐变色的终止点，对应colors属性
  final List<double> stops;

  @override
  Widget build(BuildContext context) {
    double offset = .0;
    // 如果两端为圆角，则需要对起始位置进行调整，否则圆角部分会偏离起始位置
    // 下面调整的角度的计算公式是通过数学几何知识得出(暂时没看出来哪个几何公式，以后研究下)
    if(strokeCapRount) {
      offset = asin(strokeWidth / (radius * 2 - strokeWidth));
    }
//    var mColors = colors;
//    //为空则用主题色
//    if (mColors == null) {
//      Color color = Theme
//          .of(context)
//          .accentColor;
//      mColors = [color, color];
//    }
    return Transform.rotate( //旋转变换组件
      angle: -pi / 2.0 - offset,
      child: CustomPaint(
        size: Size.fromRadius(radius),
        painter: ProgressPainter(
          strokeWidth: strokeWidth,
          strokeCapRound: strokeCapRount,
          backgroundColor: backgroundColor,
          radius: radius,
          total: totalAngle,
          colors: colors,
          stops: stops,
          value: value,
        ),
      ),
    );
  }

}

class ProgressPainter extends CustomPainter {
  ProgressPainter({
    this.strokeWidth: 10.0,
    this.strokeCapRound: false,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.radius,
    this.total = 2 * pi,
    @required this.colors,
    this.stops,
    this.value
  });

  final double strokeWidth;
  final bool strokeCapRound;
  final double value;
  final Color backgroundColor;
  final List<Color> colors;
  final double total;
  final double radius;
  final List<double> stops;

  @override
  void paint(Canvas canvas, Size size) {
    if (radius != null) {
      size = Size.fromRadius(radius);
    }
    double mOffset = strokeWidth / 2.0;
    double mValue = (value ?? .0);
    mValue = mValue.clamp(.0, 1.0) * total;
    double start = .0;

    if(strokeCapRound) {
      start = asin(strokeWidth / (size.width - strokeWidth));
    }

    Rect rect = Offset(mOffset, mOffset) & Size(size.width - strokeWidth, size.height - strokeWidth);

    var paint = Paint()
      ..strokeCap = strokeCapRound ? StrokeCap.round : StrokeCap.butt
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    //先画背景
    if (backgroundColor != Colors.transparent) {
      paint.color = backgroundColor;
      canvas.drawArc(rect, start, total, false, paint);
    }

    //画前景,应用渐变
    if (mValue > 0) {
      paint.shader = SweepGradient(
        startAngle: 0.0,
        endAngle: mValue,
        colors: colors,
        stops: stops,
      ).createShader(rect);

      canvas.drawArc(rect, start, mValue, false, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

