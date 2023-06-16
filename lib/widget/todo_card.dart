import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateTodoEditPage;
  final Function(String) delteById;
  const TodoCard({
    super.key,
    required this.index,
    required this.item,
    required this.navigateTodoEditPage,
    required this.delteById,
  });

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(
          // ignore: non_constant_identifier_names
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
      ),
    );
  }
}
