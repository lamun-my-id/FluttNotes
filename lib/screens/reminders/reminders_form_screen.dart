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
  bool isLoading = false;

  TextEditingController titleController = TextEditingController();
  List<Map<String, dynamic>> controllers = [
    {
      "controller": TextEditingController(),
      "checklist": false,
      "focus": FocusNode(),
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
                "focus": FocusNode(),
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

    save() async {
      try {
        if (isLoading) throw "Loading ...";
        isLoading = true;
        setState(() {});
        DataItem? result = await r.save(
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
        if (result != null) {
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: controllers.length,
          itemBuilder: (_, index) {
            return SizedBox(
              width: width,
              child: Column(
                children: [
                  if (index == 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      width: width,
                      child: TextField(
                        controller: titleController,
                        textInputAction: TextInputAction.go,
                        maxLines: 100,
                        minLines: 1,
                        maxLength: 250,
                        onSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(controllers.first['focus']);
                        },
                        onChanged: (_) => save(),
                        decoration: const InputDecoration(
                          hintText: "Title",
                          border: InputBorder.none,
                          counterText: "",
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
                              save();
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
                              focusNode: controllers[index]['focus'],
                              controller: controllers[index]['controller'],
                              textInputAction: TextInputAction.go,
                              onChanged: (_) => save(),
                              onSubmitted: (_) async {
                                controllers.insert(index + 1, {
                                  "controller": TextEditingController(),
                                  "checklist": false,
                                  "focus": FocusNode(),
                                });
                                setState(() {});
                                await Future.delayed(
                                    const Duration(milliseconds: 100));
                                FocusScope.of(context).requestFocus(
                                    controllers[index + 1]['focus']);
                              },
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xFF1F325D),
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
          },
        ),
      ),
    );
  }
}
