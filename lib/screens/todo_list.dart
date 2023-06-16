import 'package:crud_app/screens/add_page.dart';
import 'package:crud_app/services/todo_service.dart';
import 'package:crud_app/utils/snackbar_helper.dart';
import 'package:crud_app/widget/todo_card.dart';
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
                // final id = item['_id'] as String;
                return TodoCard(
                  index: index,
                  item: item,
                  delteById: delteById,
                  navigateTodoEditPage: navigateTodoEditPage,
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
      showErroMessage(context, message: 'Deletion Failed');
    }
  }

  Future<void> fetchTodos() async {
    final response = await TodoService.fetchTodos();
    if (response != null) {
      setState(
        () {
          items = response;
        },
      );
    } else {
      showErroMessage(context, message: 'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }
}
