import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/bloc/task_bloc/task_bloc.dart';
import 'package:task_app/config/field_validator.dart';
import 'package:task_app/config/theme.dart';
import 'package:task_app/data/model/task.dart';

class TaskAddScreen extends StatefulWidget {
  const TaskAddScreen({super.key});

  @override
  State<TaskAddScreen> createState() => TaskAddScreenState();
}

class TaskAddScreenState extends State<TaskAddScreen> {
  final TextEditingController _titleController = TextEditingController();
  DateTime _createdAt = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime =
      TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 2)));

  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100))
        .then((value) {
      if (value != null) {
        setState(() {
          _createdAt = value;
        });
      }
    });
  }

  void _showStartTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) => {
              if (value != null)
                {
                  setState(() {
                    _startTime = value;
                  })
                }
            });
  }

  void _showEndTimePicker() {
    showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then((value) => {
              if (value != null)
                {
                  setState(() {
                    _endTime = value;
                  })
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Task"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
          height: MediaQuery.of(context).size.height * 0.8,
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Task Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextFormField(
                  validator: (value) =>
                      Validator.validateTitle(title: _titleController.text),
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: "task name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const Text(
                  "Date & Time",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                GestureDetector(
                  onTap: _showDatePicker,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: lightColorScheme.outline,
                          style: BorderStyle.solid),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_createdAt.toLocal()}".split(' ')[0],
                        ),
                        IconButton(
                          onPressed: _showDatePicker,
                          icon: const Icon(Icons.date_range),
                          color: darkColorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "Start time",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            GestureDetector(
                              onTap: _showStartTimePicker,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _startTime.format(context).toString(),
                                    ),
                                    IconButton(
                                      onPressed: _showStartTimePicker,
                                      icon: const Icon(Icons.arrow_drop_down,
                                          size: 40),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              "End time",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            GestureDetector(
                              onTap: _showEndTimePicker,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _endTime.format(context).toString(),
                                    ),
                                    IconButton(
                                      onPressed: _showEndTimePicker,
                                      icon: const Icon(Icons.arrow_drop_down,
                                          size: 40),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
                const Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextFormField(
                  validator: (value) => Validator.validateDescription(
                      description: _descriptionController.text),
                  maxLines: 3,
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: "task description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                    _addTodo(context);
                    Navigator.pop(context, true);
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: const Center(
                      child: Text(
                        'Create task',
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
      ),
    );
  }

  void _addTodo(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<TaskBloc>(context).add(TaskAddEvent(
          task: Task(
              title: _titleController.text,
              description: _descriptionController.text,
              isCompleted: false,
              createdAt: _createdAt,
              completedAt: DateTime.now(),
              startTime: _startTime,
              endTime: _endTime)));
    }
  }
}
