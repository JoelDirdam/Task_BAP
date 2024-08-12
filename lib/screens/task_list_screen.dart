import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:task_bap/blocs/bloc/task_list_bloc.dart';
import 'package:task_bap/helpers/helper.dart';
import 'package:task_bap/widgets/custom_scaffold_widget.dart';
import 'package:task_bap/widgets/task_edit_drawer_widget.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with WidgetsBindingObserver {
  List<dynamic> tasks = [];

  IconData prefixIcon = Icons.add;
  bool showSuffixIcons = false;
  final TextEditingController _titleTaskController = TextEditingController();
  final TextEditingController _selectedDateController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  DateTime? selectedDate;
  List<String>? tags;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset > 0.0) {
      _togglePrefixIcon();
    } else {
      _togglePrefixIcon();
    }
  }

  void _togglePrefixIcon() {
    setState(() {
      prefixIcon = prefixIcon == Icons.add ? Icons.circle_outlined : Icons.add;
    });
  }

  void _onTextChanged(String text) {
    setState(() {
      showSuffixIcons = text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskListBloc()..add(GetTasksEvent()),
      child: BlocListener<TaskListBloc, TaskListState>(
        listener: (context, state) {
          if (state is GetTasksSuccess) {
            setState(() {
              tasks = state.tasks;
            });
          } else if (state is CreateTaskSuccess) {
            BlocProvider.of<TaskListBloc>(context).add(GetTasksEvent());
            selectedDate = null;
            _titleTaskController.clear();
            _selectedDateController.clear();
            _commentController.clear();
            _descriptionController.clear();
            _tagsController.clear();
          } else if (state is UpdateTaskSuccess) {
            BlocProvider.of<TaskListBloc>(context).add(GetTasksEvent());
          } else if (state is DeleteTaskSuccess) {
            BlocProvider.of<TaskListBloc>(context).add(GetTasksEvent());
          } else if (state is TaskListError) {
            BlocProvider.of<TaskListBloc>(context).add(GetTasksEvent());
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text(state.message),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: CustomScaffoldWidget(
          body: Padding(
            padding: EdgeInsets.all(16.w),
            child: BlocBuilder<TaskListBloc, TaskListState>(
              builder: (context, state) {
                if (state is TaskListLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  );
                } else if (state is GetTasksSuccess) {
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: const Color.fromARGB(255, 189, 179, 238),
                        child: ListTile(
                          leading: Container(
                            constraints: BoxConstraints.expand(width: 10.w),
                            child: Icon(
                              tasks[index]['is_completed'] == 1
                                  ? Icons.check_circle_outline
                                  : Icons.circle_outlined,
                            ),
                          ),
                          title: GestureDetector(
                            onTap: () {
                              log('Task ID: ${tasks[index]['id']}');
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return TaskEditPopup(
                                    taskId: tasks[index]['id'].toString(),
                                  );
                                },
                              );
                            },
                            child: Text(
                              tasks[index]['title'],
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 12.w,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${tasks[index]['due_date']}',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
          bottomSheet: BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                color: const Color.fromARGB(255, 226, 226, 226),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: TextField(
                    onChanged: _onTextChanged,
                    controller: _titleTaskController,
                    onEditingComplete: () {
                      BlocProvider.of<TaskListBloc>(context).add(
                        CreateTaskEvent(
                          title: _titleTaskController.text,
                          description: _descriptionController.text,
                          comment: _commentController.text,
                          tags: tags?.join(','),
                          selectedDate: _selectedDateController.text,
                        ),
                      );
                    },
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 189, 179, 238),
                      hintText: 'Agregar una tarea',
                      hintStyle: const TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.r),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(prefixIcon, color: Colors.black54),
                      suffixIcon: showSuffixIcons
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.calendar_today,
                                      color: _selectedDateController
                                              .text.isNotEmpty
                                          ? Colors.black54
                                          : Colors.black12,
                                      size: 14.w),
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.comment,
                                      color: _commentController.text.isNotEmpty
                                          ? Colors.black54
                                          : Colors.black12,
                                      size: 14.w),
                                  onPressed: () {
                                    showTextDialog(
                                            context,
                                            _commentController.text,
                                            'Agregar Comentario',
                                            'Escribe tu comentario aquí...')
                                        .then((value) {
                                      setState(() {
                                        _commentController.text = value ?? '';
                                      });
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.description,
                                      color:
                                          _descriptionController.text.isNotEmpty
                                              ? Colors.black54
                                              : Colors.black12,
                                      size: 14.w),
                                  onPressed: () {
                                    showTextDialog(
                                            context,
                                            _descriptionController.text,
                                            'Agregar Descripción',
                                            'Escribe tu descripción aquí...')
                                        .then((value) {
                                      setState(() {
                                        _descriptionController.text =
                                            value ?? '';
                                      });
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.label,
                                      color: _tagsController.text.isNotEmpty
                                          ? Colors.black54
                                          : Colors.black12,
                                      size: 14.w),
                                  onPressed: () {
                                    showTagsDialog(context,
                                            _tagsController.text.split(','))
                                        .then((value) {
                                      setState(() {
                                        tags = value;
                                      });
                                    });
                                  },
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<String?> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 189, 179, 238),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        formatter.format(pickedDate);
        selectedDate = pickedDate;
      });

      _selectedDateController.text = formatter.format(pickedDate);

      return formatter.format(pickedDate);
    }

    return null;
  }
}
