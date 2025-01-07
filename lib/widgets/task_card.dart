import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onToggleNotification;
  final VoidCallback onExpand;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onDelete,
    required this.onEdit,
    required this.onToggleNotification,
    required this.onExpand,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _animationController.value -= details.primaryDelta! / 150;
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_animationController.value > 0.5) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _resetSwipe() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: Stack(
        children: [
          // Background Buttons (Edit & Delete)
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Edit Button
                Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      _resetSwipe();
                      widget.onEdit();
                    },
                  ),
                ),
                SizedBox(width: 4),
                // Delete Button
                Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: () {
                      _resetSwipe();
                      widget.onDelete();
                    },
                  ),
                ),
                SizedBox(width: 20), // Extra spacing to prevent peeking
              ],
            ),
          ),

          // Foreground Task Card
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(-_animationController.value * 150, 0),
                child: child,
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Priority Stripe
                  Container(
                    width: 8,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(widget.task.importance),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                  ),
                  // Task Details
                  Expanded(
                    child: ListTile(
                      title: Text(widget.task.title,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: widget.task.time != null
                          ? Text(
                              widget.task.time!.format(context),
                              style: TextStyle(color: Colors.grey[700]),
                            )
                          : null,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              widget.task.notification
                                  ? Icons.notifications_active
                                  : Icons.notifications_off,
                              color: widget.task.notification
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: widget.onToggleNotification,
                          ),
                          if (widget.task.details != null)
                            IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                              onPressed: widget.onExpand,
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
    );
  }

  Color _getPriorityColor(String importance) {
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
}
