import 'package:datalocal/datalocal.dart';
import 'package:flutter/material.dart';
import 'package:fluttnotes/providers/reminders_provider.dart';
import 'package:provider/provider.dart';

class RemindersFormScreen extends StatefulWidget {
  final DataItem? value;
  const RemindersFormScreen({super.key, this.value});

  @override
  State<RemindersFormScreen> createState() => _RemindersFormScreenState();
}

class _RemindersFormScreenState extends State<RemindersFormScreen> {
  TextEditingController titleController = TextEditingController();
  List<Map<String, dynamic>> controllers = [
    {
      "controller": TextEditingController(),
      "checklist": false,
    }
  ];
  DateTime? date;
  DataItem? data;

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      data = widget.value!;
      titleController.text = data!.get("title");
      controllers = List<Map<String, dynamic>>.from(data!.get("content") ?? {})
          .map((e) => {
                "controller":
                    TextEditingController(text: e['controller'] ?? ""),
                "checklist": e['checklist'],
              })
          .toList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    RemindersProvider r = Provider.of<RemindersProvider>(context);
    return PopScope(
      canPop: true,
      onPopInvoked: (_) async {
        r.onSave(
          date: date,
          title: titleController.text,
          content: controllers
              .map((e) => {
                    "controller": e['controller'].text,
                    "checklist": e['checklist'],
                  })
              .toList(),
          id: data?.id,
        );
        // Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
        ),
        body: Column(
          children: List.generate(controllers.length, (index) {
            return SizedBox(
              width: width,
              child: Column(
                children: [
                  if (index == 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          hintText: "Title",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  SizedBox(
                    width: width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Checkbox(
                            value: controllers[index]['checklist'] ?? false,
                            onChanged: (_) {
                              controllers[index]['checklist'] = _;
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: SizedBox(
                            width: width,
                            // color: Colors.black,
                            child: TextField(
                              controller: controllers[index]['controller'],
                              minLines: 1,
                              maxLines: 10,
                              maxLength: 250,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Input task here...",
                                counterText: "",
                              ),
                            ),
                          ),
                        ),
                        if (index > 0)
                          InkWell(
                            onTap: () {
                              controllers.removeAt(index);
                              setState(() {});
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              child: const Icon(
                                Icons.delete,
                              ),
                            ),
                          ),
                        const SizedBox(
                          width: 16,
                        ),
                      ],
                    ),
                  ),
                  if (index + 1 == controllers.length)
                    Column(
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          child: InkWell(
                            onTap: () {
                              controllers.add({
                                "controller": TextEditingController(),
                                "checklist": false,
                              });
                              setState(() {});
                            },
                            child: Container(
                              width: width,
                              color: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "Add",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
