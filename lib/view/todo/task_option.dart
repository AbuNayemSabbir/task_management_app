import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/utills/app_color.dart';
import 'package:todo_app/view/helper_widget/helper_utills.dart';

class TaskOptionsPage extends StatefulWidget {
  final int taskId;
  final DateTime dueDate;
  final bool isCompleted;

  TaskOptionsPage({super.key, required this.taskId, required this.dueDate, required this.isCompleted});

  @override
  State<TaskOptionsPage> createState() => _TaskOptionsPageState();
}

class _TaskOptionsPageState extends State<TaskOptionsPage> {
  final TaskController taskController = Get.find();

  final TextEditingController noteController = TextEditingController();

  final Rx<DateTime> selectedDueDate = DateTime.now().obs;

  @override
  void initState() {
    super.initState();
    taskController.checkForDueTasks();
  }
  @override
  Widget build(BuildContext context) {
    selectedDueDate.value = widget.dueDate;

    return Scaffold(
      appBar: AppBar(
        title: Text('Task ${widget.taskId}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const ListTile(
                        leading: Icon(Icons.notifications_none),
                        title: Text('Remind Me'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.calendar_month_rounded,
                          color: widget.dueDate.isBefore(DateTime.now()) ? widget.isCompleted?Colors.green:Colors.red : AppColors.primaryColor,
                        ),
                        title: Obx(() => Text('Due ${DateFormat.yMMMd().format(selectedDueDate.value)}',style: TextStyle(color: widget.dueDate.isBefore(DateTime.now()) ?widget.isCompleted?Colors.green:Colors.red : AppColors.primaryColor),),),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDueDate.value,
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            selectedDueDate.value = pickedDate;
                            taskController.updateDueDate(widget.taskId, pickedDate);
                          }
                        },
                      ),

                      ListTile(
                        leading: const Icon(Icons.note_outlined),
                        title: const Text('Add Note'),
                        onTap: () {
                          showNoteDialog(context);
                        },
                      ),
                      Obx(
                            () => taskController.getTaskById(widget.taskId).details != ''
                            ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            width: context.width,
                            decoration: customBoxDecoration(),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Note:",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(taskController.getTaskById(widget.taskId).details,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                            : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 16),

                      const Spacer(),
                      ListTile(
                        leading: const Icon(Icons.delete_outline, color: Colors.red),
                        title:const Text('Delete', style: TextStyle(color: Colors.red)),
                        onTap: () {
                          showDeleteConfirmation(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Method to show confirmation dialog
  void showDeleteConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
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
                      'Task "${widget.taskId}" will be permanently deleted.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        taskController.removeTask(widget.taskId); // Call delete task method
                        Get.back(); // Close modal
                        Get.back(); // Navigate back after deletion
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        'Delete Task',
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
              // Divider
              Container(
                width: double.infinity,
                height: 12,
                color: const Color(0xFFF8F8F8),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () {
                    Get.back(); // Close modal
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  void showNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Note"),
          content: TextField(
            controller: noteController,
            maxLines: 2, // Limit the note to 2 lines
            decoration: const InputDecoration(
              hintText: "Enter your note here",
              border: InputBorder.none,
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                taskController.updateDescription(widget.taskId, noteController.text);
                Get.back();
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
