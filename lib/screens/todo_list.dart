import 'dart:convert';

import 'package:crud_app/screens/add_page.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodos,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
              child: Text(
                'No Todos Found',
                style: TextStyle(fontSize: 24),
              ),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    trailing: PopupMenuButton(
                      onSelected: (Value) {
                        if (Value == 'edit') {
                          navigateTodoEditPage(item);
                        } else if (Value == 'delete') {
                          delteById(id);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ];
                      },
                    ),
                    // trailing: Checkbox(
                    //   value: item['is_completed'],
                    //   onChanged: (value) {},
                    // ),
                  ),
                );
              },
            ),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToDetail,
        label: const Text('Add Todo'),
      ),
    );
  }

  void navigateToDetail() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    // await Navigator.push(context, route);
    // fetchTodos();
    final result = await Navigator.push(context, route);
    if (result != null && result == 'update') {
      setState(() {
        fetchTodos();
      });
    }
  }

  Future<void> navigateTodoEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodos();
  }

  Future<void> navigateToaddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodos();
  }

  Future<void> delteById(String id) async {
    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErroMessage('Deletion Failed');
    }
  }

  Future<void> fetchTodos() async {
    const url = 'http://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final result = json['items'] as List<dynamic>;
      setState(
        () {
          items = result;
        },
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  void showErroMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
