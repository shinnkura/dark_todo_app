import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: ListView(
        children: const [
          TextField(
            decoration: InputDecoration(
              hintText: 'Title',
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Description',
            ),
            minLines: 3,
            maxLines: 5,
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: null,
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
