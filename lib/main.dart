import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/routes/app_routes.dart';
import 'package:todo_app/utills/theme.dart';
import 'package:todo_app/view/main_page.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(TaskController());
  initializeNotifications();
  requestPermission();
  runApp(const MyApp());
}
Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');  // Set the app icon

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}
Future<void> requestPermission() async {
  // Request iOS notification permissions
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Request Android notification permissions (for Android 13+)
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,

    ));
    return  SafeArea(
      child: GetMaterialApp(
        theme: ThemeClass.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.initial,
        getPages: AppRoutes.routes,
      ),
    );
  }
}
