import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/task_controller.dart';

class TaskOptionsPage extends StatelessWidget {
  final int taskId;
  final DateTime dueDate;

  TaskOptionsPage({required this.taskId, required this.dueDate});

  final TaskController taskController = Get.find();
  final TextEditingController noteController = TextEditingController();
  final Rx<DateTime> selectedDueDate = DateTime.now().obs;

  @override
  Widget build(BuildContext context) {
    selectedDueDate.value = dueDate; // Initialize with the existing due date

    return Scaffold(
      appBar: AppBar(
        title: Text('Task $taskId'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back(); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Remind me option (Placeholder for now)
            ListTile(
              leading: Icon(Icons.notifications_none),
              title: Text('Remind Me'),
            ),
            const SizedBox(height: 16),

            // Due Date section
            ListTile(
              leading: Icon(
                Icons.calendar_today,
                color: dueDate.isBefore(DateTime.now()) ? Colors.red : Colors.teal,
              ),
              title: Obx(() => Text('Due ${DateFormat.yMMMd().format(selectedDueDate.value)}')),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDueDate.value,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  selectedDueDate.value = pickedDate;
                  taskController.updateDueDate(taskId, pickedDate); // Update due date in DB
                }
              },
            ),
            const SizedBox(height: 16),

            // Add Note section
            ListTile(
              leading: const Icon(Icons.note_add_outlined),
              title: const Text('Add Note'),
              onTap: () {
                showNoteDialog(context); // Open note input dialog
              },
            ),
            Obx(
                  () => taskController.getTaskById(taskId).details != null
                  ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "Note: ${taskController.getTaskById(taskId).details}",
                  style: const TextStyle(color: Colors.grey),
                ),
              )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 16),

            // Delete button
            const Spacer(),
            GestureDetector(
              onTap: () {
                showDeleteConfirmation(context);
              },
              child: const Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show confirmation dialog
  void showDeleteConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Task "$taskId" will be permanently deleted.',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  taskController.removeTask(taskId); // Call delete task method
                  Get.back(); // Close modal
                  Get.back(); // Navigate back after deletion
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Delete Task', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Get.back(); // Close modal
                },
                child: const Text('Cancel', style: TextStyle(color: Colors.teal)),
              ),
            ],
          ),
        );
      },
    );
  }

  // Method to show note input dialog
  void showNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Note"),
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
                taskController.updateDescription(taskId, noteController.text); // Update description in DB
                Get.back(); // Close dialog
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog without saving
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}
