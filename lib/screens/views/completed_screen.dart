import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/bloc/task_bloc/task_bloc.dart';
import 'package:task_app/config/theme.dart';
import 'package:task_app/screens/widgets/common_task_widget.dart';
import 'package:task_app/screens/widgets/drawer_widget.dart';
import 'package:task_app/screens/widgets/pop_up_menu.dart';

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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text("Completed Todo"),
            centerTitle: true,
            actions: [PopUpMenu(taskBloc: taskBloc, pageIndex: 2)],
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
            if (state is TaskCompletedLoadedState) {
              return CommonTaskWidget(
                taskBloc: taskBloc,
                isCompleted: true,
                task: state.tasks,
                title: "You have Completed all Tasks!",
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
