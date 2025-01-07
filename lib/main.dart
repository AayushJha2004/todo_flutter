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
  List<Task> tasks = [
    Task(
      title: 'Dbms lab 4 lab report',
      date: DateTime.now(),
      time: TimeOfDay(hour: 18, minute: 0),
      notification: true,
      importance: 'Medium',
      group: 'College',
      details: 'Submit the lab report before 6 PM.',
    ),
    Task(
      title: 'Meet investor mr xyz for project',
      date: DateTime.now(),
      time: TimeOfDay(hour: 21, minute: 0),
      notification: true,
      importance: 'High',
      group: 'Work',
      details: 'Prepare presentation and financial summary.',
    ),
    Task(
      title: 'Drink Water',
      notification: false,
      group: 'Personal',
    ),
  ];

  List<Task> completedTasks = [];

  void toggleExpand(String taskTitle) {
    setState(() {
      tasks.firstWhere((task) => task.title == taskTitle).isExpanded =
          !(tasks.firstWhere((task) => task.title == taskTitle).isExpanded ??
              false);
    });
  }

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

  void editTask(Task task) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit Task: "${task.title}"'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void deleteTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task "${task.title}" deleted'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Color getPriorityColor(String importance) {
    switch (importance) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.yellow;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Completed Tasks: ${completedTasks.length}',
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return TaskCard(
            task: task,
            onDelete: () => deleteTask(task),
            onEdit: () => editTask(task),
            onToggleNotification: () => toggleNotification(task),
            onExpand: () => toggleExpand(task.title),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            tasks.add(Task(title: 'New Task', details: 'Added dynamically'));
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
