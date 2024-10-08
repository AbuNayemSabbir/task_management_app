import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/routes/app_routes.dart';
import 'package:todo_app/utills/app_utills.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.put(TaskController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Row(
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 24.0,
                // backgroundImage: NetworkImage(
                //   'https://example.com/profile.jpg',
                // ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Task Stats
                  Text(
                    'Sabbir Ahmed',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '5 incomplete, 5 completed',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            // Search Icon
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                // Add search functionality
              },
            ),
          ],
        ),
        body: Obx(() {
          // Use Obx to reactively rebuild the UI when the lists change
          return ListView.builder(
            itemCount: taskController.lists.length,
            itemBuilder: (context, index) {
              final listTitle = taskController.lists[index].title; // Get the title
              return ListTile(
                title: Text(listTitle),
                onTap: () {
                  // Handle list tap, e.g., navigate to the task page
                  Get.toNamed(AppRoutes.task, arguments: taskController.lists[index].id);
                },
              );
            },
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(AppRoutes.task);
          },
          backgroundColor: AppUTills.primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),

      ),
    );
  }
}
