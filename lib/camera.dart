
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orientation/orientation.dart';
import 'package:video_player/video_player.dart';

class CameraApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CameraState();
  }

}
class CameraState extends State<CameraApp> {
  var imagePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("相机"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 10.0),
            width: double.infinity,
            child: GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: _ImageView(imagePath),
              ),
              onTap: () async {
                bool position = await showDialogUtil(context, CameraDialog());
                if (position) { //相机
                  _takePhoto();
                } else { //相册
                  _openGallery();
                }
              },
            ),
          ),
          FlatButton(
            onPressed: (){
              Navigator.push(context, new MaterialPageRoute(builder: (context) {
                return new ImageApp();
              }));
            },
            child: Text("拍照"),
          ),
          FlatButton(
            onPressed: (){
              Navigator.push(context, new MaterialPageRoute(builder: (context) {
                return new VideoApp();
              }));
            },
            child: Text("视频播放"),
          ),
          FlatButton(
            onPressed: (){
              Navigator.push(context, new MaterialPageRoute(builder: (context) {
                return new ChewieVideoListApp();
              }));
            },
            child: Text("chewie视频列表"),
          ),
        ],
      )
    );
  }

  Widget _ImageView(imgPath) {
    if (imgPath == null) {
      return Image.asset("images/ico_head.png", fit: BoxFit.cover, width: 80.0, height: 80.0,);
    } else {
      return Image.file(imgPath, fit: BoxFit.cover, width: 80.0, height: 80.0,);
    }
  }

  /*拍照*/
  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imagePath = image;
    });
  }

  /*相册*/
  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath = image;
    });
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

//ListView的Dialog
class CameraDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var child = Container(
      height: 100.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(
        children: <Widget>[
          Center(
            child: FlatButton(
              child: Text(
                "相机",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                ),
              ),
              onPressed: (){
                Navigator.of(context).pop(true);
              },
            ),
          ),
          Center(
            child: FlatButton(
              child: Text(
                "相册",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                ),
              ),
              onPressed: (){
                Navigator.of(context).pop(false);
              },
            ),
          ),
        ],
      ),
    );
    return Dialog(
      child: child,
    );
  }

}



class ImageApp extends StatefulWidget {
  @override
  _ImageState createState() => _ImageState();
}

class _ImageState extends State<ImageApp> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null
            ? Text('No image selected.')
            : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

//视频播放

class VideoApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _VideoAppState();
  }
}

class _VideoAppState extends State<VideoApp> {
  int orientation = 1;
  VideoPlayerController _controller;
  bool _isPlaying = false;
  String url = "https:\/\/vd3.bdstatic.com\/mda-jh1tuqi4qnxprav4\/mda-jh1tuqi4qnxprav4.mp4";

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(this.url)
    // 播放状态
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() { _isPlaying = isPlaying; });
        }
      })
    // 在初始化完成后必须更新界面
      ..initialize().then((_) {
        setState(() {});
      });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Demo',
      home: new Scaffold(
        backgroundColor: Colors.black,
        body: new Center(
          child: Stack(
            alignment: AlignmentDirectional.center,
            fit: StackFit.loose,
            children: <Widget>[
              _controller.value.initialized
              // 加载成功
                  ? new AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ) : new Container(),
              Positioned(
                bottom: 0.0,
                left: 2.0,
                child: GestureDetector(
                  child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow,),
                  onTap:  _controller.value.isPlaying ? _controller.pause : _controller.play,
                ),
              ),
              Positioned(
                bottom: 7.0,
                left: 30.0,
                right: 30.0,
                child: Container(
                  height: 5.0,
                  child: LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: Colors.grey,

                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 2.0,
                child: GestureDetector(
                  child: Icon(Icons.aspect_ratio),
                  onTap: (){
                    orientation = orientation == 1 ? 0 : 1;
                    setState(() {
                      if (orientation == 1) {
                        ///强制横屏
                        OrientationPlugin.forceOrientation(DeviceOrientation.landscapeRight);
                      } else {
                        ///返回时 设置回竖屏
                        OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
                      }
                    });
                  },
                ),
              )
            ],
          ),
        ),
//        floatingActionButton: new FloatingActionButton(
//          onPressed: _controller.value.isPlaying
//              ? _controller.pause
//              : _controller.play,
//          child: new Icon(
//            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//          ),
//        ),
      ),
    );
  }
}

class ChewieVideoListApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ChewieVideoListState();
  }

}

class ChewieVideoListState extends State<ChewieVideoListApp> {
  List<VideoItem> viders = [];
  
  @override
  void initState() {
    super.initState();
    _initData();
  }
  
  void _initData() {
    viders.add(VideoItem("起司公主", "https:\/\/vd4.bdstatic.com\/mda-jc5kayhwuhb3vgfp\/sc\/mda-jc5kayhwuhb3vgfp.mp4"));
    viders.add(VideoItem("小跳蛙", "https:\/\/vd3.bdstatic.com\/mda-jh1tuqi4qnxprav4\/mda-jh1tuqi4qnxprav4.mp4"));
    viders.add(VideoItem("小猪佩奇", "https:\/\/vd3.bdstatic.com\/mda-jbqfvdxi27yawhv6\/sc\/mda-jbqfvdxi27yawhv6.mp4"));
    viders.add(VideoItem("硬笔书法", "https:\/\/vd3.bdstatic.com\/mda-jhage54ts3d17dq7\/sc\/mda-jhage54ts3d17dq7.mp4"));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("视频播放器"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (BuildContext context, int position) {
          return ListTile(
            title: Text(viders[position].name),
            onTap: (){
              Navigator.pushNamed(
                context,
                "video_player",
                arguments: viders[position].url,
              );
            },
          );
        },
      ),
    );
  }

}

class VideoItem {
  VideoItem(this.name, this.url);
  String name;
  String url;
}

class ChewieVideoPlayerApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ChewieVideoPlayerState();
  }

}

class ChewieVideoPlayerState extends State<ChewieVideoPlayerApp> {
  var url = "";
  var videoPlayerController;
  var chewieController;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    url = ModalRoute.of(context).settings.arguments; //接收传递过来的参数
    videoPlayerController = VideoPlayerController.network(url);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: false, //视频显示后是否立即播放
      looping: false, //视频是否应循环播放
      showControls: true, //是否显示控件
      // 占位图
      placeholder: new Container(
        color: Colors.white,
      ),
      autoInitialize: true, // 是否在 UI 构建的时候就加载视频
      // 拖动条样式颜色
      materialProgressColors: new ChewieProgressColors (
        playedColor: Colors.yellow,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.green,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: new Chewie (
          controller: chewieController,

        ),
      ),
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

}