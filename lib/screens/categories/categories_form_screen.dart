import 'package:datalocal/datalocal.dart';
import 'package:datalocal/datalocal_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttnotes/providers/categories_provider.dart';
import 'package:fluttnotes/utils/date_time_util.dart';
import 'package:provider/provider.dart';

class CategoriesFormScreen extends StatefulWidget {
  final DataItem? value;

  const CategoriesFormScreen({super.key, this.value});

  @override
  State<CategoriesFormScreen> createState() => _CategoriesFormScreenState();
}

class _CategoriesFormScreenState extends State<CategoriesFormScreen> {
  TextEditingController nameController = TextEditingController();
  late DateTime time;
  DataItem? data;

  bool isLoading = false;
  FocusNode formFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    data = widget.value;
    if (data != null) {
      nameController.text = data!.get(DataKey("name"));
      time = data!.createdAt ?? DateTime.now();
    } else {
      time = DateTime.now();
    }
    FocusScope.of(context).requestFocus(formFocus);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    CategoriesProvider c = Provider.of<CategoriesProvider>(context);

    Future<void> save() async {
      try {
        if (isLoading) throw "Sedang Loading";
        isLoading = true;
        setState(() {});
        DataItem? result = await c.save(
          name: nameController.text,
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
                                      nameController.text = "";
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
        c.onSave(
          name: nameController.text,
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
                focusNode: formFocus,
                controller: nameController,
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
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: width,
                child: Text(
                  DateTimeUtils.dateFormat(time,
                          format: "MMMM dd HH:mm", locale: "en") ??
                      "",
                  style: TextStyle(
                    color: Colors.grey[400]!,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
