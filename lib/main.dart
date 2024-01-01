import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todos/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(color: Colors.black)),
        primarySwatch: Colors.blue,
        fontFamily: "Poppins",
      ),
      initialRoute: GetRoutes.login,
      getPages: GetRoutes.routes,
    );
  }
}
