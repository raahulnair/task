import 'package:flutter/material.dart';

void main() => runApp(TaskManagerApp());

enum TaskPriority { Low, Medium, High }

class Task {
  String name;
  bool isCompleted;
  TaskPriority priority;

  Task({required this.name, this.isCompleted = false, required this.priority});
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = [];
  final TextEditingController taskController = TextEditingController();
  TaskPriority _selectedPriority = TaskPriority.Medium;

  void addTask(String taskName, TaskPriority priority) {
    setState(() {
      tasks.add(Task(name: taskName, priority: priority));
      tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    });
    taskController.clear();
  }

  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(labelText: 'Enter task'),
                  ),
                ),
                DropdownButton<TaskPriority>(
                  value: _selectedPriority,
                  onChanged: (TaskPriority? newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                  items: TaskPriority.values.map((TaskPriority priority) {
                    return DropdownMenuItem<TaskPriority>(
                      value: priority,
                      child: Text(priority.toString().split('.').last),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () =>
                      addTask(taskController.text, _selectedPriority),
                  child: Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    tasks[index].name,
                    style: TextStyle(
                      decoration: tasks[index].isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Text(
                    'Priority: ${tasks[index].priority.toString().split('.').last}',
                  ),
                  leading: Checkbox(
                    value: tasks[index].isCompleted,
                    onChanged: (_) => toggleTaskCompletion(index),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deleteTask(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
