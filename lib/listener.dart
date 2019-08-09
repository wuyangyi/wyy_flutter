import 'package:flutter/material.dart';
//原始指针处理
class ListenerApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ListenerState();
  }
}

class ListenerState extends State<ListenerApp> {
  //定义一个状态，保存当前指针位置
  PointerEvent _event;
  //手势识别，保存事件名
  String _operation = "未操作";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listener实例"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Listener(
            child: Container(
              alignment: Alignment.center,
              color: Colors.blue,
              width: double.infinity,
              height: 150.0,
              child: Text(
                _event?.toString()??"",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.0,
                ),
              ),
            ),
            onPointerDown: (PointerDownEvent event) => setState(() => _event = event),
            onPointerMove: (PointerMoveEvent event) => setState(() => _event = event),
            onPointerUp: (PointerUpEvent event) => setState(() => _event = event),
          ),

          //behavior实例
          Stack(
            children: <Widget>[
              Listener(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(300.0, 200.0)),
                  child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.blue)),
                ),
                onPointerDown: (event) => print("down0"),
              ),
              Listener(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(200.0, 100.0)),
                  child: Center(child: Text("左上角200*100范围内非文本区域点击")),
                ),
                onPointerDown: (event) => print("down1"),
                behavior: HitTestBehavior.translucent, //放开此行注释后可以"点透"
              ),
            ],
          ),
          //手势识别GestureDetector
          GestureDetector(
            child: Container(
              alignment: Alignment.center,
              color: Colors.red,
              width: double.infinity,
              height: 100,
              child: Text(
                _operation,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () => updateText("点击"),
            onDoubleTap: () => updateText("双击"),
            onLongPress: () => updateText("长按"),
          ),
        ],
      ),
    );
  }

  void updateText(String text) {
    setState(() {
      _operation = text;
    });
  }

}

//拖动，滑动
class MoveWidgetApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MoveWidgetState();
  }
}

class MoveWidgetState extends State<MoveWidgetApp> {
  double _top = 0.0; //距顶部的偏移
  double _left = 0.0;//距左边的偏移
  var colors = Color(0xFF777EFF);
  //当前位置
  double _btn_top = 75.0;
  double _btn_left = 75.0;

  double _ver_top = 100.0;
  
  double _width = 200.0; //宽度

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("滑动、移动"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: _top,
            left: _left,
            child: GestureDetector(
              child: CircleAvatar(
                child: Text("+"),
              ),
              //手指按下时会出发此回调
              onPanDown: (DragDownDetails e) {
                print("用户手指按下：${e.globalPosition}");
              },
              //手指滑动时会出发的回调
              onPanUpdate: (DragUpdateDetails e) {
                setState(() {
                  _left += e.delta.dx;
                  _top += e.delta.dy;
                });
              },
              //滑动结束
              onPanEnd: (DragEndDetails e) {
                print(e.velocity);
              },
            ),
          ),
          Positioned(
            bottom: 50.0,
            left: 50.0,

              child: Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(360.0)
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: _btn_top,
                      left: _btn_left,
                      child: GestureDetector(
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          child: CircleAvatar(
                            backgroundColor: colors,
                            child: Icon(Icons.add),
                          ),
                        ),
                        //手指按下时会出发此回调
                        onPanDown: (DragDownDetails e) {
//                          print("用户手指按下：${e.globalPosition}");
                          colors = Colors.blue;
                        },
                        //手指滑动时会出发的回调
                        onPanUpdate: (DragUpdateDetails e) {
                          setState(() {
                            _btn_left += e.delta.dx;
                            _btn_top += e.delta.dy;
//                            _btn_left += _left;
//                            _btn_top += _top;
                          });
                        },
                        //滑动结束
                        onPanEnd: (DragEndDetails e) {
                          _left = 0.0;
                          _top = 0.0;
                          _btn_top = 75.0;
                          _btn_left = 75.0;
                          colors = Color(0xFF777EFF);
                        },
                      )
                    ),
                  ],
                ),
              ),
          ),
          //单方向拖动
          Positioned(
            top: _ver_top,
            child: GestureDetector(
              child: CircleAvatar(child: Text("B"),),
              onVerticalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  _ver_top += details.delta.dy;
                });
              },
            ),
          ),
          
          //放缩
          Center(
            child: GestureDetector(
              child: Image.network(
                "https://ws1.sinaimg.cn/large/0065oQSqgy1fwgzx8n1syj30sg15h7ew.jpg",
                width: _width,
              ),
              onScaleUpdate: (ScaleUpdateDetails details) {
                setState(() {
                  _width = 200 * details.scale.clamp(.5, 100.0);//放缩倍数在0.5到100.0倍之间
                });
              },
            ),
          ),

        ],
      ),
    );
  }

}
