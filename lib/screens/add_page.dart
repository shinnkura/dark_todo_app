import 'package:crud_app/services/todo_service.dart';
import 'package:flutter/material.dart';

import '../utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'nEdit Todo' : 'Add Todo',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            minLines: 3,
            maxLines: 5,
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: submitData,
            child: Text(
              isEdit ? 'Update' : 'Add',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateDate() async {
    final todo = widget.todo;
    if (todo == null) {
      print('You can not update without todo data');
      return;
    }
    final id = todo['_id'];

    final isSuccess = await TodoService.updateTodo(id, body);

    if (isSuccess) {
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, message: 'Updated Successfully');
    } else {
      // ignore: use_build_context_synchronously
      showErroMessage(context, message: 'Update Error');
    }
  }

  Future<void> submitData() async {
    final isSuccess = await TodoService.addTodo(body);

    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, message: 'Creation Success');
    } else {
      // ignore: use_build_context_synchronously
      showErroMessage(context, message: 'Creation Error');
    }
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false,
    };
  }
}
