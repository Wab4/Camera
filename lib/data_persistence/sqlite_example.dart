import 'db_helper.dart';
import 'todo.dart';
import 'package:flutter/material.dart';

class MySQLiteExample extends StatefulWidget {
  const MySQLiteExample({super.key});

  @override
  State<MySQLiteExample> createState() => _MySQLiteExampleState();
}

class _MySQLiteExampleState extends State<MySQLiteExample> {
  final _controller = TextEditingController();
  List<Todo> _todos = [];
  Todo? _editingTodo;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await DBHelper.getTodos();
    setState(() => _todos = todos);
  }

  Future<void> _saveTodo() async {
    if (_controller.text.trim().isEmpty) return;
    if (_editingTodo != null) {
      await DBHelper.updateTodo(
        Todo(id: _editingTodo!.id, title: _controller.text.trim()),
      );
      _editingTodo = null;
    } else {
      await DBHelper.insertTodo(Todo(title: _controller.text.trim()));
    }
    _controller.clear();
    _loadTodos();
  }

  Future<void> _deleteTodo(int id) async {
    await DBHelper.deleteTodo(id);
    _loadTodos();
  }

  void _editTodo(Todo todo) {
    setState(() {
      _controller.text = todo.title;
      _editingTodo = todo;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingTodo != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do-List"),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.task_alt),
                        labelText: isEditing ? "Edit Todo" : "Todo Baru",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(isEditing ? Icons.check : Icons.add),
                            label: Text(isEditing ? "Update" : "Tambah"),
                            onPressed: _saveTodo,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        if (isEditing)
                          const SizedBox(width: 12),
                        if (isEditing)
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.cancel),
                              label: const Text("Batal"),
                              onPressed: () {
                                setState(() {
                                  _controller.clear();
                                  _editingTodo = null;
                                });
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _todos.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada todo.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _todos.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final todo = _todos[i];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: const Icon(Icons.check_circle_outline),
                            title: Text(todo.title),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                                  onPressed: () => _editTodo(todo),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => _deleteTodo(todo.id!),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}