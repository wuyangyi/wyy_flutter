import 'package:flutter/material.dart';
import 'package:wyy_flutter/util.dart';
//对话框实例
// ignore: must_be_immutable
class AlertDialogApp extends StatelessWidget {
  List<String> list = ["垃圾广告营销", "嘲讽/不友善内容", "淫秽色情/违法有害内容", "其他"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("对话框实例"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("对话框1"),
            onPressed: () async {
              bool isDel =  await showDialogUtil(context, DialogUtil());
              ToastUtil(isDel ? "删除成功" : "已取消");
            },
          ),
          RaisedButton(
            child: Text("选择语言"),
            onPressed: () async {
              int position = await showDialogUtil(context, DialogLanguage());
              if (position != null) {
                ToastUtil(position == 1 ? "中文简体" : "美式英语");
              }
            },
          ),
          RaisedButton(
            child: Text("ListView对话框"),
            onPressed: () async {
              int position = await showDialogUtil(context, ListDialog());
              if (position != null) {
                ToastUtil("$position");
              }
            },
          ),
          RaisedButton(
            child: Text("自定义动画弹窗"),
            onPressed: () async {
              int position = await showCustomDialogUtil(context, ListDialog());
              if (position != null) {
                ToastUtil("$position");
              }
            },
          ),
          RaisedButton(
            child: Text("带复选框弹窗"),
            onPressed: () async {
              int position = await showCustomDialogUtil(context, CheckBoxDialog());
              if (position != null) {
                String msg;
                if (position == 0){
                  msg = "已取消:不删除子目录";
                }else if (position == 1) {
                  msg = "已取消:删除子目录";
                } else if (position == 2) {
                  msg = "文件已删除:不删除子目录";
                } else if (position == 3) {
                  msg = "文件已删除:子目录已删除";
                }
                ToastUtil("$msg");
              }
            },
          ),
          RaisedButton(
            child: Text("底部菜单弹出"),
            onPressed: () async {
              showModalBottomSheetUtil(context, ActiveBottomDialog(list));
            },
          ),
          RaisedButton(
            child: Text("底部弹出全屏菜单栏"),
            onPressed: () {
              int position = (_showBottomSheet(context)) as int;
              if (position != null) {
                ToastUtil(position == -1 ? "取消" : "${list[position]}");
              }
            },
          ),
          RaisedButton(
            child: Text("加载动画"),
            onPressed: () {
              showLoadingDialog(context);
            },
          ),
        ],
      ),
    );
  }

}

//普通弹出对话框showDialog
//T为对话框样式
Future showDialogUtil(BuildContext context, T) {
  return showDialog(
    context: context,
    builder: (context) {
      return T;
    }
  );
}

//自定义动画弹窗
Future showCustomDialogUtil(BuildContext context, T) {
  return showCustomDialog(
      context: context,
      builder: (context) {
        return T;
      }
  );
}

//从底部弹窗菜单列表
Future showModalBottomSheetUtil(BuildContext context, T) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return T;
      }
  );
}

//从底部弹出全屏的菜单列表
PersistentBottomSheetController<int> _showBottomSheet(BuildContext context) {
  return showBottomSheet<int>(
    context: context,
    builder: (BuildContext context) {
      return ListView.builder(
        itemCount: 30,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text("$index"),
            onTap: (){
              // do something
              print("$index");
              Navigator.of(context).pop();
            },
          );
        },
      );
    },
  );
}

//对话框（样式一）
class DialogUtil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text("提示"),
      ),
//      titlePadding: const EdgeInsets.only(left: 50.0), //标题填充
      titleTextStyle: TextStyle( //标题文本样式
        color: Colors.blue,
      ),
      content: Text("您确定要删除当前文件吗？"),
//      contentPadding: const EdgeInsets.all(5.0), //内容填充
      contentTextStyle: TextStyle( //内容文本样式
        color: Colors.grey,
      ),
      backgroundColor: Color(0xFFF0F0F0), //对话框背景色
      elevation: 2.0, //对话框阴影
      actions: <Widget>[ //对话框操作按钮
        FlatButton(
          child: Text("取消"),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        FlatButton(
          child: Text("确定"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}


//语言选择
class DialogLanguage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('请选择语言'),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            // 返回1
            Navigator.pop(context, 1);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: const Text('中文简体'),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            // 返回2
            Navigator.pop(context, 2);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: const Text('美式英语'),
          ),
        ),
      ],
    );
  }

}

//ListView的Dialog
class ListDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var child = Column(
      children: <Widget>[
        ListTile(title: Text("请选择")),
        Expanded(
            child: ListView.builder(
              itemCount: 30,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Center(child: Text("$index"),),
                  onTap: () => Navigator.of(context).pop(index),
                );
              },
            )),
      ],
    );
    return Dialog(
      child: child,
    );
  }

}


//对话框弹出动画封装
Future<T> showCustomDialog<T> ({
  @required BuildContext context,
  bool battierDismissible = true,//点击遮罩是否关闭对话框默认为true
  WidgetBuilder builder,
}) {
  final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
  return showGeneralDialog(
    context: context,
    pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
    ) {
      final Widget pageChild = Builder(builder: builder);
      return SafeArea(
        child: Builder(builder: (BuildContext context) {
          return theme != null ? Theme(data: theme, child: pageChild,) : pageChild;
        }),
      );
    },
    barrierDismissible: battierDismissible, //点击遮罩是否关闭对话框
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel, //语义化标签
    barrierColor: Colors.black45, //自定义遮罩颜色
    transitionDuration: const Duration(milliseconds: 300), //对话框打开或关闭的时长
    transitionBuilder: _buildMaterialDialogTransitions, //打开和关闭的动画
  );
}

//对话框放缩动画
Widget _buildMaterialDialogTransitions (
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    ) {
  return ScaleTransition(
    scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
    ),
    child: child,
  );
}


//带复选框的弹窗
//复选框选中与取消中不能通过setState来重构
// ignore: must_be_immutable
class CheckBoxDialog extends StatelessWidget {
  bool _withTree = false; //选中状态
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("提示"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("您确定要删除当前文件吗?"),
          Row(
            children: <Widget>[
              Text("同时删除子目录？"),
              // 通过Builder来获得构建Checkbox的`context`，
              // 这是一种常用的缩小`context`范围的方式
              Builder(
                builder: (BuildContext context) {
                  return Checkbox( // 依然使用Checkbox组件
                    value: _withTree,
                    onChanged: (bool value) {
                      // 此时context为Checkbox的根Element，我们
                      // 直接将Checkbox对应的Element标记为dirty
                      (context as Element).markNeedsBuild();
                      _withTree = !_withTree;
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("取消"),
          onPressed: () => Navigator.of(context).pop(_withTree ? 1 : 0),
        ),
        FlatButton(
          child: Text("删除"),
          onPressed: () {
            // 执行删除操作
            Navigator.of(context).pop(_withTree ? 3 : 2);
          },
        ),
      ],
    );;
  }

}


//底部弹窗
class ActiveBottomDialog extends StatelessWidget {
  ActiveBottomDialog(this.date);

  final List<String> date; //选项

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return new Divider(height: .0,);
                },
                itemCount: date.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        date[index],
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Color(0xFF363951),
                        ),
                      ),
                    ),
                    onTap: () => Navigator.of(context).pop(index),
                  );
                },
              ),
            ),
          ),
          new GestureDetector(
            onTap: () {
              Navigator.of(context).pop(-1);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 5.0, bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.center,
              child: Text(
                "取消",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Color(0xFF363951),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}

//加载动画弹窗
showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, //点击遮罩不关闭对话框
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 26.0),
              child: Text("正在加载，请稍后..."),
            )
          ],
        ),
      );
    },
  );
}