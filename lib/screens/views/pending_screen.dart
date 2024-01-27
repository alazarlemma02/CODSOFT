import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/bloc/task_bloc/task_bloc.dart';
import 'package:task_app/config/theme.dart';
import 'package:task_app/screens/widgets/common_task_widget.dart';
import 'package:task_app/screens/widgets/drawer_widget.dart';
import 'package:task_app/screens/widgets/pop_up_menu.dart';

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
    taskBloc.add(TaskInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text("Pending Todo"),
            centerTitle: true,
            actions: [PopUpMenu(taskBloc: taskBloc, pageIndex: 1)],
            floating: true,
            snap: true,
          ),
        ],
        body: BlocConsumer<TaskBloc, TaskState>(
          listenWhen: (previous, current) => current is TaskActionState,
          buildWhen: (previous, current) => current is! TaskActionState,
          listener: (context, state) {
            if (state is TaskDeletedActionState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Tasks Deleted Successfully!"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is TaskPendingLoadedState) {
              return CommonTaskWidget(
                taskBloc: taskBloc,
                isCompleted: false,
                task: state.tasks,
                title: "You have no penidng Task!",
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: lightColorScheme.primary,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
