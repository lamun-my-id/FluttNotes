import 'package:datalocal/datalocal.dart';
import 'package:datalocal/datalocal_extension.dart';
import 'package:flutter/material.dart';
import 'package:fluttnotes/providers/app_provider.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    AppProvider a = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("FluttNotes"),
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Column(
            children: [
              // Column(
              //   children: [
              //     Container(
              //       width: width,
              //       height: 40,
              //       alignment: Alignment.centerLeft,
              //       child: Text(
              //         "Cloud Services",
              //         style: TextStyle(
              //           color: Colors.grey[500]!,
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       width: width,
              //       height: 40,
              //       child: const Row(
              //         children: [
              //           Expanded(
              //             child: Text(
              //               "Lamun Cloud",
              //               maxLines: 1,
              //               overflow: TextOverflow.ellipsis,
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //           ),
              //           SizedBox(
              //             width: 4,
              //           ),
              //           Text(
              //             "Off",
              //             style: TextStyle(
              //               color: Color(0xFF1F325D),
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //           SizedBox(
              //             width: 4,
              //           ),
              //           Icon(
              //             Icons.chevron_right_outlined,
              //           ),
              //         ],
              //       ),
              //     ),
              //     SizedBox(
              //       width: width,
              //       height: 40,
              //       child: const Row(
              //         children: [
              //           Expanded(
              //             child: Text(
              //               "Delete notes in the cloud",
              //               maxLines: 1,
              //               overflow: TextOverflow.ellipsis,
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //           ),
              //           Icon(
              //             Icons.chevron_right_outlined,
              //           ),
              //         ],
              //       ),
              //     ),
              //     const Divider(),
              //   ],
              // ),
              Column(
                children: [
                  Container(
                    width: width,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Style",
                      style: TextStyle(
                        color: Colors.grey[500]!,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Map<String, dynamic>? result =
                          await showDialog<Map<String, dynamic>?>(
                        context: context,
                        builder: (_) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Material(
                              color: Colors.black.withOpacity(0.25),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  child: Container(
                                    width: 250,
                                    height: a.fontSizeOptions.length * 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: a.fontSizeOptions.map((e) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.pop(context, e);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            height: 50,
                                            width: 250,
                                            alignment: Alignment.centerLeft,
                                            child: Text(e['id']),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      if (result != null) {
                        a.changeFontSize(result);
                      }
                    },
                    child: SizedBox(
                      width: width,
                      height: 40,
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Font Size",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            ("${a.appSetting.get(DataKey("fontSize.id")) ?? ""}"),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          const Icon(
                            Icons.chevron_right_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Map<String, dynamic>? result =
                          await showDialog<Map<String, dynamic>?>(
                        context: context,
                        builder: (_) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Material(
                              color: Colors.black.withOpacity(0.25),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                  child: Container(
                                    width: 250,
                                    height: a.sortOptions.length * 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: a.sortOptions.map((e) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.pop(context, e);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                            ),
                                            height: 50,
                                            width: 250,
                                            alignment: Alignment.centerLeft,
                                            child: Text(e['id']),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      if (result != null) {
                        a.changeSort(result);
                      }
                    },
                    child: SizedBox(
                      width: width,
                      height: 40,
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Sort",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            "${a.appSetting.get(DataKey("sort.id")) ?? ""}",
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          const Icon(
                            Icons.chevron_right_outlined,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Divider(),
                ],
              ),
              // Column(
              //   children: [
              //     Container(
              //       width: width,
              //       height: 40,
              //       alignment: Alignment.centerLeft,
              //       child: Text(
              //         "Reminders",
              //         style: TextStyle(
              //           color: Colors.grey[500]!,
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       width: width,
              //       height: 40,
              //       child: const Row(
              //         children: [
              //           Expanded(
              //             child: Text(
              //               "Set Notification",
              //               maxLines: 1,
              //               overflow: TextOverflow.ellipsis,
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //           ),
              //           SizedBox(
              //             width: 4,
              //           ),
              //           Text(
              //             "Off",
              //           ),
              //           SizedBox(
              //             width: 4,
              //           ),
              //           Icon(
              //             Icons.chevron_right_outlined,
              //           ),
              //         ],
              //       ),
              //     ),
              //     const SizedBox(
              //       height: 16,
              //     ),
              //     const Divider(),
              //   ],
              // ),
              // Column(
              //   children: [
              //     Container(
              //       width: width,
              //       height: 40,
              //       alignment: Alignment.centerLeft,
              //       child: Text(
              //         "Other",
              //         style: TextStyle(
              //           color: Colors.grey[500]!,
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       width: width,
              //       height: 40,
              //       child: const Row(
              //         children: [
              //           Expanded(
              //             child: Text(
              //               "Privacy Policy",
              //               maxLines: 1,
              //               overflow: TextOverflow.ellipsis,
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //           ),
              //           Icon(
              //             Icons.chevron_right_outlined,
              //           ),
              //         ],
              //       ),
              //     ),
              //     const SizedBox(
              //       height: 16,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
