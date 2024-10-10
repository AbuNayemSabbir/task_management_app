import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/utills/app_color.dart';
import 'package:todo_app/view/helper_widget/helper_utills.dart';
import 'package:todo_app/view/todo/task_option.dart';

class TaskPage extends StatelessWidget {
  TaskPage({super.key});

  final TextEditingController _titleController = TextEditingController();
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController taskTitleController = TextEditingController();
  final TextEditingController taskDetailsController = TextEditingController();
  final Rx<DateTime> selectedDueDate = DateTime.now().obs;
  final RxBool isInputNotEmpty = false.obs;
  final Rx<int?> listId = (Get.arguments as int?).obs;
  final RxBool isTitleSaved = false.obs;
  final RxBool showTaskInput = false.obs;
  final RxBool isTitleEntered = false.obs;

  @override
  Widget build(BuildContext context) {
    _titleController.addListener(() {
      isTitleEntered.value = _titleController.text.isNotEmpty;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lists'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Obx(() {
              if (listId.value != null) {
                return Text(
                  _taskController.getListTitle(listId.value!),
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                );
              } else {
                return Obx(
                  () => isTitleSaved.value
                      ? Text(
                          _titleController.text,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )
                      : TextField(
                          controller: _titleController,
                          style: const TextStyle(fontSize: 24),
                          decoration: const InputDecoration(
                            hintText: 'Untitled List',
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) async {
                            if (value.isNotEmpty) {
                              int newId = await _taskController.addList(value);
                              listId.value = newId;
                              isTitleSaved.value = true;
                            }
                          },
                        ),
                );
              }
            }),
          ),
          Obx(() {
            return listId.value != null || isTitleSaved.value
                ? Flexible(
                    child: Column(
                      children: [
                        Flexible(
                          child: ListView.builder(
                            itemCount: _taskController.tasks.length,
                            itemBuilder: (context, index) {
                              var task = _taskController.tasks[index];
                              if (task.listId != listId.value) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  decoration: customBoxDecoration(),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(() => TaskOptionsPage(
                                          taskId: task.id!,
                                          dueDate: task.dueDate,isCompleted:task.isCompleted.value));
                                    },
                                    child: ListTile(
                                      leading: Obx(() => Checkbox(
                                            value: task.isCompleted.value,
                                            onChanged: (value) {
                                              _taskController
                                                  .toggleTaskCompletion(index);
                                            },
                                          )),
                                      title: Text(
                                        task.title,
                                      ),
                                      subtitle: Text(
                                        DateFormat.yMMMd().format(task.dueDate),
                                        style: TextStyle(
                                            color: task.isCompleted.value
                                                ? Colors.green
                                                : null),
                                      ),
                                      trailing: Icon(Icons.star_border_rounded,
                                          color: task.isCompleted.value
                                              ? Colors.amber
                                              : null),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Task Adding Section
                        Obx(() => !showTaskInput.value
                            ? InkWell(
                                onTap: () {
                                  showTaskInput.value = true;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    decoration: customBoxDecoration(),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(2.0),
                                          decoration: const BoxDecoration(
                                            color: AppColors.primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white, // Icon color
                                          ),
                                        ),
                                        const SizedBox(width: 16.0),
                                        const Text(
                                          "Add a Task",
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black, // Text color
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                decoration: customBoxDecoration(),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: taskTitleController,
                                              onChanged: (value) {
                                                isInputNotEmpty.value =
                                                    value.isNotEmpty;
                                              },
                                              decoration: const InputDecoration(
                                                hintText: "Task title",
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                          Obx(
                                            () => Icon(
                                              Icons.check_circle,
                                              color: isInputNotEmpty.value
                                                  ? AppColors.primaryColor
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Obx(
                                        () => Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.notifications_none,
                                                color: Colors.grey,
                                              ),
                                              onPressed: () async {
                                                //todo not implemented
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.note_add_sharp),
                                              onPressed: () async {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          "Add Note"),
                                                      content: TextField(
                                                        controller:
                                                            taskDetailsController,
                                                        maxLines: 2,
                                                        // Limit the note to 2 lines
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText:
                                                              "Enter your note here",
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: const Text(
                                                              "Cancel"),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child:
                                                              const Text("Ok"),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.calendar_month_rounded),
                                              onPressed: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
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
                                            InkWell(
                                              onTap:()async{
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: selectedDueDate.value,
                                                  firstDate: DateTime(2024),
                                                  lastDate: DateTime(2101),
                                                );
                                                if (pickedDate != null) {
                                                  selectedDueDate.value = pickedDate;
                                                }
                                              },
                                              child: Text(
                                                DateFormat.yMMMd().format(
                                                    selectedDueDate.value),
                                                style: const TextStyle(
                                                    color:
                                                        AppColors.primaryColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.save),
                                        label: const Text("Save Task"),
                                        onPressed: () {
                                          if (taskTitleController
                                              .text.isNotEmpty) {
                                            TaskModel task = TaskModel(
                                              title: taskTitleController.text,
                                              details:
                                                  taskDetailsController.text,
                                              dueDate: selectedDueDate.value,
                                              listId: listId.value!,
                                            );
                                            _taskController.addTask(task);
                                            taskTitleController.clear();
                                            isInputNotEmpty.value = false;
                                            showTaskInput.value = false;
                                          } else {
                                            Get.snackbar("Error",
                                                "All fields are required",
                                                snackPosition:
                                                    SnackPosition.BOTTOM);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                      ],
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
