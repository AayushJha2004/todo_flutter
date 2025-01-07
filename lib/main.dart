import 'package:flutter/material.dart';
import 'models/task.dart';

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
  Map<String, bool> expandedState = {};

  void toggleExpand(String taskTitle) {
    setState(() {
      expandedState[taskTitle] = !(expandedState[taskTitle] ?? false);
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

  void editTask(Task task) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing Task "${task.title}"'),
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
          final isExpanded = expandedState[task.title] ?? false;

          return GestureDetector(
            child: Dismissible(
              key: Key(task.title),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                return false; // Prevent auto-delete
              },
              child: Stack(
                children: [
                  // Background Edit and Delete Buttons
                  Positioned.fill(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.edit, color: Colors.white),
                            onPressed: () => editTask(task),
                          ),
                        ),
                        SizedBox(width: 4),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.white),
                            onPressed: () => deleteTask(task),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Task Card
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // Priority Stripe on the Leftmost Side
                          Container(
                            width: 8,
                            height: 80,
                            decoration: BoxDecoration(
                              color: getPriorityColor(task.importance),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                          ),
                          // Task Details
                          Expanded(
                            child: ListTile(
                              title: Text(task.title,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: task.time != null
                                  ? Text(
                                      '${task.time!.format(context)}',
                                      style: TextStyle(color: Colors.grey[700]),
                                    )
                                  : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      task.notification
                                          ? Icons.notifications_active
                                          : Icons.notifications_off,
                                      color: task.notification
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    onPressed: () => toggleNotification(task),
                                  ),
                                  if (task.details != null)
                                    IconButton(
                                      icon: Icon(
                                        isExpanded
                                            ? Icons.keyboard_arrow_up
                                            : Icons.keyboard_arrow_down,
                                      ),
                                      onPressed: () => toggleExpand(task.title),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
