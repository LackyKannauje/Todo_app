import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/const.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int appbar_color = 1;
var task_name = TextEditingController();
var task_desc = TextEditingController();

List<String> task = [];
List<String> time = [];
List<String> description = [];

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    loadTasks();
    appbar_color = Random().nextInt(7);
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      task = prefs.getStringList('task') ?? [];
      time = prefs.getStringList('time') ?? [];
      description = prefs.getStringList('description') ?? [];
    });
  }

  void saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('task', task);
    prefs.setStringList('time', time);
    prefs.setStringList('description', description);
  }

  bool isSorted = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: b_color[appbar_color],
        title: Text("TO-DO APP"),
        actions: [
          GestureDetector(
              onTap: () {
                setState(() {
                  isSorted = !isSorted;
                });
              },
              child: Icon(Icons.swap_vert)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container(
                          height: 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "You want to Delete All task",
                                style: TextStyle(fontSize: 15),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                        color: b_color[appbar_color],
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        task.clear();
                                        time.clear();
                                        description.clear();
                                        saveTasks();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(
                                        color: b_color[appbar_color],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        title: Text(
                          "Alert !!!",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      );
                    },
                  );
                },
                child: Icon(Icons.delete_forever)),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!task.isEmpty) {
            task_name.clear();
            task_desc.clear();
          }
          makeTask("Add Task", context, false, 0);
        },
        backgroundColor: b_color[appbar_color],
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        reverse: isSorted,
        shrinkWrap: isSorted,
        padding: EdgeInsets.symmetric(vertical: 5),
        itemCount: task.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[200]),
            child: ListTile(
              // tileColor: Colors.grey[300],
              title: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Title : " + task[index]),
                        content: Text("Description : " + description[index]),
                      );
                    },
                  );
                },
                child: Text(
                  task[index].isEmpty ? 'None' : task[index],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              subtitle: Text(
                time[index],
                style: TextStyle(fontSize: 12),
              ),
              leading: GestureDetector(
                onTap: () {
                  task_name.text = task[index];
                  task_desc.text = description[index];
                  makeTask("Confirm", context, true, index);
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: color[index % 7],
                      child: Text(
                          task[index].isEmpty
                              ? '?'
                              : task[index].characters.first.toUpperCase(),
                          style: TextStyle(color: Colors.white)),
                    ),
                    Positioned(
                      bottom: 1,
                      right: 1,
                      child: Icon(
                        Icons.edit_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),

              trailing: GestureDetector(
                  onTap: () {
                    setState(() {
                      task.removeAt(index);
                      time.removeAt(index);
                      description.removeAt(index);
                      saveTasks();
                    });
                  },
                  child: Icon(Icons.delete)),
            ),
          );
        },
      ),
    );
  }

  void makeTask(String operation, context, bool edit, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Enter Your Task",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                TextField(
                  controller: task_name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25)),
                    // hintText: 'Enter Task Title',
                    labelText: 'Title',
                    helperText: 'Example : go to market at 5pm',
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 5,
                  maxLines: 5,
                  controller: task_desc,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    // hintText: 'Enter Task Description',
                    labelText: 'Description',
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      DateTime now = DateTime.now();
                      if (edit) {
                        task[index] = task_name.text;
                        description[index] = task_desc.text;
                        time[index] =
                            DateFormat('EEE, d MMM yyyy, hh:mm a').format(now);
                      } else {
                        task.add(task_name.text);
                        description.add(task_desc.text);
                        time.add(
                            // "${now.day.toString()}-${now.month.toString()}-${now.year.toString()}"
                            DateFormat('EEE, d MMM yyyy, hh:mm a').format(now));
                      }
                      saveTasks();
                      Navigator.pop(context);
                      task_name.clear();
                      task_desc.clear();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: b_color[appbar_color],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      operation,
                      // "Add Task",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
