import 'package:datalocal/datalocal.dart';
import 'package:datalocal/utils/date_time.dart';
import 'package:flutter/material.dart';
import 'package:fluttnotes/providers/app_provider.dart';
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

  bool isLoading = false;

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
    AppProvider a = Provider.of<AppProvider>(context);

    double fontSize = (a.appSetting.get("fontSize.value") ?? 14) * 1.0;

    Future<void> save() async {
      try {
        if (isLoading) throw "Sedang Loading";
        isLoading = true;
        setState(() {});
        DataItem? result = await n.save(
          title: titleController.text,
          content: contentController.text,
          id: data?.id,
        );
        if (result != null && data == null) {
          data = result;
        }
      } catch (e) {
        //
      }
      isLoading = false;
      setState(() {});
    }

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
                textInputAction: TextInputAction.go,
                onChanged: (_) => save(),
                decoration: const InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: fontSize,
                ),
              ),
              SizedBox(
                width: width,
                child: Text(
                  DateTimeUtils.dateFormat(time, format: "MMMM dd HH:mm") ?? "",
                  style: TextStyle(
                    color: Colors.grey[400]!,
                    fontSize: fontSize - 2,
                  ),
                ),
              ),
              TextFormField(
                controller: contentController,
                minLines: 5,
                maxLines: 100,
                onChanged: (_) => save(),
                decoration: const InputDecoration(
                  hintText: "Start Typing",
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
