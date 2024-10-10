import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/routes/app_routes.dart';
import 'package:todo_app/utills/app_color.dart';
import 'package:todo_app/view/helper_widget/custom_button.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TaskController taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    taskController.checkForDueTasks();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 76,
                  child: CustomElevatedButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.home);
                    },
                    title: 'A To-Do List',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 76,
                  child: CustomElevatedButton(
                    color: AppColors.secondaryColor,
                    onPressed: () {
                      Get.toNamed(AppRoutes.sensor);
                    },
                    title: 'Sensor Tracking',
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
