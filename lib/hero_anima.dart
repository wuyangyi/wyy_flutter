import 'package:flutter/material.dart';
//hero动画

class HeroAnimationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户信息(Hero实例)"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          //头像为hero动画(会飞的widget)
          Container(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              child: Hero(
                tag: "hero_avatar_head", //唯一标记，前后两个路由页Hero的tag必须相同
                child: ClipOval(
                  child: Image.network(
                    "http://ww1.sinaimg.cn/large/0065oQSqly1fs8u1joq6fj30j60orwin.jpg",
                    width: 60.0,
                    height: 60.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: (){
                Navigator.push(context, PageRouteBuilder(
                  pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
                    return new FadeTransition(opacity: animation,
                      child: Scaffold(
//                    appBar: AppBar(
//                      title: Text("原图"),
//                      centerTitle: true,
//                    ),
                        backgroundColor: Color(0x00000000),
                        body: HeroAnimationRouteB(),
                      ),
                    );
                  },
                ));
              },
            ),
          ),
          FlatButton(
            child: Text("交织动画实例展示"),
            onPressed: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) {
                return new StaggerAnimationApp();
              }));
            },
          ),
        ],
      ),
    );
  }

}

class HeroAnimationRouteB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: "hero_avatar_head", //唯一标记，前后两个路由页Hero的tag必须相同
        child: GestureDetector(
          onTap: () {
            Navigator.maybePop(context);
          },
          child: Image.network(
            "http://ww1.sinaimg.cn/large/0065oQSqly1fs8u1joq6fj30j60orwin.jpg",
          ),
        )
      ),
    );
  }
}

//交织动画实例
//交织动画widget分离出来
class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({ Key key, this.controller }): super(key: key){
    //高度动画
    height = Tween<double>(
      begin:.0 ,
      end: 300.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0, 0.6, //间隔，前60%的动画时间
          curve: Curves.ease,
        ),
      ),
    );

    color = ColorTween(
      begin:Colors.green ,
      end:Colors.red,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0, 0.6,//间隔，前60%的动画时间
          curve: Curves.ease,
        ),
      ),
    );

    padding = Tween<EdgeInsets>(
      begin:EdgeInsets.only(left: .0),
      end:EdgeInsets.only(left: 100.0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.6, 1.0, //间隔，后40%的动画时间
          curve: Curves.ease,
        ),
      ),
    );
  }


  final Animation<double> controller;
  Animation<double> height;
  Animation<EdgeInsets> padding;
  Animation<Color> color;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding:padding.value ,
      child: Container(
        color: color.value,
        width: 50.0,
        height: height.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

class StaggerAnimationApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StaggerAnimationState();
  }
}

class StaggerAnimationState extends State<StaggerAnimationApp> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
  }

  Future<Null> _playAnimation() async {
    try {
      //先正向执行动画
      await _controller.forward().orCancel;
      //再反向执行动画
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      //动画被取消了，可能是因为我们被处置了
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _playAnimation();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("交织动画"),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            width: 300.0,
            height: 300.0,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              border: Border.all(
                color:  Colors.black.withOpacity(0.5),
              ),
            ),
            //调用我们定义的交织动画Widget
            child: StaggerAnimation(controller: _controller,),
          ),
        ),
      ),
    );
  }

}