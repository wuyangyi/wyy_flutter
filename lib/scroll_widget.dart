import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

//Material设计规范中状态栏、导航栏、ListTile高度分别为24、56、56


class ScrollApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    return Scaffold(
      appBar: AppBar(
        title: Text("SingleChildScrollView"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical, //滚动方向
        physics: new ClampingScrollPhysics(), //滚动到底部后的动画，ClampingScrollPhysics：Android下微光效果。BouncingScrollPhysics：iOS下弹性效果。
        reverse: false, //是否反向，头在尾，尾在头
        child: Container(
          color: Color(0xFFF0F0F0),
          child: Column(
            children: str.split("")
                .map((s) => Container(
              padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              width: double.infinity,
              color: Color(0xFFFFFFFF),
              margin: const EdgeInsets.only(top: 0.5),
              child: Text(s),
            )).toList(),
          ),
        ),
      ),
    );
  }
}

class ListViewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    return Scaffold(
      appBar: AppBar(
        title: Text("ListView"),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFFF0F0F0),
        child: ListView.builder(
          itemCount: 26,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: double.infinity,
                color: Color(0xFFFFFFFF),
                margin: const EdgeInsets.only(top: 0.5),
                child: Text(str.split("")[index]),
            );
          },
        ),
      )
    );
  }
}


class ListViewSeparatedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    Widget driver1 = Divider(color: Color(0xFF777EFF),);
    Widget driver2 = Divider(color: Color(0xFFFFE683),);
    return Scaffold(
      appBar: AppBar(
        title: Text("ListViewSeparated"),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(title: Text(str.split("")[index]),);
        },
        separatorBuilder: (BuildContext context, int index) {
          return index%2 == 0 ? driver1 : driver2;
        },
        itemCount: 26,
      ),
    );
  }
}


//加载数据的ListView
class InfiniteListViewApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _InfiniteListViewState();
  }

}
class _InfiniteListViewState extends State<InfiniteListViewApp> {
  static const loadingTag = "##loading##"; //标记尾部
  var _words = <String>[loadingTag];
  ScrollController _scrollController = new ScrollController(); //滚动监听
  bool showToTopBtn = false; //是否显示"返回到顶部"按钮

  @override
  void initState() {
    super.initState();
    _retrieveData();
    _scrollController.addListener(() {
//      print(_scrollController.offset); //打印位置
      if (_scrollController.offset < 1000 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_scrollController.offset >= 1000 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); //避免内存泄漏
    super.dispose();
  }

  void _retrieveData() {
    Future.delayed(Duration(seconds: 2)).then((e) {
      _words.insertAll(_words.length - 1,
          //每次生成20个单词，需要导入包
          generateWordPairs().take(20).map((e) => e.asPascalCase).toList()
      );
      setState(() {
        //重新构建列表
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !showToTopBtn ? null : FloatingActionButton(
        child: Icon(Icons.arrow_upward),
        onPressed: () {
          _scrollController.animateTo(.0, duration: Duration(microseconds: 1000), curve: Curves.ease);
        },
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text("单词列表"),
          ),
          Divider(height: .0),
          Expanded(
            child: ListView.separated(
              controller: _scrollController,
              physics: new BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                //如果到了末尾
                if (_words[index] == loadingTag) {
                  if (_words.length - 1 < 200) { //不足100条，继续加载
                    _retrieveData();
                    return Container(
                      padding: const EdgeInsets.all(15.0),
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: CircularProgressIndicator(strokeWidth: 2.0,),
                      ),
                    );
                  } else { //已经加载到100条，显示没有更多数据
                    return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(15.0),
                      child: Text("没有更多了", style: TextStyle(color: Colors.grey),),
                    );
                  }
                }
                return ListTile(title: Text(_words[index]),);
              },
              separatorBuilder: (context, index) {
                return Divider(height: .0);
              },
              itemCount: _words.length,

            ),
          )
        ],
      ),
    );
  }

}

//加载数据GridView
class InfiniteGridViewApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new InfiniteGridViewState();
  }

}

class InfiniteGridViewState extends State<InfiniteGridViewApp> {

  List<IconData> _icons = []; //保存Icon数据

  String _progress = "0%"; //保存进度百分比


  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    Future.delayed(Duration(milliseconds: 200)).then((e) {
      setState(() {
        for (int i = 0; i < 10; i++) {
          _icons.addAll([
            Icons.ac_unit,
            Icons.airport_shuttle,
            Icons.all_inclusive,
            Icons.beach_access, Icons.cake,
            Icons.free_breakfast,
            Icons.print,
            Icons.map,
            Icons.dashboard,
            Icons.account_circle,
          ]);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar( //进度条
      child: NotificationListener(
        onNotification: (ScrollNotification notification) {
          double progress = notification.metrics.pixels / notification.metrics.maxScrollExtent;
          setState(() {
            _progress = "${(progress * 100).toInt()}%";
          });
          return false;
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, //每列3行
                childAspectRatio: 1.0, //显示区域高宽比1：1
              ),
              itemCount: _icons.length,
              itemBuilder: (context, index) {
//                if (index == _icons.length - 1 && _icons.length < 400) {
//                  initData();
//                }
                return Icon(_icons[index]);
              },
            ),
            CircleAvatar(
              radius: 30.0,
              child: Text(_progress),
              backgroundColor: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }

}

//CustomScrollView
class CustomScrollViewTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //因为本路由没有使用Scaffold，为了让子级Widget(如Text)使用
    //Material Design 默认的样式风格,我们使用Material作为本路由的根。
    return Material(
      child: CustomScrollView(
//        physics: new BouncingScrollPhysics(), //ios效果
        slivers: <Widget>[
          //AppBar，包含一个导航栏
          SliverAppBar(
            pinned: true, //是否固定导航栏
            expandedHeight: 200.0,
//            title: const Text('个人主页'),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              collapseMode: CollapseMode.pin,
              title: const Text(
                '个人主页',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://ws1.sinaimg.cn/large/0065oQSqly1fw8wzdua6rj30sg0yc7gp.jpg",
                    ),
                    fit: BoxFit.cover,
                  )
                ),
                child: Center(
                  child: Text(
                      "活跃度56",
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: new SliverGrid( //Grid
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //Grid按两列显示
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 4.0,
              ),
              delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  //创建子widget
                  return new Container(
                    alignment: Alignment.center,
                    color: Colors.cyan[100 * (index % 9)],
                    child: new Text('grid item $index'),
                  );
                },
                childCount: 20,
              ),
            ),
          ),
          //List
          new SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  //创建列表项
                  return new Container(
                    alignment: Alignment.center,
                    color: Colors.lightBlue[100 * (index % 9)],
                    child: new Text('list item $index'),
                  );
                },
                childCount: 50 //50个列表项
            ),
          ),
        ],
      ),
    );
  }
}
