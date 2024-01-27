import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    this.completedAt,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String() ?? '',
      'timeRangeStart': startTime.hour * 60 + startTime.minute,
      'timeRangeEnd': endTime.hour * 60 + endTime.minute,
    };
  }

  static TimeOfDay _minutesToTimeOfDay(int minutes) {
    final int hour = minutes ~/ 60;
    final int minute = minutes % 60;
    return TimeOfDay(hour: hour, minute: minute);
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      completedAt: DateTime.parse(map['completedAt']),
      startTime: _minutesToTimeOfDay(map['timeRangeStart']),
      endTime: _minutesToTimeOfDay(map['timeRangeEnd']),
    );
  }

  Task copyWith(
      {int? id,
      String? title,
      String? description,
      bool? isCompleted,
      DateTime? createdAt,
      DateTime? completedAt,
      TimeOfDay? startTime,
      TimeOfDay? endTime}) {
    return Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isCompleted: isCompleted ?? this.isCompleted,
        createdAt: createdAt ?? this.createdAt,
        completedAt: completedAt ?? this.completedAt,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime);
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isCompleted,
        createdAt,
        completedAt,
        startTime,
        endTime
      ];
}
