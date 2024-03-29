import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("FluttNotes"),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    width: width,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Cloud Services",
                      style: TextStyle(
                        color: Colors.grey[500]!,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    height: 40,
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Lamun Cloud",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Turn on",
                          style: TextStyle(
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.chevron_right_outlined,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width,
                    height: 40,
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Delete notes in the cloud",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_outlined,
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              ),
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
                  SizedBox(
                    width: width,
                    height: 40,
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Font Size",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Medium",
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.chevron_right_outlined,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width,
                    height: 40,
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Sort",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "By modification date",
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.chevron_right_outlined,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Divider(),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: width,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Reminders",
                      style: TextStyle(
                        color: Colors.grey[500]!,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    height: 40,
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Set Notification",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "Turn on",
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          Icons.chevron_right_outlined,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Divider(),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: width,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Other",
                      style: TextStyle(
                        color: Colors.grey[500]!,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    height: 40,
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Privacy Policy",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_outlined,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
