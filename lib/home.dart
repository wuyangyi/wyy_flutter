import 'package:flutter/material.dart';
import 'package:wyy_flutter/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wyy_flutter/scroll_widget.dart';
import 'package:wyy_flutter/util.dart';

class HomeApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }

}

class _HomeState extends State<HomeApp> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  DateTime _lastPresseAt; //上次点击的时间

  TabController _tabController;
  List tabs = ["推荐", "关注", "附近"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
//    _tabController.addListener(() {
//      switch(_tabController.index) {
//        case 1:
//      }
//    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async {
        if (_lastPresseAt == null || DateTime.now().difference(_lastPresseAt) > Duration(seconds: 1)) {
          //两次点击时间超过一秒，从下记时
          _lastPresseAt = DateTime.now();
          ToastUtil("连续点击即可退出哦~");
          return false;
        }
        //两次点击小于1s
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("小熊爱睡觉"),
          leading: Builder(
              builder: (context) {
                return IconButton(
                    icon: Icon(Icons.dashboard),
                    onPressed: (){
                      // 打开抽屉菜单
                      Scaffold.of(context).openDrawer();
                    }
                );
              }
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                ToastUtil("分享");
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: tabs.map((e) => Tab(text: e)).toList(),
          ),
        ),
        drawer: new MyDrawer(),
        //底部导航栏
//      bottomNavigationBar: BottomNavigationBar(
//        items: <BottomNavigationBarItem>[
//          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
//          BottomNavigationBarItem(icon: Icon(Icons.business), title: Text("发现")),
//          BottomNavigationBarItem(icon: Icon(Icons.school), title: Text("学校")),
//        ],
//        currentIndex: _selectedIndex,
//        fixedColor: Color(0xFF777EFF),
//        onTap: _onItemTapped,
//      ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          shape: CircularNotchedRectangle(), //底部导航栏打一个圆形的洞
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                },
              ),
              SizedBox(), //中间位置空出
              IconButton(icon: Icon(Icons.business)),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround, //均分底部导航栏横向空间
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return new MyHomePage();
            }));
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: TabBarView(
          controller: _tabController,
          children: tabs.map((e) {
            return Container(
              alignment: Alignment.center,
              color: Color(0xFFF0F0F0),
              child: e == "关注" ? InfiniteListViewApp() : InfiniteGridViewApp(),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}

//抽屉
class MyDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFFFFFFFF),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 50.0),
              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              child: Row(
                children: <Widget>[
                  ClipOval(
                    child: Image.network(
                      "https://ws1.sinaimg.cn/large/0065oQSqly1fw8wzdua6rj30sg0yc7gp.jpg",
                      fit: BoxFit.cover,
                      height: 80.0,
                      width: 80.0,
                    ),
                  ),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "小熊",
                        ),
                      )
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.add),
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Add",
                        ),
                      )
                  ),
                ],
              ),
            ),
            FlatButton(
              child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.settings),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Text(
                            "Setting",
                          ),
                        )
                    ),
                  ],
                ),
              ),
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(builder: (context) {
                  return new CustomScrollViewTestRoute();
                }));
              },
            )
          ],
        ),
      ),
    );
  }

}


