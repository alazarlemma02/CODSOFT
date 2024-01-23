part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {}

class TaskActionState extends TaskState {}

class TaskLoadingState extends TaskState {}

class TaskLoadedState extends TaskState {
  final List<Task> task;

  const TaskLoadedState({required this.task});

  @override
  List<Object> get props => [task];
}

class TaskAddingActionState extends TaskActionState {}

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
