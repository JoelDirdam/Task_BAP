import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<String?> showTextDialog(BuildContext context, String? initialText,
    String title, String hintText) async {
  TextEditingController textController =
      TextEditingController(text: initialText);
  bool isOkButtonEnabled = initialText?.isNotEmpty ?? false;

  return await showDialog<String>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              controller: textController,
              onChanged: (text) {
                setState(() {
                  isOkButtonEnabled = text.isNotEmpty;
                });
              },
              decoration: InputDecoration(
                border: const UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 189, 179, 238)),
                ),
                hintText: hintText,
              ),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 189, 179, 238),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Cierra el popup sin devolver nada
                },
                child: const Text('CANCELAR'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 189, 179, 238),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pop(textController.text); // Devolver el texto ingresado
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<List<String>?> showTagsDialog(
    BuildContext context, List<String>? initialTags) async {
  TextEditingController textController = TextEditingController();
  List<String> tags = initialTags ?? [];

  return await showDialog<List<String>>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Agregar Tags'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      backgroundColor: const Color.fromARGB(255, 189, 179, 238),
                      onDeleted: () {
                        setState(() {
                          tags.remove(tag);
                        });
                      },
                    );
                  }).toList(),
                ),
                TextField(
                  controller: textController,
                  onSubmitted: (text) {
                    if (text.isNotEmpty) {
                      setState(() {
                        tags.addAll(text
                            .split(',')
                            .map((tag) => tag.trim())
                            .where((tag) => tag.isNotEmpty));
                        textController.clear();
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Escribe una nueva tag',
                    suffixIcon: IconButton(
                      color: const Color.fromARGB(255, 189, 179, 238),
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (textController.text.isNotEmpty) {
                          setState(() {
                            tags.addAll(textController.text
                                .split(',')
                                .map((tag) => tag.trim())
                                .where((tag) => tag.isNotEmpty));
                            textController.clear();
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: const Color.fromARGB(255, 189, 179, 238),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Cierra el popup sin devolver nada
                },
                child: const Text('CANCELAR'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 189, 179, 238),
                ),
                onPressed: () {
                  Navigator.of(context).pop(tags); // Devolver la lista de tags
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    },
  );
}
