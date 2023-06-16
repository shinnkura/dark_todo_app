import 'dart:convert';

class TodoService {
  static get http => null;

  static Object? get body => null;

  static Future<bool> deleteById(String id) async {
    final url = Uri.parse('http://localhost:3000/api/todos/$id');
    final uri = Uri.parse(url as String);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> fetchTodos() async {
    final url = Uri.parse('http://localhost:3000/api/todos');
    final uri = Uri.parse(url as String);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }

  static Future<bool> updateTodo(
    String id,
    Map body,
  ) async {
    final url = Uri.parse('http://localhost:3000/api/todos/$id');
    final uri = Uri.parse(url as String);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  static Future<bool> addTodo(Map body) async {
    const url = 'http://localhost:3000/api/todos';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 201;
  }
}
