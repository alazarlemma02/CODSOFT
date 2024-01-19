import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int? id;
  final String title;
  final String description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime dueAt;
  final DateTime? completedAt;

  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
    required this.dueAt,
    this.completedAt,
  });

  Task copyWith(
      {int? id,
      String? title,
      String? description,
      bool? isCompleted,
      DateTime? createdAt,
      DateTime? dueAt,
      DateTime? completedAt}) {
    return Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        isCompleted: isCompleted ?? this.isCompleted,
        createdAt: createdAt ?? this.createdAt,
        dueAt: dueAt ?? this.dueAt,
        completedAt: completedAt ?? this.completedAt);
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      description: map['description'],
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      dueAt: DateTime.parse(map['dueAt']),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'dueAt': dueAt.toIso8601String(),
      'completedAt': completedAt!.toIso8601String(),
    };
  }

  @override
  List<Object?> get props =>
      [id, title, description, isCompleted, createdAt, dueAt, completedAt];
}
