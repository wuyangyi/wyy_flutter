import 'package:flutter/material.dart';

//线性布局
class RowColumnApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 20.0,
            color: Colors.white,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                icon: ImageIcon(AssetImage("images/ico_go_back.png")),
                onPressed: () {
                  Navigator.maybePop(context);
                },
              ),
              Expanded(
                child: Text(
                  "中间标题",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF363951),
                    fontSize: 17.0,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: (){
                  Navigator.push(
                      context,
                      new MaterialPageRoute(builder: (context){
                        return new FlexLayoutRoute();
                      })
                  );
                },
              )
            ],
          ),
          Container(
            height: 0.5,
            color: Color(0xFFF1F2F3),
          )
        ],
      ),
    );
  }

}

//弹性布局
class FlexLayoutRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("弹性布局"),
      ),
      body: Column(
        children: <Widget>[
          Flex(
            direction: Axis.horizontal, //排列方向
            children: <Widget>[
              Expanded(
                flex: 1, //占比(权重)，和LinearLayout的weight一样
                child: Container(
                  height: 30.0,
                  color: Colors.red,
                ),
              ),
              Expanded(
                flex: 2, //占比
                child: Container(
                  height: 30.0,
                  color: Colors.grey,
                ),
              ),
              Text("11"*3),
            ],
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) {
                return new WarpLayoutRoute();
              }),
              );
            },
          )
        ],
      ),
    );
  }

}

//流式布局
class WarpLayoutRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text("流式布局"),
        centerTitle: true,
      ),
      body: Center(
        child: Wrap(
          spacing: 8.0, //水平方向间距
          runSpacing: 4.0, //垂直方向间距
          alignment: WrapAlignment.center, //水平居中
          children: <Widget>[
            new Chip(
              avatar: new CircleAvatar(backgroundColor: Color(0xFF777EFF),child: Text("A"),),
              label: new Text("AnyOne"),
            ),
            new Chip(
              avatar: new CircleAvatar(backgroundColor: Color(0xFF777EFF),child: Text("B"),),
              label: new Text("But"),
            ),
            new Chip(
              avatar: new CircleAvatar(backgroundColor: Color(0xFF777EFF),child: Text("C"),),
              label: new Text("Come"),
            ),
            new Chip(
              avatar: new CircleAvatar(backgroundColor: Color(0xFF777EFF),child: Text("H"),),
              label: new Text("Height"),
            ),
            new Chip(
              backgroundColor: Color(0xFFFFFFFF),
              avatar: new CircleAvatar(backgroundColor: Color(0xFF777EFF),child: Text("M"),),
              label: new Text("Month"),
            ),
          ],
        ),
      ),
    );
  }

}

//层叠布局
class StackLayoutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text("层叠布局"),
//        centerTitle: true,
//      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 86.5,
          minWidth: double.infinity, //尽可能大
        ),
        child: Padding(
            padding: EdgeInsets.only(top: 35.0),
          child: Stack(
            alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
              Container(
                child: Text(
                  "中间标题",
                  style: TextStyle(
                    fontSize: 17.0,
                    color: Color(0xFF363951),
                  ),
                ),
              ),
              Positioned(
                left: 5.0,
                child: IconButton(
                  icon: ImageIcon(AssetImage("images/ico_go_back.png")),
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                ),
              ),
              Positioned(
                bottom: 0.5,
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 0.5,
                      minWidth: double.infinity,
                    ),
                  child: Container(
                    color: Color(0xFFF0F0F0),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

}