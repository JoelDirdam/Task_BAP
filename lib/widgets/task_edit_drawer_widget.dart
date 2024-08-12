import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_bap/blocs/bloc/task_list_bloc.dart';

class TaskEditPopup extends StatefulWidget {
  final String taskId;

  const TaskEditPopup({
    super.key,
    required this.taskId,
  });

  @override
  State<TaskEditPopup> createState() => _TaskEditPopupState();
}

class _TaskEditPopupState extends State<TaskEditPopup> {
  final TextEditingController _titleTaskController = TextEditingController();
  final TextEditingController _selectedDateController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  DateTime? selectedDate;
  List<String>? tags;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TaskListBloc()..add(GetTaskEvent(taskId: widget.taskId)),
      child: BlocBuilder<TaskListBloc, TaskListState>(
        builder: (context, state) {
          if (state is GetTaskSuccess) {
            final task = state.tasks;
            _titleTaskController.text = task[0]['title'];
            _commentController.text = task[0]['comment'] ?? '';
            _descriptionController.text = task[0]['description'] ?? '';
            _tagsController.text = task[0]['tags'] != '' ? task[0]['tags'] : '';
            selectedDate = task[0]['due_date'] == null
                ? null
                : DateTime.parse(task[0]['due_date']);
            _selectedDateController.text = selectedDate.toString();
            return AlertDialog(
              title: const Text('Editar Tarea'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        border: OutlineInputBorder(),
                      ),
                      controller: _titleTaskController,
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Comentarios',
                        border: OutlineInputBorder(),
                      ),
                      controller: _commentController,
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                      controller:
                          _descriptionController, // Cambiar por el controller
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Tags',
                        border: OutlineInputBorder(),
                      ),
                      controller: _tagsController,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Llamar al bloc para actualizar la tarea
                    BlocProvider.of<TaskListBloc>(context).add(UpdateTaskEvent(
                      taskId: widget.taskId,
                      description: _descriptionController.text,
                      comment: _commentController.text,
                      tags: _tagsController.text.split(','),
                      selectedDate: selectedDate,
                    ));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
