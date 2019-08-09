import 'package:flutter/material.dart';
import 'package:wyy_flutter/util.dart';
//滚动通知实例 Notification
class NotificationApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NotificationState();
  }

}

class NotificationState extends State<NotificationApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("滚动通知实例-Notification"),
        centerTitle: true,
      ),

      //跳转到自定义通知实例
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return new MyNotificationApp();
          }));
        },
        child: Icon(Icons.golf_course),
      ),
      body: NotificationListener<ScrollStartNotification>( //添加<ScrollStartNotification>后为指定通知，只有当开始滑动时才有通知
        onNotification: (notification){
          switch (notification.runtimeType){
            case ScrollStartNotification: print("开始滚动"); break;
            case ScrollUpdateNotification: print("正在滚动"); break;
            case ScrollEndNotification: print("滚动停止"); break;
            case OverscrollNotification: print("滚动到边界"); break;
          }
          return true;
        },
        child: ListView.builder(
          itemCount: 50,
            itemBuilder: (context, index) {
              return ListTile(title: Text(" $index "),);
            }
        ),
      ),
    );
  }

}



//自定义通知
class MyNotification extends Notification {
  MyNotification(this.msg);
  final String msg;
}
//用法
class MyNotificationApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyNotificationState();
  }
}

class MyNotificationState extends State<MyNotificationApp> {
  String msg = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("自定义通知"),
        centerTitle: true,
      ),
      body: NotificationListener<MyNotification>(
        onNotification: (notification) {
          setState(() {
            msg += notification.msg + "1";
          });
          return true;
        },
        child: NotificationListener<MyNotification>(
          onNotification: (notificaion) {
            setState(() {
              msg += notificaion.msg + "2";
            });
            return false; //返回为true时，阻止冒泡，父NotificationListener将无法接收到通知, false不阻止
          },
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Builder(
                    builder: (context) {
                      return RaisedButton(
                        onPressed: () {
                          MyNotification("Hi").dispatch(context);
                        },
                        child: Text("发布通知"),
                      );
                    },
                  ),
                  Text(msg),
                ],
              ),
            ),
        ),
      ),
    );
  }

}