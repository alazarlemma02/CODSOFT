import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_app/bloc/task_bloc/task_bloc.dart';
import 'package:task_app/data/model/task.dart';

class CommonTaskWidget extends StatefulWidget {
  final TaskBloc taskBloc;
  final List<Task> task;
  final String title;
  final bool isCompleted;
  const CommonTaskWidget(
      {super.key,
      required this.taskBloc,
      required this.task,
      required this.title,
      required this.isCompleted});

  @override
  State<CommonTaskWidget> createState() => _CommonTaskWidgetState();
}

class _CommonTaskWidgetState extends State<CommonTaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is TaskLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TaskCompletedLoadedState ||
            state is TaskPendingLoadedState) {
          final tasks = (state is TaskCompletedLoadedState)
              ? (state).tasks
              : (state as TaskPendingLoadedState).tasks;

          if (tasks.isEmpty) {
            return Center(
              child: Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage("assets/images/no_task.png"),
                    ),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final descriptionPreview = task.description.length > 50
                    ? '${task.description.substring(0, 50)}...'
                    : task.description;
                return Slidable(
                  startActionPane: ActionPane(
                    motion: const BehindMotion(),
                    children: [
                      SlidableAction(
                          icon: Icons.check_circle,
                          backgroundColor: Colors.green,
                          label: "Complete",
                          onPressed: (context) {
                            widget.taskBloc.add(TaskCompleteEvent(task: task));
                          })
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    children: [
                      SlidableAction(
                        icon: Icons.delete,
                        label: "Remove",
                        backgroundColor: Colors.red,
                        onPressed: (context) {
                          widget.taskBloc.add(TaskDeleteEvent(task: task));
                        },
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {},
                      title: Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        descriptionPreview,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      trailing: Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) {
                          if (state is! TaskCompletedLoadedState) {
                            widget.taskBloc.add(TaskCompleteEvent(task: task));
                          }
                        },
                        activeColor: Colors.green,
                      ),
                      tileColor: task.isCompleted
                          ? Colors.green[100]
                          : Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        } else {
          return const Center(
            child: Text("error..."),
          );
        }
      },
    ));
  }
}
