import 'package:datalocal/datalocal.dart';
import 'package:datalocal/utils/date_time.dart';
import 'package:flutter/material.dart';
import 'package:fluttnotes/providers/notes_provider.dart';
import 'package:provider/provider.dart';

class NotesFormScreen extends StatefulWidget {
  final DataItem? value;
  const NotesFormScreen({super.key, this.value});

  @override
  State<NotesFormScreen> createState() => _NotesFormScreenState();
}

class _NotesFormScreenState extends State<NotesFormScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  late DateTime time;
  DataItem? data;

  @override
  void initState() {
    super.initState();
    data = widget.value;
    if (data != null) {
      titleController.text = data!.get("title");
      contentController.text = data!.get("content");
      time = data!.createdAt ?? DateTime.now();
    } else {
      time = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    NotesProvider n = Provider.of<NotesProvider>(context);
    return PopScope(
      canPop: true,
      onPopInvoked: (_) async {
        n.onSave(
          title: titleController.text,
          content: contentController.text,
          id: data?.id,
        );
        // Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none,
                ),
              ),
              SizedBox(
                width: width,
                child: Text(
                  DateTimeUtils.dateFormat(time, format: "MMMM dd HH:mm") ?? "",
                  style: TextStyle(
                    color: Colors.grey[400]!,
                    fontSize: 12,
                  ),
                ),
              ),
              TextFormField(
                controller: contentController,
                minLines: 5,
                maxLines: 100,
                decoration: const InputDecoration(
                  hintText: "Start Typing",
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
