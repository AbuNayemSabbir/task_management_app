import 'package:get/get.dart';
import 'package:todo_app/view/main_page.dart';
import 'package:todo_app/view/todo/add_task_page.dart';
import 'package:todo_app/view/todo/home.dart';
import 'package:todo_app/view/todo/splash_screen.dart';
import 'package:todo_app/view/todo/task_page.dart';


class AppRoutes {
  static const String initial = '/';
  static const String main = '/main';
  static const String home = '/home';
  static const String splash = '/splash';
  static const String addTask = '/addTask';
  static const String task = '/task';


  static final List<GetPage> routes = [
    GetPage(name: initial, page: () => const MainPage()),
    GetPage(name: home, page: () =>  const HomePage()),
    GetPage(name: splash, page: () =>  const SplashScreen()),
    GetPage(name: task, page: () =>   TaskPage()),

  ];
}