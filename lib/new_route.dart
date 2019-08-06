import 'package:flutter/material.dart';

class CheckBoxApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _CheckBoxState();
  }
}

class _CheckBoxState extends State<CheckBoxApp> {
  bool _switchSelect = false; //单选开关状态
  bool _checkBoxSelect = false; //复选开关状态

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, //中间标题
        title: Text("单选框和复选框"),
        backgroundColor: Color(0xFF777EFF),
        leading: Offstage( //更改返回键
          offstage: false,
          child: new IconButton(
              icon: ImageIcon(AssetImage("images/ico_go_back_while.png")),
              onPressed: () {
                Navigator.maybePop(context);
              }
          ),
        ),
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],

      ),
      body: Column(
        children: <Widget>[
          //单选框
          Switch(
            value: _switchSelect,
            onChanged: (value){
              setState(() { //重新构建页面
                _switchSelect = value;
                goToNextActivity(_switchSelect, _checkBoxSelect);
              });
            },
          ),
          //复选框
          Checkbox(
            value: _checkBoxSelect,
            activeColor: Colors.blueAccent, //选中的颜色
            onChanged: (value) {
              setState(() {
                _checkBoxSelect = value;
                goToNextActivity(_switchSelect, _checkBoxSelect);
              });
            },
          ),
          Text(
              "swich:$_switchSelect，checkbox:$_checkBoxSelect"
          ),
        ],
      ),
    );
  }

  void goToNextActivity(bool switchSelect, bool checkBoxSelect) {
    if (switchSelect && checkBoxSelect) {
      Navigator.pushNamed(context, "input_text");
    }
  }

}

//输入框和表单的界面测试
class InputTextApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _InputTextState();
  }


}

class _InputTextState extends State<InputTextApp> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey= new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("输入框和表单"),
      ),
      body: Padding(padding: const EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        autovalidate: false, //是否开启自动校验
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              autofocus: true, //是否自动获取焦点
              maxLength: 11, //长度
              controller: _unameController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration( //外观样式
                labelText: "用户名",
                hintText: "用户名或手机号",
                prefixIcon: Icon(Icons.person),
              ),
              validator: (v) {
                return v
                    .trim()
                    .length == 11 ? null : "手机号格式不正确";
              },
            ),
            TextFormField(
              maxLength: 20,
              controller: _pwdController,
              decoration: InputDecoration(
                labelText: "密码（6-20位）",
                hintText: "登录密码",
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
              //校验密码
              validator: (v) {
                return v
                    .trim()
                    .length >= 6 ? null : "密码不能少于6位";
              },
            ),
            RaisedButton(
                padding: EdgeInsets.all(15.0),
                  child: Text("登录"),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  onPressed: (){

                    if ((_formKey.currentState as FormState).validate()) {
                      //通过验证
                    }
                  },
              ),
          ],
        ),

      ),),
    );
  }

}