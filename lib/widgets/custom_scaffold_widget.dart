import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomScaffoldWidget extends StatelessWidget {
  final Widget body;
  final Widget? bottomSheet;
  final Widget? endDrawer;

  const CustomScaffoldWidget({
    super.key,
    required this.body,
    this.bottomSheet,
    this.endDrawer,
  });

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
          // IconButton(
          //   icon: Icon(Icons.view_headline, color: Colors.deepPurpleAccent),
          //   onPressed: null,
          // ),
        ],
      ),
      endDrawer: endDrawer,
      body: body,
      backgroundColor: const Color.fromARGB(255, 226, 226, 226),
      bottomSheet: bottomSheet,
    );
  }
}
