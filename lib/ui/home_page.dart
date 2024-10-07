import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/services/theme_services.dart';
import 'package:to_do_app/ui/add_task_bar.dart';
import 'package:to_do_app/ui/theme.dart';
import 'package:to_do_app/ui/widgets/button.dart';
import 'package:to_do_app/services/models.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  List<Task> listTask = [];

  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchToDo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          Expanded(child: _showTaskList()),  // Use Expanded here
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
        monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;  // Make sure state updates on date change
          });
        },
      ),
    );
  }

  _fetchToDo() async {
    print('Fetching To-Do tasks');
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(Uri.parse(
          'https://to-do-app-api-35tym5f4b-jasmines-projects-f07974e7.vercel.app/to_do_list'));
      if (response.statusCode == 200) {
        print('Response received');
        List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          listTask = jsonData.map((task) => Task.fromMap(task)).toList();
        });
      } else {
        print('Failed with status code: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print("Error fetching tasks: $e");
    } setState(() {
      _isLoading = false;
    });
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                "Today",
                style: headingStyle,
              )
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              // Navigate to AddTaskPage and wait for the result
              final result = await Get.to(() => const AddTaskPage());

              // If a task was successfully added, refresh the task list
              if (result == true) {
                _fetchToDo();
              }
            },
            child: Text("+ Add Task"),
          )
        ],
      ),
    );
  }


  _appBar() {
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
        },
        child: Icon(
            Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("images/profile.jpg"),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  _showTaskList() {
    return _isLoading
        ? Center(
      child: CircularProgressIndicator(), // Display loading animation
    )
        : ListView.builder(
      itemCount: listTask.length,
      itemBuilder: (context, index) {
        return _taskTile(listTask[index]);
      },
    );
  }

  Widget _taskTile(Task task) {
    return ListTile(
      title: Text(task.title ?? 'No Title'),
      subtitle: Text(task.note ?? 'No Description'),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          // Add delete functionality here
        },
      ),
    );
  }
}
