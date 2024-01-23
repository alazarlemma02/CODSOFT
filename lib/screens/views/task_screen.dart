import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_app/bloc/task_bloc/task_bloc.dart';
import 'package:task_app/screens/views/task_add_screen.dart';
import 'package:task_app/screens/views/task_edit_screen.dart';
import 'package:task_app/screens/widgets/dark_light_mode.dart';
import 'package:task_app/screens/widgets/drawer_widget.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TaskBloc taskBloc = TaskBloc();
  FloatingActionButton? fab;

  @override
  void initState() {
    taskBloc.add(TaskInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text("My Todo's"),
        actions: const [
          DarkLightMode(),
        ],
        centerTitle: true,
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        bloc: taskBloc,
        listenWhen: (previous, current) => current is TaskActionState,
        buildWhen: (previous, current) => current is! TaskActionState,
        listener: (context, state) {
          if (state is TaskAddedActionState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
                content: Center(
                  child: Text(
                    "Task Added Successfully.",
                    style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              ),
            );
          } else if (state is TaskAddingActionState) {
            EasyLoading.show(status: 'creating...');
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case TaskLoadingState:
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: CircularProgressIndicator(color: Colors.blue),
                ),
              );

            case TaskLoadedState:
              final successState = state as TaskLoadedState;
              if (successState.task.isEmpty) {
                fab = null;
                return Center(
                  child: Padding(
                    padding:
                        EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Image(
                            image: AssetImage("assets/images/no_task.png"),
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
                              backgroundColor: Colors.blue,
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
                              );
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: const Center(
                                child: Text(
                                  'Create todo',
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
                      shape: const CircleBorder(side: BorderSide.none),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TaskAddScreen()));
                      },
                      backgroundColor: Colors.blue,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    );
                  });
                });
                final reversedTask = successState.task.reversed.toList();
                return ListView.builder(
                  itemCount: reversedTask.length,
                  itemBuilder: (context, index) {
                    final task = reversedTask[index];
                    final descriptionText = task.description.length > 50
                        ? '${task.description.substring(0, 50)}...'
                        : task.description;

                    final startTimeText = task.startTime.format(context);
                    final endTimeText = task.endTime.format(context);

                    return Slidable(
                      startActionPane: task.isCompleted
                          ? null
                          : ActionPane(
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    taskBloc.add(TaskCompleteEvent(task: task));
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
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: task.isCompleted
                                    ? Colors.green.withOpacity(0.3)
                                    : Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                                color: Colors.grey[350]!, width: 1.0),
                          ),
                          child: ExpansionTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Start Time: $startTimeText',
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'End Time: $endTimeText',
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            children: [
                              ListTile(
                                subtitle: Text(
                                  descriptionText,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    task.isCompleted
                                        ? Container()
                                        : IconButton(
                                            onPressed: () async {
                                              final result =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      TaskEditScreen(
                                                          task: task),
                                                ),
                                              );
                                              if (result == true) {
                                                taskBloc.add(TaskInitEvent());
                                              }
                                            },
                                            icon: const Icon(Icons.edit_square),
                                          ),
                                    Checkbox(
                                      value: task.isCompleted,
                                      onChanged: (value) {
                                        taskBloc
                                            .add(TaskCompleteEvent(task: task));
                                      },
                                      activeColor: Colors.green,
                                    ),
                                  ],
                                ),
                                tileColor: task.isCompleted
                                    ? Colors.green.withOpacity(0.3)
                                    : Colors.grey[200],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }

            default:
              return const Center(
                child: Text("Something went Wrong"),
              );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fab,
    );
  }
}
