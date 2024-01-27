import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_app/bloc/task_bloc/task_bloc.dart';
import 'package:task_app/config/theme.dart';
import 'package:task_app/screens/views/task_add_screen.dart';
import 'package:task_app/screens/views/task_edit_screen.dart';
import 'package:task_app/screens/widgets/drawer_widget.dart';
import 'package:task_app/screens/widgets/pop_up_menu.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TaskBloc taskBloc = TaskBloc();
  FloatingActionButton? fab;
  bool isFabVisible = true;

  @override
  void initState() {
    taskBloc.add(TaskInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text("My Todo's"),
              centerTitle: true,
              actions: [
                PopUpMenu(
                  taskBloc: taskBloc,
                  pageIndex: 0,
                ),
              ],
              floating: true,
              snap: true,
            ),
          ];
        },
        body: BlocConsumer<TaskBloc, TaskState>(
          bloc: taskBloc,
          listenWhen: (previous, current) => current is TaskActionState,
          buildWhen: (previous, current) => current is! TaskActionState,
          listener: (context, state) {
            if (state is TaskAddedActionState) {
              EasyLoading.showSuccess("Task Added Successfully");
            } else if (state is TaskDeletedActionState) {
              EasyLoading.showSuccess("Task Deleted Successfully");
            } else if (state is TaskUpdatedActionState) {
              EasyLoading.showSuccess("Task Updated Successfully");
            }
          },
          builder: (context, state) {
            switch (state.runtimeType) {
              case TaskLoadingState:
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: CircularProgressIndicator(
                        color: lightColorScheme.primary),
                  ),
                );
              case TaskAddingState:
                return const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                );

              case TaskLoadedState:
                final successState = state as TaskLoadedState;
                if (successState.task.isEmpty) {
                  fab = null;
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.1),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image(
                              image:
                                  const AssetImage("assets/images/no_task.png"),
                              color: lightColorScheme.tertiary,
                            ),
                            const Text(
                              "Hey, You have no todo's created yet!\ncreate your first todo today!",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: lightColorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4,
                                shadowColor: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TaskAddScreen(),
                                  ),
                                ).then(
                                    (value) => taskBloc.add(TaskInitEvent()));
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: const Center(
                                  child: Text(
                                    'Create new Todo',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  Future.microtask(() {
                    setState(() {
                      fab = FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TaskAddScreen()))
                              .then((value) => taskBloc.add(TaskInitEvent()));
                        },
                        backgroundColor: lightColorScheme.primary,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Create ",
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      );
                    });
                  });
                  final reversedTask = successState.task.reversed.toList();
                  return NotificationListener<UserScrollNotification>(
                    onNotification: (notification) {
                      if (notification.direction == ScrollDirection.reverse) {
                        if (isFabVisible) {
                          setState(() {
                            isFabVisible = false;
                          });
                        }
                      } else if (notification.direction ==
                          ScrollDirection.forward) {
                        if (!isFabVisible) {
                          setState(() {
                            isFabVisible = true;
                          });
                        }
                      }
                      return true;
                    },
                    child: ListView.builder(
                      itemCount: reversedTask.length,
                      itemBuilder: (context, index) {
                        final task = reversedTask[index];
                        final descriptionText = task.description.length > 50
                            ? '${task.description.substring(0, 50)}...'
                            : task.description;

                        final startTimeText = task.startTime.format(context);
                        final endTimeText = task.endTime.format(context);

                        final completionStatus = calculateCompletionStatus(
                            task.startTime, task.endTime);

                        return Slidable(
                          startActionPane: task.isCompleted
                              ? null
                              : ActionPane(
                                  motion: const BehindMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        taskBloc
                                            .add(TaskCompleteEvent(task: task));
                                      },
                                      icon: Icons.check_circle,
                                      backgroundColor: Colors.green,
                                      label: "Complete",
                                    ),
                                  ],
                                ),
                          endActionPane: ActionPane(
                            motion: const BehindMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  taskBloc.add(TaskDeleteEvent(task: task));
                                },
                                icon: Icons.delete,
                                label: "Remove",
                                backgroundColor: Colors.red,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: lightColorScheme.primary,
                                  width: 5.0,
                                ),
                              ),
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ExpansionTile(
                                    collapsedBackgroundColor:
                                        Theme.of(context).cardColor,
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                task.title,
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: lightColorScheme
                                                      .surfaceTint,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          'Start Time: $startTimeText',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'End Time: $endTimeText',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Container(
                                          // padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors
                                                .transparent, // Set the desired background color
                                            border: Border.all(
                                              color: Colors
                                                  .transparent, // Set the desired border color
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                task.isCompleted
                                                    ? "Time Taken:"
                                                    : "Time Left:",
                                                style: TextStyle(
                                                  color: task.isCompleted
                                                      ? lightColorScheme
                                                          .inversePrimary
                                                      : lightColorScheme.error,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    if (!task.isCompleted) {
                                                      taskBloc.add(
                                                          TaskCompleteEvent(
                                                              task: task));
                                                    }
                                                  },
                                                  child: task.isCompleted
                                                      ? const Text("Done")
                                                      : const Text(
                                                          "Complete Task")),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        LinearProgressIndicator(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          minHeight: 10.0,
                                          value: completionStatus,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .surfaceVariant,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            task.isCompleted
                                                ? lightColorScheme.secondary
                                                : lightColorScheme.error,
                                          ),
                                        ),
                                      ],
                                    ),
                                    children: [
                                      ListTile(
                                        subtitle: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Details:",
                                                style: TextStyle(
                                                  color:
                                                      darkColorScheme.secondary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                descriptionText,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  taskBloc.add(
                                                      TaskCompleteEvent(
                                                          task: task));
                                                },
                                                icon: Icon(
                                                  Icons.undo,
                                                  color: lightColorScheme.error,
                                                )),
                                            task.isCompleted
                                                ? Container()
                                                : IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              TaskEditScreen(
                                                                  task: task),
                                                        ),
                                                      ).then((value) =>
                                                          taskBloc.add(
                                                              TaskInitEvent()));
                                                    },
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color: lightColorScheme
                                                          .primary,
                                                    ),
                                                    color: Theme.of(context)
                                                        .iconTheme
                                                        .color,
                                                  ),
                                          ],
                                        ),
                                        tileColor: task.isCompleted
                                            ? darkColorScheme.inversePrimary
                                            : Theme.of(context).cardColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

              default:
                return const Center(
                  child: Text("Something went Wrong"),
                );
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: isFabVisible
          ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: fab,
            )
          : null,
    );
  }

  double calculateCompletionStatus(TimeOfDay startTime, TimeOfDay endTime) {
    final currentTime = TimeOfDay.now();
    final totalMinutes = endTime.hour * 60 +
        endTime.minute -
        startTime.hour * 60 -
        startTime.minute;
    final remainingMinutes = endTime.hour * 60 +
        endTime.minute -
        currentTime.hour * 60 -
        currentTime.minute;
    final completionStatus = (totalMinutes - remainingMinutes) / totalMinutes;

    return completionStatus > 1.0 ? 1.0 : completionStatus;
  }
}
