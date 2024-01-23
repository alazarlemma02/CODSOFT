import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_app/data/model/task.dart';
import 'package:task_app/data/services/database_provider.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  List<Task> tasks = [];
  TaskBloc() : super(TaskInitial()) {
    on<TaskInitEvent>(_taskInitEvent);
    on<TaskAddEvent>(_taskAddEvent);
    on<TaskDeleteEvent>(_taskDeleteEvent);
    on<TaskUpdateEvent>(_taskUpdateEvent);
    on<TaskCompleteEvent>(_taskCompleteEvent);
    on<TaskFilterEvent>(_taskFilterEvent);
  }

  Future<void> _loaderInstance({required Emitter<TaskState> emit}) async {
    tasks = await DatabaseProvider.instance.readAllTasks();
    emit(TaskLoadedState(task: tasks));
  }

  FutureOr<void> _taskInitEvent(
      TaskInitEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoadingState());
    await Future.delayed(const Duration(seconds: 3));
    try {
      await _loaderInstance(emit: emit);
    } catch (e) {
      emit(TaskErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _taskAddEvent(
      TaskAddEvent event, Emitter<TaskState> emit) async {
    emit(TaskAddingActionState());
    // EasyLoading.show(status: 'loading...');
    await Future.delayed(const Duration(seconds: 3));

    try {
      await DatabaseProvider.instance.create(event.task);
      await _loaderInstance(emit: emit);
      emit(TaskAddedActionState());
      EasyLoading.showSuccess('Success!');
    } catch (e) {
      emit(TaskErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _taskDeleteEvent(
      TaskDeleteEvent event, Emitter<TaskState> emit) async {
    emit(TaskDeletingState());
    try {
      await DatabaseProvider.instance.delete(id: event.task.id!);
      await _loaderInstance(emit: emit);
      emit(TaskDeletedActionState());
    } catch (e) {
      emit(TaskErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _taskUpdateEvent(
      TaskUpdateEvent event, Emitter<TaskState> emit) async {
    emit(TaskUpdatingState());
    try {
      await DatabaseProvider.instance.update(task: event.task);
      emit(TaskUpdatedActionState());
    } catch (e) {
      emit(TaskErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _taskCompleteEvent(
      TaskCompleteEvent event, Emitter<TaskState> emit) async {
    bool status = event.task.isCompleted;
    try {
      Task updatedTask = event.task.copyWith(isCompleted: !status);
      await DatabaseProvider.instance.update(task: updatedTask);
      if (!status) emit(TaskUpdatingState());
      await _loaderInstance(emit: emit);
    } catch (e) {
      emit(TaskErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _taskFilterEvent(
      TaskFilterEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoadingState());
    await Future.delayed(const Duration(seconds: 3));
    try {
      List<Task> filteredTask = await DatabaseProvider.instance
          .filter(filterKey: event.filterKey, filterValue: event.status);
      if (event.status == true) {
        emit(TaskCompletedLoadedState(tasks: filteredTask));
      } else {
        emit(TaskPendingLoadedState(tasks: filteredTask));
      }
    } catch (e) {
      emit(TaskErrorState(message: e.toString()));
    }
  }
}
