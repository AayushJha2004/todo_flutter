import 'package:flutter/material.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Add settings navigation here
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Tasks Will Appear Here'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add task creation logic here
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
