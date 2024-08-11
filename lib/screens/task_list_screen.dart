import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  IconData _prefixIcon = Icons.add;
  bool _showSuffixIcons = false;

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
      // Teclado se ha abierto
      _togglePrefixIcon();
    } else {
      // Teclado se ha cerrado
      _togglePrefixIcon();
    }
  }

  void _togglePrefixIcon() {
    setState(() {
      _prefixIcon =
          _prefixIcon == Icons.add ? Icons.circle_outlined : Icons.add;
    });
  }

  void _onTextChanged(String text) {
    setState(() {
      _showSuffixIcons = text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
        title: const Text(
          'Task BAP',
          style: TextStyle(color: Colors.deepPurpleAccent),
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
              color: Colors.deepPurple[900],
              child: ListTile(
                leading: Container(
                  constraints: BoxConstraints.expand(width: 10.w),
                  child: Icon(
                    tasks[index]['is_completed'] == 1
                        ? Icons.check_circle_outline
                        : Icons.circle_outlined,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  tasks[index]['title'],
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.white54,
                      size: 12.w,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${tasks[index]['due_date']}',
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 206, 206, 206),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            color: const Color.fromARGB(255, 206, 206, 206),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: TextField(
                onChanged: _onTextChanged,
                onEditingComplete: () {
                  print('Tarea agregada');
                },
                cursorColor: Colors.white,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.deepPurple[900],
                  hintText: 'Agregar una tarea',
                  hintStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(_prefixIcon, color: Colors.white),
                  suffixIcon: _showSuffixIcons
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.calendar_today,
                                  color: Colors.white, size: 14.w),
                              onPressed: () {
                                // Acción para la fecha
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.comment,
                                  color: Colors.white, size: 14.w),
                              onPressed: () {
                                // Acción para los comentarios
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.description,
                                  color: Colors.white, size: 14.w),
                              onPressed: () {
                                // Acción para la descripción
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.label,
                                  color: Colors.white, size: 14.w),
                              onPressed: () {
                                // Acción para los tags
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
}
