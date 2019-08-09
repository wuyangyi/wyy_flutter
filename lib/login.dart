import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wyy_flutter/util.dart';
import 'package:wyy_flutter/dialog.dart';
import 'package:wyy_flutter/event.dart';

class LoginApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginState();
  }

}

class LoginState extends State<LoginApp> {
  UserInfo userInfo = new UserInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image(image: AssetImage("images/ico_login_top.png"), width: double.infinity, height: 251.0, fit: BoxFit.cover,),
                Positioned(
                  top: 32.0,
                  right: 15.0,
                  child: Text(
                    "跳过",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            ),

            Container(
              margin: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 11.5),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset("images/ico_login_phone.png", fit: BoxFit.cover, width: 13.0, height: 20.0,),

                      Expanded(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            textAlign: TextAlign.left,
                            autofocus: true, //是否自动获取焦点
//                      maxLength: 11, //长度(这个右下角会有统计字符的长度文本显示)
                            inputFormatters: [LengthLimitingTextInputFormatter(11)],
                            style: TextStyle(
                              color: Color(0xFF363951),
                              fontSize: 14.0,
                            ),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration( //外观样式
                              hintText: "请输入手机号，开启内推之旅",
                              contentPadding: const EdgeInsets.all(15.0),
                              border: InputBorder.none, //去除自带的下划线
                              hintStyle: TextStyle(
                                color: Color(0xFFCBCDD5),
                                fontSize: 14.0,
                              ),
                            ),
                            onChanged: (value) {
                              userInfo.phone = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 25.0),
                    child: Divider(
                      color: Color(0xFFE7E7E7),
                      height: 0.5,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset("images/ico_login_pwd.png", fit: BoxFit.cover, width: 16.5, height: 21.0,),

                      Expanded(
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            textAlign: TextAlign.left,
                            autofocus: true, //是否自动获取焦点
//                      maxLength: 20, //长度(这个右下角会有统计字符的长度文本显示)
                            inputFormatters: [LengthLimitingTextInputFormatter(20)],
                            style: TextStyle(
                              color: Color(0xFF363951),
                              fontSize: 14.0,
                            ),
                            obscureText: true, //是否是密码
                            decoration: InputDecoration( //外观样式
                              hintText: "请输入6-20位数字和字母组成的密码",
                              contentPadding: const EdgeInsets.fromLTRB(11.5, 15.0, 15.0, 15.0),
                              border: InputBorder.none, //去除自带的下划线
                              hintStyle: TextStyle(
                                color: Color(0xFFCBCDD5),
                                fontSize: 14.0,
                              ),
                            ),
                            onChanged: (value) {
                              userInfo.pwd = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Color(0xFFE7E7E7),
                    height: 0.5,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (userInfo.phone == null || !checkPhone(userInfo.phone)) {
                  ToastUtil("手机号格式不正确");
                  return;
                }
                if (userInfo.pwd == null || !checkPwd(userInfo.pwd)) {
                  ToastUtil("请输入6-20位密码");
                  return;
                }
                showLoadingDialog(context);
                doLogin(context);
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 10.0),
                alignment: Alignment.center,
                width: double.infinity,
                height: 40.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color(0xFF777EFF),
                ),
                child: Text(
                  "登录",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }

  //检验手机号
  bool checkPhone(String phone) {
    if (phone.isEmpty || phone.length < 11) {
      return false;
    }
    return true;
  }

  //检验密码
  bool checkPwd(String pwd) {
    if (pwd.isEmpty || (pwd.length > 20 && pwd.length < 6)) {
      return false;
    }
    return true;
  }

  void doLogin(BuildContext context) {
    Future.delayed(Duration(seconds: 2)).then((e) { //模拟网络加载，等待2s
      bus.emit("login", userInfo.phone);//用EventBus触发登录成功事件
      Navigator.of(context).pop(); //关闭加载动画
      Navigator.maybePop(context); //关闭当前界面
    });
  }

}

//用户信息
class UserInfo {
  String phone;
  String pwd;
}