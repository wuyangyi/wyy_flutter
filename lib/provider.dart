import 'package:flutter/material.dart';
import 'package:wyy_flutter/provider_util.dart';
//跨组件数据共享
//购物车实例

//商品信息类
class Item {
  Item(this.id, this.price, this.count, this.image, this.name, this.desc);
  
  int id; //id

  double price; //商品价格
  int count;  //选择的数量

  String image; //图片地址
  String name; //商品名称
  String desc; //商品简介
}

//数据处理
class CartModel extends ChangeNotifier{
  //保存购物车商品列表
  final List<Item> _items = [];

  //购物车里的商品信息
  List<Item> get items => _items;

  //获得购物车中商品的总价
  double get totalPrice {
    return _items.fold(0, (value, item) => value + item.count * item.price);
  }

  //添加商品到购物车
  void add(Item item) {
    _items.add(item);
    // 通知监听器（订阅者），重新构建InheritedProvider， 更新状态。
    notifyListeners();
  }
}

//所有商品展示页面
class StoreApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new StoreState();
  }
  
}

class StoreState extends State<StoreApp> {
  static const loadingTag = -1; //标记尾部的id
  var _item = <Item>[Item(loadingTag, null, null, null, null, null)];
  int position = 0;

  @override
  void initState() {
    super.initState();
    _retrieveData();
  }

  void _retrieveData() {
    Future.delayed(Duration(seconds: 2)).then((e) {
      List<Item> item = [];
      item.add(Item(1+position, 1000.0+position, 0, "https://img.alicdn.com/imgextra/i4/2838892713/O1CN0183jqJa1Vub4mVZ6nU_!!2838892713.jpg_430x430q90.jpg", "华为 畅想9plus", "Huawei/华为 畅享9 Plus 全面屏超清大屏四摄学生智能手机畅享9p"));
      item.add(Item(2+position, 1000.0+position, 0, "https://img.alicdn.com/imgextra/i4/1714128138/O1CN01VT0DSU29zFjYLbogg_!!1714128138.jpg_430x430q90.jpghttps://img.alicdn.com/imgextra/i4/1714128138/O1CN01VT0DSU29zFjYLbogg_!!1714128138.jpg_430x430q90.jpg", "小米 红米Note7", "【价保88会员节 4+64G到手999元】Xiaomi/小米Redmi红米Note7大屏智能指纹手机9官方旗舰k20正品学生note7pro"));
      item.add(Item(3+position, 1000.0+position, 0, "https://img.alicdn.com/imgextra/i3/883737303/O1CN014H5vJO23op1E9P6e9_!!883737303.jpg_430x430q90.jpg", "vivo", "【新配色上市减100】vivo Z5x极点全面屏高通骁龙710大电池智能手机官方正品游戏手机新品vivoz5x限量版 z3x"));
      item.add(Item(4+position, 10.0+position, 0, "https://img11.360buyimg.com/n1/jfs/t3196/54/5030881272/255466/1dbe299f/586373b2Ncea40aea.jpg", "聪慧有灵性的女子", "聪慧有灵性的女子：张爱玲+林徽因+三毛（套装全3册）"));
      item.add(Item(5+position, 10.0+position, 0, "https://img10.360buyimg.com/n1/jfs/t1/58664/12/5659/621810/5d357f5cE4ad69fd6/42b1713a5c2f8019.jpg", "彗星年代", "彗星年代：1918，世界重启时"));
      item.add(Item(6+position, 10.0+position, 0, "https://img13.360buyimg.com/n1/jfs/t1/35890/5/13814/312857/5d19b120E2cf8cd78/cae92351678bf18b.jpg", "为什么", "为什么（关于因果关系的新科学）"));
      item.add(Item(7+position, 100.0+position, 0, "http://img.gank.io/4b63f35c-f631-417b-9d88-916e70901634", "干货1", "潇湘剑雨"));
      item.add(Item(8+position, 100.0+position, 0, "https://img13.360buyimg.com/n1/jfs/t1/56061/27/5282/305914/5d30411bE00780206/f327ccad7f20cfa7.jpg", "设计之书", "设计之书（京东全渠道专享）"));
      item.add(Item(9+position, 100.0+position, 0, "https://img14.360buyimg.com/n1/jfs/t1/66427/2/1342/271819/5cf884b3E0b2f37ad/2a57afa24b34bdae.jpg", "文化苦旅", "文化苦旅 新版"));
      item.add(Item(10+position, 100.0+position, 0, "https://img11.360buyimg.com/n1/jfs/t1/39945/27/8912/105811/5d01c1c9E0ea96744/d01abcbf20e31e40.jpg", "治国理政新实践", "治国理政新实践：习近平总书记重要活动通讯选（二）"));
      position += 10;
      _item.insertAll(_item.length - 1, item);
      setState(() {
        //重新构建列表
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("商品列表"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return new ShoppingCartApp();
          }));
        },
        child: ChangeNotifierProvider<CartModel>(
          data: CartModel(),
          child: Consumer<CartModel>(
            builder: (context, cart) => Text("￥${cart.totalPrice}"),
          ),
        ),
      ),
      body: ChangeNotifierProvider<CartModel>(
        data: CartModel(),
        child: ListView.separated(
            physics: new BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              //如果到了末尾
              if (_item[index].id == loadingTag) {
                if (_item.length - 1 < 20) { //不足100条，继续加载
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
                    child: Consumer<CartModel>(
                      builder: (context, cart) => Text("没有更多了${cart.totalPrice}", style: TextStyle(color: Colors.grey),),
                    ),
                  );
                }
              }
              return Container(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Image.network(
                      _item[index].image,
                      width: 80.0,
                      height: 80.0,
                    ),
                    Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 10.0),
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  _item[index].name,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Color(0xFF363951),
                                    fontSize: 17.0,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "${_item[index].price}元",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child:Text(
                                  _item[index].desc,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Color(0xFF6C7582),
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                    Builder(builder: (context) {
                      print("budier");
                      return Center(
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            //给购物车中添加商品，添加后总价会更新
                            ChangeNotifierProvider.of<CartModel>(context, listen: false).add(Item(_item[index].id, _item[index].price, 1, _item[index].image, _item[index].name, _item[index].desc));
                          },
                        ),
                      );
                    },)
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(height: .0);
            },
            itemCount: _item.length),
      ),
    );
  }
  
}
//购物车
class ShoppingCartApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ShoppingCartState();
  }

}

class ShoppingCartState extends State<ShoppingCartApp> {
  List<Item> data = <Item>[Item(-1, 0, 0, "", "", "")]; //购物车的商品

  @override
  void initState() {
    super.initState();
//    _initData();
  }

//  void _initData() {
//    var cart = ChangeNotifierProvider.of<CartModel>(context);
//    data.insertAll(data.length - 1, cart.items);
//    price = cart.totalPrice;
//    setState(() {
//
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("购物车"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute(builder: (context) {
            return new StoreApp();
          }));
        },
        child: Icon(Icons.store),
      ),
      body: ChangeNotifierProvider<CartModel>(
        data: CartModel(),
        child: Builder(
          builder: (context) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: Builder(
                    builder: (context){
                  var cart = ChangeNotifierProvider.of<CartModel>(context);
                  data.insertAll(data.length - 1, cart.items);
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          if (data[index].id == -1) {
                            return Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(15.0),
                              child: Text(data.length == 1 ? "暂无商品！赶快去收藏看看吧" : "没有更多了${ChangeNotifierProvider.of<CartModel>(context).totalPrice}", style: TextStyle(color: Colors.grey),),
                            );
                          }
                          return Container(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: <Widget>[
                                Image.network(
                                  data[index].image,
                                  width: 80.0,
                                  height: 80.0,
                                ),
                                Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            data[index].name,
                                            style: TextStyle(
                                              color: Color(0xFF363951),
                                              fontSize: 17.0,
                                            ),
                                          ),
                                          Text(
                                            "${data[index].price}元",
                                            style: TextStyle(
                                              color: Color(0xFF6C7582),
                                              fontSize: 15.0,
                                            ),
                                          ),
                                          Text(
                                            "数量：${data[index].count}",
                                            style: TextStyle(
                                              color: Color(0xFF6C7582),
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ),
                                Text(
                                  "￥ ${data[index].count}",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(height: .0);
                        },
                        itemCount: data == null ? 0 : data.length,
                      );
                    },
                  ),
                ),
                Container(
                  child: Text("总价格${ChangeNotifierProvider.of<CartModel>(context).totalPrice}", style: TextStyle(color: Colors.black),),
                ),

              ],
            );
          },
        ),
      ),
    );
  }

}

