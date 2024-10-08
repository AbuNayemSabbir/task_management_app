import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/routes/app_routes.dart';
import 'package:todo_app/utills/app_utills.dart';
import 'package:todo_app/view/helper_widget/custom_button.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});
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
                      Get.toNamed(AppRoutes.splash);
                    },
                    title: 'A To-Do List',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 76,
                  child: CustomElevatedButton(
                    color: AppUTills.secondaryColor,
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
