import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/routes/app_routes.dart';
import 'package:todo_app/utills/app_color.dart';
import 'package:todo_app/view/helper_widget/helper_utills.dart';

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
          title: Obx(() {
            final int totalIncomplete = taskController.totalIncompleteTasks;
            final int totalCompleted = taskController.totalCompletedTasks;

            return Row(
              children: [
                const CircleAvatar(
                  radius: 24.0,
                  // Profile Image Placeholder
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sabbir Ahmed',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '$totalIncomplete incomplete, $totalCompleted completed',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                // todo not implement
              },
            ),
          ],
        ),
        body: Obx(() {
          return ListView.builder(
            itemCount: taskController.lists.length,
            itemBuilder: (context, index) {
              final list = taskController.lists[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: customBoxDecoration(),
                  child: ListTile(
                    leading: const Icon(Icons.list, color: AppColors.primaryColor),
                    title: Text(list.title),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          _showDeleteConfirmation(context, taskController, list.id!);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                    onTap: () {
                      Get.toNamed(AppRoutes.task, arguments: list.id);
                    },
                  ),
                ),
              );
            },
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(AppRoutes.task);
          },
          backgroundColor: AppColors.primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, TaskController taskController, int listId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: context.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'The list "$listId" and all its tasks will be permanently deleted.',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        taskController.removeList(listId); // Call delete method
                        Get.back(); // Close modal
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        'Delete List',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: context.width,
                height: 10,
                color: const Color(0xFFF8F8F8),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () {
                    Get.back(); // Close modal
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
