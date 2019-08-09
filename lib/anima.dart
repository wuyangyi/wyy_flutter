import 'package:flutter/material.dart';
import 'package:wyy_flutter/hero_anima.dart';

//动画
class ScaleAnimationApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ScaleAnimationState();
  }
}
//需要继承TickerProvider，如果有多个AnimationController，则应该使用TickerProviderStateMixin。
class ScaleAnimationState extends State<ScaleAnimationApp> with SingleTickerProviderStateMixin {

  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), //动画持续时间
    );
    //图片宽高从0变到300
    animation = new Tween(begin: 0.0, end:  300.0).animate(controller);
    //使用AnimatedWidget后这里不需要
//      ..addListener(() {
//        setState(() {
//        });
//      });

    //动画状态监听
    animation.addStatusListener((status) {
      //dismissed: 动画在起始点停止
      //forward: 动画正在正向执行
      //reverse: 动画正在反向执行
      //completed: 	动画在终点停止
      if (status == AnimationStatus.completed) {
        //正向动画结束反向执行动画
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        //反向动画结束正向执行动画
        controller.forward();
      }
    });

    //启动动画（正向执行）
    controller.forward();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("图片动画"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, FadeRoute(builder: (context) {
              return HeroAnimationApp();
            }));
          },
        child: Icon(Icons.account_circle),
      ),
      body: Center(

        //这里直接在AnimatedImage中写了
//        child: Image.network(
//          "https://ws1.sinaimg.cn/large/0065oQSqly1fw0vdlg6xcj30j60mzdk7.jpg",
//          fit: BoxFit.cover,
//          width: animation.value,
//          height: animation.value,
//        ),

        //使用AnimatedWidget简化
//      child: AnimatedImage(animation: animation,),

      //使用AnimatedBuilder从动画中分离出widget
//        child: AnimatedBuilder(
//          animation: animation,
//          child: Image.network(
//            "https://ws1.sinaimg.cn/large/0065oQSqly1fw0vdlg6xcj30j60mzdk7.jpg",
//            fit: BoxFit.cover,
//            width: animation.value,
//            height: animation.value,
//          ),
//          builder: (BuildContext context, Widget child) {
//            return Container(
//              height: animation.value,
//              width: animation.value,
//              child: child,
//            );
//          },
//        ),

      //GrowTransition
        child: GrowTransition(
          child: Image.network(
            "https://ws1.sinaimg.cn/large/0065oQSqly1fw0vdlg6xcj30j60mzdk7.jpg",
            fit: BoxFit.cover,
          ),
          animation: animation,
        ),
      ),
    );
  }

  @override
  void dispose() {
    //路由销毁时需要释放动画资源
    controller.dispose();
    super.dispose();
  }

}

//使用AnimatedWidget简化
class AnimatedImage extends AnimatedWidget {
  AnimatedImage({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Center(
      child: Image.network(
        "https://ws1.sinaimg.cn/large/0065oQSqly1fw0vdlg6xcj30j60mzdk7.jpg",
        fit: BoxFit.cover,
        width: animation.value,
        height: animation.value,
      ),
    );
  }
}

//GrowTransition封装常见的过渡效果来复用动画
class GrowTransition extends StatelessWidget {
  GrowTransition({this.child, this.animation});
  final Widget child;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: new AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget child) {
            return Container(
              height: animation.value,
              width: animation.value,
              child: child,
            );
          },
          child: child,
        ),
      );
  }
  
}
// MaterialPageRoute、CupertinoPageRoute，还是PageRouteBuilder，它们都继承自PageRoute类，
// 而PageRouteBuilder其实只是PageRoute的一个包装。
//
//优先考虑直接使用PageRouteBuilder，这样无需定义一个新的路由类，使用起来会比较方便。
// 实例在home.dart的侧滑，点击通知Notification时调用
//

//自定义路由切换动画，界面切换,继承PageRoute
class FadeRoute extends PageRoute {
  FadeRoute({
    @required this.builder,
    this.transitionDuration = const Duration(milliseconds: 500), //动画时长500毫秒
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
  });

  final WidgetBuilder builder;

  @override
  final Duration transitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  final bool maintainState;


  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    //当前路由是否是新路由
    if (isActive) {
      return FadeTransition(
        opacity: animation,
        child: builder(context),
      );
    } else {
      //如果是返回，关闭当前界面，则不用过度动画
      return Padding(padding: EdgeInsets.zero,);
    }
  }

}