import 'package:flutter/material.dart';
import 'package:mo/pages/bottonNavigation/view.dart';
import 'package:mo/pages/detals/view.dart';
import 'package:mo/pages/manager/view.dart';
import 'package:mo/pages/order/view.dart';


void main() {
  runApp(MyApp());
}
///////mor
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainNav(),
    );
  }
}