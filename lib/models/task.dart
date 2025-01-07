import 'package:flutter/material.dart';

class Task {
  String title;
  DateTime? date;
  TimeOfDay? time;
  bool notification;
  String group; // Work, College, Home, Personal
  String importance; // High, Medium, Low, Not Specified
  String? details;
  List<SubPoint>? subPoints; // List of sub-tasks
  bool isCompleted;

  Task({
    required this.title,
    this.date,
    this.time,
    this.notification = false,
    this.group = 'Personal',
    this.importance = 'Not Specified',
    this.details,
    this.subPoints,
    this.isCompleted = false,
  });
}

class SubPoint {
  String title;
  bool isCompleted;

  SubPoint({
    required this.title,
    this.isCompleted = false,
  });
}
