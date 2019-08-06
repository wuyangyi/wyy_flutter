import 'package:flutter/material.dart';
import 'package:wyy_flutter/new_route.dart';
import 'package:wyy_flutter/row_column.dart';
import 'package:wyy_flutter/decorated_box.dart';
import 'package:wyy_flutter/home.dart';
import 'package:wyy_flutter/scroll_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData( //主题颜色
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      //注册表路由
      routes: {
        "new_page": (context) => NewRoute(),
        "outline_button": (context) => CheckBoxApp(),
        "input_text": (context) => InputTextApp(),
        "row_column": (context) => RowColumnApp(),
      },
      home: HomeApp(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 5;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (_counter > 0) {
        _counter--;
      } else {
        Navigator.pushNamed(
          context,
          "new_page",  //根据路由名称跳转
          arguments: "https://ws1.sinaimg.cn/large/0065oQSqly1g0ajj4h6ndj30sg11xdmj.jpg"

        );
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text("标题"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column( //垂直排列
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '你的剩余次数:',
              style: Theme.of(context).textTheme.display1,
            ),
            Text(
              '剩余$_counter次',
              style: Theme.of(context).textTheme.headline,
            ),
            FlatButton(
              color: Colors.blue, //按钮背景颜色
              highlightColor: Colors.blue[700], //按钮按下时颜色
              colorBrightness: Brightness.dark, //按钮主题颜色
              splashColor: Colors.grey, //点击时，水波动画中水波的颜色
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //外形
              child: Text(
                "FlatButton",
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) {
                      return new NewRoute();
                }
                    ));
              },
            ),
            //漂浮按钮，即带阴影效果的按钮，按下后阴影变大
            RaisedButton(
              child: Text("RaisedButton"),
              onPressed: () {
                  Navigator.pushNamed(
                    context,
                    "new_page",
                    arguments: "https://ws1.sinaimg.cn/large/0065oQSqly1fytdr77urlj30sg10najf.jpg"
                  );
                },
            ),
            OutlineButton(
              child: Text("OutlineButton"),
              onPressed: (){
                Navigator.pushNamed(context, "outline_button");
              },
            ),
            IconButton(
              icon: Icon(Icons.visibility),
              onPressed: (){
                Navigator.pushNamed(context, "row_column");
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) {
                      return new StackLayoutApp();
                    })
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) {
                      return new DecBoxApp();
                    })
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) {
                      return new ScrollApp();
                    })
                );
              },
            ),
            OutlineButton(
              child: Text("ListView"),
              onPressed: (){
                Navigator.push(context, new MaterialPageRoute(builder: (context) {
                  return new ListViewApp();
                }));
              },
            ),
            RaisedButton(
              child: Text("ListViewSeparatedApp"),
              onPressed: (){
                Navigator.push(context, new MaterialPageRoute(builder: (context) {
                  return new ListViewSeparatedApp();
                }));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.backup),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
//自定义标题栏
//class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
//  final Widget child;
//
//  MyAppBar({this.child}) : assert(child != null);
//
//  @override
//  State<StatefulWidget> createState() {
//    return new MyAppBarState();
//  }
//
//  @override
//  Size get preferredSize => new Size.fromHeight(50.0);
//
//}
//
//class MyAppBarState extends State<MyAppBar> {
//  @override
//  Widget build(BuildContext context) {
//    return new SafeArea(
//      child: widget.child,
//      top: true,
//    );
//  }
//
//}


//第二个界面
class NewRoute extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context).settings.arguments; //接收传递过来的参数
    return Scaffold(
      appBar: AppBar(
        title: Text("带参数传递"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image.network(
                args == null ? "https://ww1.sinaimg.cn/large/0065oQSqly1g2hekfwnd7j30sg0x4djy.jpg" : args,
                width: 150.0,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              Text.rich(TextSpan(
                children: [
                  TextSpan(
                    text: "工作职责：",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 25.0,
                    )
                  ),
                  TextSpan(
                      text: "\n  1.  设计新产品新功能，撰写产品需求说明书及产品设计文档；\n  2.  与技术开发和设计人员沟通需求，推进产品按计划顺利执行，跟踪产品研发进度；\n  3.  设计、维护产品所需日常文档，如测试用例、版本日志、数据统计日志等；",
                      style: TextStyle(
                        color: Colors.black, //字体颜色
                        fontSize: 17.0, //字体大小
                        height: 1.2, //行高
                        fontFamily: "Courier", //字体样式
                        backgroundColor: Colors.white,
                        decoration: TextDecoration.underline, //下划线
                        decorationStyle: TextDecorationStyle.dashed, //实（虚）线
                        decorationColor: Colors.red,
                      )
                  ),
                ]
              )),
              DefaultTextStyle(
                //设置默认样式
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15.0,
                  backgroundColor: Colors.grey,
                ),
                textAlign: TextAlign.start,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("默认样式1"),
                    Text("默认样式2"),
                    Text(
                      "非默认样式",
                      style: TextStyle(
                        inherit: false, //不继承默认样式
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ]
        )

      ),
    );
  }
  
}
