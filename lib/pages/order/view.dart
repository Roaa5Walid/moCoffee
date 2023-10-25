import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../detals/view.dart'; // استيراد حزمة shared_preferences


var c_teaController = TextEditingController();
var c_coffeeController = TextEditingController();
var c_tablenumController = TextEditingController();
var c_priceController = TextEditingController();


class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  SharedPreferences? _prefs; // متغير لتخزين مرجع الـ SharedPreferences

  @override
  void initState() {
    super.initState();
    _initPrefs(); // استدعاء الدالة لتهيئة SharedPreferences
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance(); // الحصول على مرجع الـ SharedPreferences
    _loadData(); // استدعاء الدالة لاسترداد البيانات المحفوظة
  }

  void _loadData() {
    setState(() {
      // استرداد البيانات المحفوظة وتعيينها للمتغيرات
      teaCount = _prefs!.getInt('teaCount') ?? 0;
      coffeeCount = _prefs!.getInt('coffeeCount') ?? 0;
      tableNumber = _prefs!.getInt('tableNumber') ?? 0;
      c_teaController.text = teaCount.toString();
      c_coffeeController.text = coffeeCount.toString();
      c_tablenumController.text = tableNumber.toString();
      c_priceController.text = price.toString();
    });
  }

  void _saveData() {
    // حفظ البيانات في SharedPreferences
    _prefs!.setInt('teaCount', teaCount);
    _prefs!.setInt('coffeeCount', coffeeCount);
    _prefs!.setInt('tableNumber', tableNumber);
    c_priceController.text = price.toString();
  }

  Future<void> _clearData() async {
    // حذف البيانات من SharedPreferences
    await _prefs!.clear();
    _loadData(); // استدعاء الدالة لاسترداد البيانات بعد الحذف
  }

  Future<void> _addData() async {
    var url = Uri.parse("http://10.0.2.2:4000/add");
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"tea": "$teaCount",' ' "cofee": "$coffeeCount",' ' "tablenumber": "$tableNumber",' ' "price": "$price",' ' "status": "طلب"}';
    price = calculateTotalCost(); // قم بحساب السعر الإجمالي
    _prefs!.setDouble('price', price); // حفظ القيمة في SharedPreferences
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

  List<Order> orders = [];
  int teaCount = 0;
  int coffeeCount = 0;
  double teaPrice = 500;
  double coffeePrice = 2000;
  int tableNumber = 0;
  double price=0;


  void incrementTea() {
    setState(() {
      teaCount++;
      c_teaController.text = teaCount.toString();
      _saveData(); // حفظ البيانات بعد التعديل
    });
  }

  void decrementTea() {
    setState(() {
      if (teaCount > 0) {
        teaCount--;
        c_teaController.text = teaCount.toString();
        _saveData(); // حفظ البيانات بعد التعديل
      }
    });
  }

  void incrementCoffee() {
    setState(() {
      coffeeCount++;
      c_coffeeController.text = coffeeCount.toString();
      _saveData(); // حفظ البيانات بعد التعديل
    });
  }

  void decrementCoffee() {
    setState(() {
      if (coffeeCount > 0) {
        coffeeCount--;
        c_coffeeController.text = coffeeCount.toString();
        _saveData(); // حفظ البيانات بعد التعديل
      }
    });
  }
  void incrementTable() {
    setState(() {
      tableNumber++;
      c_tablenumController.text=tableNumber.toString();
      _saveData();
    });
  }

  void decrementTable() {
    setState(() {
      if (tableNumber > 0) {
        tableNumber--;
        c_tablenumController.text=tableNumber.toString();
        _saveData();
      }
    });
  }

  double calculateTotalCost() {
    return (teaCount * teaPrice) + (coffeeCount * coffeePrice);
    _saveData();
  }

  void setTableNumber(String value) {
    setState(() {
      tableNumber = int.parse(value);
      c_tablenumController.text=tableNumber.toString();
      _saveData(); // حفظ البيانات بعد التعديل
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Page'),
        backgroundColor: Color(0xff1e81b0),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tea',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: decrementTea,
                  ),
                  Text(
                    teaCount.toString(),
                    style: TextStyle(fontSize: 18),
                  ),

                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: incrementTea,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Coffee',
                style: TextStyle(fontSize: 20),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: decrementCoffee,
                  ),
                  Text(
                    coffeeCount.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: incrementCoffee,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Table Number',
                style: TextStyle(fontSize: 20),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: decrementTable,
                  ),
                  Text(
                    tableNumber.toString(),
                    style: TextStyle(fontSize: 18),
                  ),

                  //Text(tableNumber.toString(), style: TextStyle(fontSize: 18)),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: incrementTable,
                  ),
                ],
              ),

              SizedBox(height: 20),
              Text(
                'Total Cost: \$${calculateTotalCost().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    int? parsedTeaCount = int.tryParse(c_teaController.text);
                    int? parsedCoffeeCount = int.tryParse(c_coffeeController.text);
                    int? parsedTableNumber = int.tryParse(c_tablenumController.text);

                    if (parsedTeaCount != null &&
                        parsedCoffeeCount != null &&
                        parsedTableNumber != null) {
                      teaCount = parsedTeaCount;
                      coffeeCount = parsedCoffeeCount;
                      tableNumber = parsedTableNumber;
                      price = calculateTotalCost(); // تحديث السعر باستخدام الدالة المناسبة
                      _addData();
                    }
                  });
                },
                child: Text('Add order'),
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _clearData,
                child: const Text('Clear Data'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ChefApp()),
                  );                },
                child: const Text('Details Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Order {
  final int tea;
  final int coffee;
  final int tableNumber;

  Order({
    required this.tea,
    required this.coffee,
    required this.tableNumber,
  });
}