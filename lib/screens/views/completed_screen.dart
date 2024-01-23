import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/bloc/task_bloc/task_bloc.dart';
import 'package:task_app/screens/widgets/common_task_widget.dart';
import 'package:task_app/screens/widgets/dark_light_mode.dart';
import 'package:task_app/screens/widgets/drawer_widget.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  final TaskBloc taskBloc = TaskBloc();

  @override
  void initState() {
    BlocProvider.of<TaskBloc>(context)
        .add(const TaskFilterEvent(filterKey: 'isCompleted', status: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        title: const Text("Completed Todo"),
        centerTitle: true,
        actions: const [DarkLightMode()],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskCompletedLoadedState) {
            return CommonTaskWidget(
              taskBloc: taskBloc,
              isCompleted: true,
              task: state.tasks,
              title: "You have Completed all Tasks!",
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }
}
