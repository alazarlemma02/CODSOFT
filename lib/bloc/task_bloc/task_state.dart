// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {
  int currentIndex = 0;
}

class TaskActionState extends TaskState {}

class TaskLoadingState extends TaskState {}

class TaskLoadedState extends TaskState {
  final List<Task> task;

  const TaskLoadedState({required this.task});

  @override
  List<Object> get props => [task];
}

class TaskAddingState extends TaskState {}

class TaskAddedActionState extends TaskActionState {}

class TaskDeletingState extends TaskState {}

class TaskDeletedActionState extends TaskActionState {}

class TaskUpdatingState extends TaskState {}

class TaskUpdatedActionState extends TaskActionState {}

class TaskCompletedLoadedState extends TaskState {
  final List<Task> tasks;

  const TaskCompletedLoadedState({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

class TaskPendingLoadedState extends TaskState {
  final List<Task> tasks;

  const TaskPendingLoadedState({required this.tasks});

  @override
  List<Object> get props => [tasks];
}

class TaskErrorState extends TaskState {
  final String message;

  const TaskErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
