import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/bloc/task_bloc/task_bloc.dart';
import 'package:task_app/screens/widgets/common_task_widget.dart';
import 'package:task_app/screens/widgets/dark_light_mode.dart';
import 'package:task_app/screens/widgets/drawer_widget.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({super.key});

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  final TaskBloc taskBloc = TaskBloc();

  @override
  void initState() {
    BlocProvider.of<TaskBloc>(context)
        .add(const TaskFilterEvent(filterKey: 'isCompleted', status: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text("Pending Todo"),
        centerTitle: true,
        actions: const [DarkLightMode()],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskPendingLoadedState) {
            return CommonTaskWidget(
              taskBloc: taskBloc,
              isCompleted: false,
              task: state.tasks,
              title: "You have no penidng Task!",
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }
        },
      ),
    );
  }
}
