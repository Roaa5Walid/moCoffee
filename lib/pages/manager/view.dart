import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../detals/view.dart';
import '../order/view.dart';

var c_teaController = TextEditingController();
var c_coffeeController = TextEditingController();
var c_tablenumController = TextEditingController();
var c_priceController = TextEditingController();


class Order {
  int id;
  String status;

  Order({required this.id, required this.status, });
}

class ManagerApp extends StatefulWidget {
  @override
  _ManagerApState createState() => _ManagerApState();
}

class _ManagerApState extends State<ManagerApp> {
  List<int>idd=[];
  List<int> teaItems = [];
  List<int> coffeeItems = [];
  List<int> tableNumbers = [];
  List<bool> removedItems = [];
  List<String> status = [];
  List<double>pricelist=[];

  var tea ;
  var coffee ;
  var price ;
  double calculateTotalPrice() {
    double totalPrice = pricelist.reduce((value, element) => value + element);
    return totalPrice;
  }
  int calculateTotaltea() {
    int totaltea = teaItems.reduce((value, element) => value + element);
    return totaltea;
  }
  int calculateTotalcoffee() {
    int totalcoffee = coffeeItems.reduce((value, element) => value + element);
    return totalcoffee;
  }
  Future<void> getData() async {
    var url = Uri.parse("http://10.0.2.2:4000/manager");
    Response response = await get(url);

    String body = response.body;

    List<dynamic> list1 = json.decode(body);
    //List<dynamic> list2 = json.decode(body);
    print(list1);

    setState(() {
      for (int i = 0; i < list1.length; i++) {
        idd.add(list1[i]["id"]);
        teaItems.add(list1[i]["tea"]);
        coffeeItems.add(list1[i]["cofee"]);
        tableNumbers.add(list1[i]["tablenumber"]);
        pricelist.add(list1[i]["price"].toDouble());
        removedItems.add(false);
        status.add(" ");
      }
    });

    print(list1);
  }

  void addOrder(Order order) {
    if (!idd.contains(order.id)) {
      setState(() {
        idd.add(order.id);
        teaItems.add(order.id);
        coffeeItems.add(order.id);
        tableNumbers.add(order.id);
        pricelist.add(order.id as double);
        removedItems.add(false);
        status.add("");
      });
    }
  }
/*
  Future<void> updateOrderStatus(int index) async {
    final String baseUrl = "http://localhost:4000/orders";
    try {
      if (index >= 0 && index < teaItems.length) {
        int id = index >= 0 && index < teaItems.length ? index + 1 : 0;
        setState(() {
          status[index] = "محذوف";
        });

        String url = "$baseUrl/$id";
        Map<String, String> headers = {
          'Content-Type': 'application/json',
        };
        Map<String, dynamic> requestBody = {
          'status': "محذوف",
        };

        await http
            .patch(Uri.parse(url), headers: headers, body: json.encode(requestBody))
            .then((response) {
          if (response.statusCode == 200) {
            print("تم تحديث حالة الطلب بنجاح");
          } else {
            print("حدث خطأ أثناء تحديث حالة الطلب");
          }
        }).catchError((error) {
          print("حدث خطأ أثناء الاتصال بالخادم أو التعامل مع البيانات: $error");
        });
      }
    } catch (error) {
      print("حدث خطأ أثناء تنفيذ الكود: $error");
    }
  }

 */

  Future<void> removeOrder(int index) async {
    final String baseUrl = "http://10.0.2.2:4000/Manager";
    try {
      if (index >= 0 && index < idd.length) {
        final int id = idd[index]; // الحصول على معرّف الطلب الفعلي

        setState(() {
          teaItems.removeAt(index);
          coffeeItems.removeAt(index);
          tableNumbers.removeAt(index);
          pricelist.removeAt(index);
          removedItems[index] = true;
          status[index] = "done";
        });

        String url = "$baseUrl/$id";
        http.Response response = await http.delete(Uri.parse(url));
        if (response.statusCode == 200) {
          // تم الحذف بنجاح
          // يمكنك تحديث حالة الخادم هنا
          print("تم حذف الطلب بنجاح");
        } else {
          // حدث خطأ أثناء الحذف
          print("حدث خطأ أثناء حذف الطلب");
        }
      }
    } catch (error) {
      // حدث خطأ آخر أثناء الاتصال بالخادم أو التعامل مع البيانات
      print("حدث خطأ أثناء الاتصال بالخادم أو التعامل مع البيانات: $error");
    }
  }

  Future<void> _addData() async {
    var url = Uri.parse("http://10.0.2.2:4000/day");
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"teaTotal": "$tea",' ' "cofeeTotal": "$coffee",'' "priceTotal": "$price()"}';
    // إجراء طلب POST
    Response response = await post(url, headers: headers, body: json);
    // التحقق من رمز الحالة للاستجابة
    int statusCode = response.statusCode;
    // يعيد هذا الطلب معرف العنصر الجديد المضاف في الجسم
    String body1 = response.body;
    var data = jsonDecode(body1);
    print(data);
    var res = data["code"];

    if (res == null) {}
  }
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Manager'),
        backgroundColor: Color(0xff1e81b0),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Monitoring'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Chif App'),
              onTap: (
                  ) {
    Navigator.of(context).push(
    MaterialPageRoute(
    builder: (context) => ChefApp()),
    );
                // اتخذ الإجراء المناسب عند النقر على العنصر الأول
              },
            ),
            ListTile(
              title: Text('Order App'),
              onTap: () {
                // اتخذ الإجراء المناسب عند النقر على العنصر الثاني
                Navigator.of(context).push(
                MaterialPageRoute(
    builder: (context) => OrderPage()
                ),
    );
              },
            ),
            // إضافة المزيد من عناصر القائمة حسب الحاجة
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Orders',
              style: TextStyle(fontSize: 20),
            ),
          ),

          GestureDetector(
            child: Text("done",style: TextStyle(fontSize: 20,color: Color(0xff38b0d2),),),
            onTap: (){
              setState(() {
               tea = calculateTotaltea();
                coffee = calculateTotalcoffee();
                price = calculateTotalPrice();

                _addData();
              });
            },
          ),
         Center(
           child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
              'إجمالي السعر:'+'${calculateTotalPrice()}',
              style: TextStyle(fontSize: 20),
              ),
            ),
         ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'إجمالي الشاي:'+'${calculateTotaltea()}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'إجمالي القهوة:'+'${calculateTotalcoffee()}',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: teaItems.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OrdersBox(
                        tea: teaItems[index],
                        coffee: coffeeItems[index],
                        tableNumber: tableNumbers[index],
                        price: pricelist[index],
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          removeOrder(index);
                        },

                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrdersBox extends StatelessWidget {
  final int tea;
  final int coffee;
  final int tableNumber;
  final double price;

  OrdersBox({
    required this.tea,
    required this.coffee,
    required this.tableNumber,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width:MediaQuery.of(context).size.width*0.7,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 9,
            spreadRadius: 7,
            color: Colors.grey.withOpacity(0.6),
            offset: Offset(5, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  bottom: 5,
                  top: 8,
                ),
                child: Text("Table Number:  "
                    "$tableNumber",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff38b0d2),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                  bottom: 20,
                ),
                child: Text(
                  "tea: $tea, coffee: $coffee price : $price",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}