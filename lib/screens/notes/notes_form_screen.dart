import 'package:datalocal/datalocal.dart';
import 'package:datalocal/datalocal_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttnotes/providers/app_provider.dart';
import 'package:fluttnotes/providers/notes_provider.dart';
import 'package:fluttnotes/utils/date_time_util.dart';
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
  FocusNode formFocus = FocusNode();

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

    Future<void> delete() async {
      FocusScope.of(context).requestFocus(FocusNode());
      showDialog(
        context: context,
        builder: (_) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Material(
              color: Colors.black.withOpacity(0.25),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: 16,
                    child: Container(
                      width: width,
                      constraints: const BoxConstraints(
                        maxWidth: 350,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: width,
                            alignment: Alignment.center,
                            child: const Text(
                              "Delete notes",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            width: width,
                            alignment: Alignment.center,
                            child: const Text(
                              "Delete this note?",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            height: 60,
                            width: width,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text("Cancel"),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      titleController.text = "";
                                      contentController.text = "";
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    splashColor: Colors.transparent,
                                    child: Container(
                                      height: 50,
                                      width: width,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
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
          actions: [
            if (data != null)
              IconButton(
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  showDialog(
                    context: context,
                    builder: (_) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Material(
                          color: Colors.black.withOpacity(0.25),
                          child: SafeArea(
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 16,
                                  top: 16,
                                  child: Container(
                                    width: 200,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          height: 60,
                                          width: 200,
                                          alignment: Alignment.centerLeft,
                                          child: const Text(
                                            "Share as Text",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          height: 60,
                                          width: 200,
                                          alignment: Alignment.centerLeft,
                                          child: const Text(
                                            "Share as Image",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            delete();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            height: 60,
                                            width: 200,
                                            alignment: Alignment.centerLeft,
                                            child: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.more_vert_outlined),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                minLines: 1,
                maxLines: 100,
                maxLength: 500,
                textInputAction: TextInputAction.go,
                onChanged: (_) => save(),
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(formFocus),
                decoration: const InputDecoration(
                  hintText: "Title",
                  border: InputBorder.none,
                  counterText: "",
                ),
                style: TextStyle(
                  fontSize: fontSize + 4,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: width,
                child: Text(
                  "${DateTimeUtils.dateFormat(time, format: "MMMM dd HH:mm", locale: "en") ?? ""} | ${contentController.text.length} characters",
                  style: TextStyle(
                    color: Colors.grey[400]!,
                    fontSize: fontSize - 2,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: width,
                child: TextField(
                  focusNode: formFocus,
                  controller: contentController,
                  minLines: 5,
                  maxLines: 5000,
                  onChanged: (_) => save(),
                  decoration: const InputDecoration(
                    hintText: "Start Typing",
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: fontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
