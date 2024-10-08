import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/view/todo/add_task_page.dart';

class TaskPage extends StatelessWidget {
  TaskPage({super.key});

  final TextEditingController _titleController = TextEditingController();
  final TaskController _taskController = Get.put(TaskController());
  final int? listId = Get.arguments;
  final RxBool isTitleSaved = false.obs;
  int? _listId;
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (listId != null) ...[
            Text(
              'Title: ${_taskController.getListTitle(listId!)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton(
                      onPressed: () {
                        if (_listId != null) {
                          Get.to(() => AddTaskPage(
                              listId: _listId!));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Add Task',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    )
          ] else ...[
            Obx(
              () => isTitleSaved.value
                  ? Text(
                      'Title: ${_titleController.text}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    )
                  : TextField(
                      controller: _titleController,
                      style: const TextStyle(fontSize: 24),
                      decoration: const InputDecoration(
                        hintText: 'Untitled List()',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) async {
                        if (value.isNotEmpty) {
                          _listId = await _taskController.addList(value);
                          isTitleSaved.value = true;
                        }
                      },
                    ),
            ),
            const SizedBox(height: 20),
            const Spacer(),
            Obx(
              () => isTitleEntered.value
                  ? isTitleSaved.value
                      ? ElevatedButton(
                          onPressed: () {
                            if (_listId != null) {
                              Get.to(() => AddTaskPage(listId: _listId!));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            'Add Task',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            if (_titleController.text.isNotEmpty) {
                              _listId = await _taskController.addList(_titleController.text);
                              isTitleSaved.value = true;
                            }
                          },
                          child: const Text('Save Title'),
                        )
                  : const SizedBox.shrink(),
            )
          ],
        ]),
      ),
    );
  }
}
