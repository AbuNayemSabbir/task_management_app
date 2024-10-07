import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/routes/app_routes.dart';
import 'package:todo_app/utills/theme.dart';
import 'package:todo_app/view/main_page.dart';


void main() async {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      theme: ThemeClass.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.routes,
    );
  }
}
