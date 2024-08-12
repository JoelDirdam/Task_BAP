import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_bap/helpers/helper.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>
    with WidgetsBindingObserver {
  final List<Map<String, dynamic>> tasks = [
    {
      "id": 2272,
      "title": "Esto es una prueba",
      "is_completed": 0,
      "due_date": "2024-08-10"
    },
    {
      "id": 2273,
      "title": "Esto es otra prueba",
      "is_completed": 0,
      "due_date": "2024-08-10"
    }
  ];

  IconData prefixIcon = Icons.add;
  bool showSuffixIcons = false;
  DateTime? selectedDate;
  String? comment;
  String? description;
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
        title: Image.asset(
          'lib/assets/images/taskBAP.png',
          width: 90.w,
        ),
        actions: const [
          IconButton(
            icon: Icon(Icons.view_headline, color: Colors.deepPurpleAccent),
            onPressed: null,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: ListView.builder(
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
                title: Text(
                  tasks[index]['title'],
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
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 226, 226, 226),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            color: const Color.fromARGB(255, 226, 226, 226),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: TextField(
                onChanged: _onTextChanged,
                onEditingComplete: () {
                  print('Tarea agregada');
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
                                  color: selectedDate != null
                                      ? Colors.black54
                                      : Colors.black12,
                                  size: 14.w),
                              onPressed: () {
                                _selectDate(context);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.comment,
                                  color: comment != null && comment!.isNotEmpty
                                      ? Colors.black54
                                      : Colors.black12,
                                  size: 14.w),
                              onPressed: () {
                                showTextDialog(
                                        context,
                                        comment,
                                        'Agregar Comentario',
                                        'Escribe tu comentario aquí...')
                                    .then((value) {
                                  setState(() {
                                    log('Comentario: $value');
                                    comment =
                                        value; // Actualizar el comentario con el valor devuelto
                                  });
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.description,
                                  color: Colors.black12, size: 14.w),
                              onPressed: () {
                                showTextDialog(
                                        context,
                                        description,
                                        'Agregar Descripción',
                                        'Escribe tu descripción aquí...')
                                    .then((value) {
                                  setState(() {
                                    log('Comentario: $value');
                                    description =
                                        value; // Actualizar el comentario con el valor devuelto
                                  });
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.label,
                                  color: tags != null && tags!.isNotEmpty
                                      ? Colors.black54
                                      : Colors.black12,
                                  size: 14.w),
                              onPressed: () {
                                showTagsDialog(context, tags).then((value) {
                                  setState(() {
                                    tags = value;
                                    print('Tags: ${tags?.join(', ')}');
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
    );
  }

  Future<void> _selectDate(BuildContext context) async {
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

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}
