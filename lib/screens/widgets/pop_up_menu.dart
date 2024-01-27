import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/bloc/task_bloc/task_bloc.dart';

class PopUpMenu extends StatelessWidget {
  const PopUpMenu({super.key, required this.taskBloc, required this.pageIndex});

  final TaskBloc taskBloc;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'remove_all') {
          taskBloc.add(TaskDeleteAllEvent());
          taskBloc.add(TaskInitEvent());
        } else if (value == 'remove_completed') {
          taskBloc.add(TaskDeleteCompletedEvent());
          BlocProvider.of<TaskBloc>(context).add(
              const TaskFilterEvent(filterKey: 'isCompleted', status: true));
        } else if (value == 'remove_pending') {
          taskBloc.add(TaskDeletePendingEvent());
          BlocProvider.of<TaskBloc>(context).add(
              const TaskFilterEvent(filterKey: 'isCompleted', status: false));
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: pageIndex == 2 ? 'remove_completed' : 'remove_pending',
          child: Text(pageIndex == 2
              ? 'Remove Completed Tasks'
              : 'Remove Pending Tasks'),
        ),
        if (pageIndex == 0)
          const PopupMenuItem<String>(
            value: 'remove_all',
            child: Text('Remove All Tasks'),
          ),
      ],
    );
  }
}
