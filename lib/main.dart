import 'package:flutter/material.dart';
import 'models/task.dart';
import 'widgets/task_card.dart';

void main() {
  runApp(TaskApp());
}

class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskScreen(),
    );
  }
}

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = [];
  Task? editingTask; // To track the task being edited
  bool isAddingTask = false; // Track if we're adding a new task
  final TextEditingController _taskController = TextEditingController();

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  /// Add or Save a Task
  void saveTask() {
    setState(() {
      if (editingTask != null) {
        // Update an existing task
        editingTask!.title = _taskController.text;
        editingTask = null;
      } else {
        // Add a new task
        tasks.add(Task(
          title: _taskController.text,
        ));
      }
      isAddingTask = false;
      _taskController.clear();
    });
  }

  /// Edit a Task
  void editTask(Task task) {
    setState(() {
      editingTask = task;
      _taskController.text = task.title;
      isAddingTask = true; // Show the editor
    });
  }

  /// Delete a Task
  void deleteTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
  }

  /// Toggle Notification
  void toggleNotification(Task task) {
    setState(() {
      task.notification = !task.notification;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          task.notification
              ? 'Notification Enabled for "${task.title}"'
              : 'Notification Disabled for "${task.title}"',
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// Toggle Task Editor
  void toggleTaskEditor() {
    setState(() {
      isAddingTask = !isAddingTask;
      if (!isAddingTask) {
        editingTask = null;
        _taskController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskCard(
                  task: task,
                  onDelete: () => deleteTask(task),
                  onEdit: () => editTask(task),
                  onToggleNotification: () => toggleNotification(task),
                  onExpand: () {},
                );
              },
            ),
          ),

          // Inline Task Editor
          if (isAddingTask)
            Material(
              elevation: 8,
              child: Column(
                children: [
                  TextField(
                    controller: _taskController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Task name',
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.star),
                        onPressed: () {
                          // Handle Importance
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.description),
                        onPressed: () {
                          // Handle Details (mutually exclusive with Subpoints)
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.list),
                        onPressed: () {
                          // Handle Subpoints (mutually exclusive with Details)
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.group),
                        onPressed: () {
                          // Handle Group Assignment
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () {
                          // Handle Notification Toggle
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          // Handle Date and Time Selection
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: saveTask,
                    child: Text('Save Task'),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleTaskEditor,
        child: Icon(isAddingTask ? Icons.close : Icons.add),
      ),
    );
  }
}
