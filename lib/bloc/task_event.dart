part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class TaskInitEvent extends TaskEvent {}

class TaskAddEvent extends TaskEvent {
  final Task task;

  const TaskAddEvent({required this.task});

  @override
  List<Object> get props => [task];
}

class TaskUpdateEvent extends TaskEvent {
  final Task task;

  const TaskUpdateEvent({required this.task});

  @override
  List<Object> get props => [task];
}

class TaskDeleteEvent extends TaskEvent {
  final Task task;

  const TaskDeleteEvent({required this.task});

  @override
  List<Object> get props => [task];
}

class TaskCompleteEvent extends TaskEvent {
  final Task task;

  const TaskCompleteEvent({required this.task});

  @override
  List<Object> get props => [task];
}
