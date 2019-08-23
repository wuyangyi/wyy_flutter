import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class DioTextRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DioTextState();
  }

}

class DioTextState extends State<DioTextRoute> {
//  static const loadingTag = "##loading##"; //标记尾部
//  static var itemTag = TextItem(ganhuo_id: "$loadingTag"); //标记尾部
//  static const int pageNumber = 15;
//  var page = 1;
//  List<TextItem> data = [itemTag];
  Dio dio = Dio();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FutureBuilder(
          future: dio.get("https://api.github.com/orgs/flutterchina/repos"),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //请求完成
            if (snapshot.connectionState == ConnectionState.done) {
              Response response = snapshot.data;
              //发生错误
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              //请求成功，通过项目信息构建用于显示项目名称的ListView
              return ListView(
                children: response.data.map<Widget>((e) =>
                    ListTile(title: Text(e["full_name"]))
                ).toList(),
              );
            }
            //请求未完成时弹出loading
            return CircularProgressIndicator();
          }
      ),
    );
  }

}

class TextItem {
  TextItem({this.ganhuo_id});
  String desc;
  String ganhuo_id;
  String publishedAt;
  String type;
  String url;
  String who;
}