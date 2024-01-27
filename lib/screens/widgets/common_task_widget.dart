import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_app/bloc/task_bloc/task_bloc.dart';
import 'package:task_app/config/theme.dart';
import 'package:task_app/data/model/task.dart';

class CommonTaskWidget extends StatefulWidget {
  final TaskBloc taskBloc;
  final List<Task> task;
  final String title;
  final bool isCompleted;

  const CommonTaskWidget({
    Key? key,
    required this.taskBloc,
    required this.task,
    required this.title,
    required this.isCompleted,
  }) : super(key: key);

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
                      Image(
                        image: const AssetImage("assets/images/no_task.png"),
                        color: lightColorScheme.tertiary,
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
                    startActionPane: task.isCompleted
                        ? null
                        : ActionPane(
                            motion: const BehindMotion(),
                            children: [
                              SlidableAction(
                                icon: Icons.check_circle,
                                backgroundColor: Colors.green,
                                label: "Complete",
                                onPressed: (context) {
                                  widget.taskBloc
                                      .add(TaskCompleteEvent(task: task));
                                },
                              )
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
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1.0,
                          ),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: lightColorScheme.primary,
                            ),
                          ),
                          subtitle: Text(
                            descriptionPreview,
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          tilePadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          children: [
                            ListTile(
                              title: Text(
                                'Description: ${task.description}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Start Time: ${task.startTime.format(context)}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            ListTile(
                              title: Row(
                                children: [
                                  Text(
                                    'End Time: ${task.endTime.format(context)}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        if (!task.isCompleted) {
                                          widget.taskBloc.add(
                                              TaskCompleteEvent(task: task));
                                          BlocProvider.of<TaskBloc>(context)
                                              .add(const TaskFilterEvent(
                                                  filterKey: 'isCompleted',
                                                  status: false));
                                        }
                                      },
                                      child: task.isCompleted
                                          ? const Text("Done")
                                          : const Text("Complete")),
                                ],
                              ),
                            ),
                          ],
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
      ),
    );
  }
}
