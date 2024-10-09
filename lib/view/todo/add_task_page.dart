import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/view/todo/task_option.dart';

class AddTaskPage extends StatelessWidget {
  final int listId; // Accept the listId as a parameter
  final taskController = Get.put(TaskController());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final Rx<DateTime> selectedDueDate = DateTime.now().obs;
  final RxBool isInputNotEmpty = false.obs;

  AddTaskPage({super.key, required this.listId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back(); // Navigate back
          },
        ),
        title: Obx(() => Text('Tasks (${taskController.tasks.length})')),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: taskController.tasks.length,
                itemBuilder: (context, index) {
                  var task = taskController.tasks[index];
                  if (task.listId != listId) return const SizedBox.shrink();

                  return InkWell(
                    onTap: (){
                      Get.to(() => TaskOptionsPage(taskId: task.id!, dueDate: task.dueDate));
                    },
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isCompleted.value,
                        onChanged: (value) {
                          taskController.toggleTaskCompletion(index);
                        },
                      ),
                      title: Text(task.title,
                          style: TextStyle(
                              decoration: task.isCompleted.value
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none)),
                      subtitle: Text(DateFormat.yMMMd().format(task.dueDate)),
                    /*                    trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          taskController.removeTask(task.id!);
                        },
                      ),*/
                    ),
                  );
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Task Title Input Field
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: titleController,
                        onChanged: (value) {
                          isInputNotEmpty.value = value.isNotEmpty; // Track input changes
                        },
                        decoration: const InputDecoration(
                          hintText: "Task title",
                          border: InputBorder.none, // Transparent border
                        ),
                      ),
                    ),
                    // The icon that changes color based on input
                    Obx(
                          () => Icon(
                        Icons.check_circle,
                        color: isInputNotEmpty.value ? Colors.teal : Colors.grey, // Changes color
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),

                // Task Details Input Field
                TextField(
                  controller: detailsController,
                  decoration: const InputDecoration(
                    hintText: "Task details",
                    border: InputBorder.none, // Transparent border
                  ),
                ),
                const SizedBox(height: 8.0),

                // Due Date Section
                Obx(
                      () => Row(
                    children: [
                      Text(
                        "Due Date: ${DateFormat.yMMMd().format(selectedDueDate.value)}",
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDueDate.value,
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            selectedDueDate.value = pickedDate;
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),

                // Add Task Button
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Add Task"),
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        detailsController.text.isNotEmpty) {
                      TaskModel task = TaskModel(
                        title: titleController.text,
                        details: detailsController.text,
                        dueDate: selectedDueDate.value,
                        listId: listId, // Save the listId
                      );
                      taskController.addTask(task);
                      titleController.clear();
                      detailsController.clear();
                      isInputNotEmpty.value = false; // Reset icon color after adding task
                    } else {
                      Get.snackbar("Error", "All fields are required",
                          snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
