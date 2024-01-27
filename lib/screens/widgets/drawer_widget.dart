import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/bloc/task_bloc/task_bloc.dart';
import 'package:task_app/config/theme.dart';
import 'package:task_app/screens/views/completed_screen.dart';
import 'package:task_app/screens/views/pending_screen.dart';
import 'package:task_app/screens/views/task_add_screen.dart';
import 'package:task_app/screens/views/task_screen.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: lightColorScheme.background,
            ),
            child: Text(
              'Task Master',
              style: TextStyle(
                color: lightColorScheme.primary,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.task_sharp,
              color: lightColorScheme.primary,
            ),
            title: const Text('All Tasks'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TaskScreen()),
              ).then((value) =>
                  BlocProvider.of<TaskBloc>(context).add(TaskInitEvent()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.pending_actions,
              color: lightColorScheme.primary,
            ),
            title: const Text('Pending Tasks'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PendingScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
            title: const Text('Completed Tasks'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const CompletedScreen()),
              );
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TaskAddScreen()));
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Create Todo"), Icon(Icons.add)],
            ),
          ),
        ],
      ),
    );
  }
}
