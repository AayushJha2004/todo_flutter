import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskEditor extends StatefulWidget {
  final Task? task; // Null means a new task is being added.
  final Function(Task) onSave; // Callback when saving the task.

  const TaskEditor({Key? key, this.task, required this.onSave}) : super(key: key);

  @override
  _TaskEditorState createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  bool _isNotificationOn = false;
  String _importance = 'Not Specified';
  String _group = 'Personal';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  bool _isDetailsMode = true; // Toggle between Details and Subpoints
  List<String> _subpoints = [];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _detailsController.text = widget.task!.details ?? '';
      _isNotificationOn = widget.task!.notification;
      _importance = widget.task!.importance;
      _group = widget.task!.group;
      _selectedDate = widget.task!.date;
      _selectedTime = widget.task!.time;
      _subpoints = widget.task!.subPoints?.map((e) => e.title).toList() ?? [];
    }
  }

  void _pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime ?? TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }

  void _toggleDetailsMode() {
    setState(() {
      _isDetailsMode = !_isDetailsMode;
    });
  }

  void _saveTask() {
    final newTask = Task(
      title: _titleController.text,
      details: _isDetailsMode ? _detailsController.text : null,
      subPoints: _isDetailsMode
          ? null
          : _subpoints.map((e) => SubPoint(title: e)).toList(),
      notification: _isNotificationOn,
      importance: _importance,
      group: _group,
      date: _selectedDate,
      time: _selectedTime,
    );

    widget.onSave(newTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Task Card Editor
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Task name',
                    border: InputBorder.none,
                  ),
                ),
                if (_isDetailsMode)
                  TextField(
                    controller: _detailsController,
                    decoration: InputDecoration(
                      labelText: 'Details',
                      border: InputBorder.none,
                    ),
                  ),
                if (!_isDetailsMode)
                  Column(
                    children: [
                      ..._subpoints.map((e) => ListTile(
                            title: Text(e),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  _subpoints.remove(e);
                                });
                              },
                            ),
                          )),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _subpoints.add('New Subpoint');
                          });
                        },
                        child: Text('Add Subpoint'),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Action Bar
          Container(
            color: Colors.grey[300],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () {
                    setState(() {
                      _importance = (_importance == 'High')
                          ? 'Medium'
                          : (_importance == 'Medium')
                              ? 'Low'
                              : 'High';
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.note_add),
                  onPressed: _toggleDetailsMode,
                ),
                IconButton(
                  icon: Icon(Icons.group),
                  onPressed: () {
                    setState(() {
                      _group = (_group == 'Work')
                          ? 'College'
                          : (_group == 'College')
                              ? 'Home'
                              : 'Personal';
                    });
                  },
                ),
                IconButton(
                  icon: Icon(_isNotificationOn
                      ? Icons.notifications_active
                      : Icons.notifications_off),
                  onPressed: () {
                    setState(() {
                      _isNotificationOn = !_isNotificationOn;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: _pickDateTime,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _saveTask,
            child: Text('Save Task'),
          ),
        ],
      ),
    );
  }
}
