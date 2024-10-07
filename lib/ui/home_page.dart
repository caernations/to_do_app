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
  final List<Color> taskColors = [
    softBluishClr,  // Color for parameter 0
    yellowClr,  // Color for parameter 1
    pinkclr,    // Color for parameter 2
  ];

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
          SizedBox(height: 20,),
          Expanded(child: _showTaskList()), // Use Expanded here
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
            _selectedDate = date; // Make sure state updates on date change
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
    }
    setState(() {
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

  // Delete task from the server
  _deleteTask(int? taskId) async {
    setState(() {
      _isLoading = true; // Show loading indicator while deleting
    });
    try {
      final response = await http.delete(Uri.parse(
          'https://to-do-app-api-35tym5f4b-jasmines-projects-f07974e7.vercel.app/delete-to_do_list/$taskId'));
      if (response.statusCode == 200) {
        print('Task deleted successfully');
        // After deleting, refresh the task list
        _fetchToDo();
      } else {
        print('Failed to delete task with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error deleting task: $e");
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator after deletion
      });
    }
  }

  // Confirm delete dialog
  Future<bool> _showDeleteConfirmationDialog(String? taskTitle) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Delete Task'),
            content: Text(
                'Are you sure you want to delete the task "$taskTitle"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
    ) ??
        false; // Return false if dialog is dismissed
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
    // Filter tasks by selected date
    List<Task> filteredTasks = listTask.where((task) {
      // Convert the task date to a String and then parse it back to DateTime
      DateTime taskDate = task.date ?? DateTime.now(); // Use a default value if task.date is null
      String formattedTaskDate = DateFormat.yMd().format(taskDate); // Convert DateTime to String
      return formattedTaskDate == DateFormat.yMd().format(_selectedDate);
    }).toList();

    return _isLoading
        ? Center(
      child: CircularProgressIndicator(), // Display loading animation
    )
        : filteredTasks.isEmpty
        ? Center(child: Text("No tasks for the selected date."))
        : ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        return _taskTile(filteredTasks[index]);
      },
    );
  }

  void _showTaskDetailsDialog(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            task.title ?? 'No Title',
            style: GoogleFonts.lato(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  task.note ?? 'No Description',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Due Date: ${task.endTime ?? 'No Due Date'}',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Completed: ${task.isCompleted == true ? 'Yes' : 'No'}',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Close',
                style: TextStyle(color: primaryClr),
              ),
            ),
          ],
        );
      },
    );
  }



  Widget _taskTile(Task task) {
    return GestureDetector( // Wrap with GestureDetector to capture taps
      onTap: () {
        _showTaskDetailsDialog(task); // Show the dialog when tile is tapped
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        color: taskColors[task.color], // Set background color based on colorIndex
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                task.title ?? 'No Title',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Set text color for better visibility
                ),
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                task.note ?? 'No Description',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              // Due Date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    task.endTime ?? 'No Due Date',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Completion Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Completed:',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Checkbox(
                    value: task.isCompleted ?? false,
                    onChanged: (bool? newValue) async {
                      setState(() {
                        task.isCompleted = newValue!;
                      });

                      // Call the function to update task status in backend
                      await _updateTaskStatus(task.id, task.isCompleted);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      bool shouldDelete = await _showDeleteConfirmationDialog(task.title);
                      if (shouldDelete) {
                        _deleteTask(task.id); // Delete task from database
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }



// Function to update task status in backend
  Future<void> _updateTaskStatus(int? taskId, bool? isCompleted) async {
    try {
      // Toggle the completion status
      bool updatedStatus = !(isCompleted ?? false);

      final response = await http.patch(
        Uri.parse(
            'https://to-do-app-api-35tym5f4b-jasmines-projects-f07974e7.vercel.app/update-to_do_list/$taskId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'sbp_60f95df07af3b87486bcc73956b5dfd0df9aea9d'
        },

        // Send the updated status
        body: jsonEncode({"isCompleted": updatedStatus}),
      );

      if (response.statusCode == 200) {
        print('Task status updated successfully to $updatedStatus');
      } else {
        print('Failed to update task status with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error updating task status: $e");
    }
  }
}