import 'package:flutter/cupertino.dart';
import 'package:to_do_app/services/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:to_do_app/ui/theme.dart';
import 'package:to_do_app/ui/widgets/input_field.dart';

class UpdateTaskPage extends StatefulWidget {
  final Task task; // Receive task object

  const UpdateTaskPage({Key? key, required this.task}) : super(key: key);

  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30 PM";
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();

  int _selectedColor = 0;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.task.title ?? '';
    _noteController.text = widget.task.note ?? '';
    _selectedDate = widget.task.date; // Directly assign DateTime
    _startTime = widget.task.startTime ?? _startTime;
    _endTime = widget.task.endTime ?? _endTime;
    _selectedColor = widget.task.color; // Assuming task.color is an int
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Update Task", style: headingStyle),
              InputField(
                title: "Title",
                hint: "Enter your title",
                controller: _titleController,
              ),
              InputField(
                title: "Note",
                hint: "Enter your Note",
                controller: _noteController,
              ),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: InputField(
                          title: "Start time",
                          hint: _startTime,
                          widget: IconButton(
                            onPressed: () {
                              _getTimeFromUser(true);
                            },
                            icon: Icon(Icons.access_time_rounded, color: Colors.grey),
                          ))),
                  SizedBox(width: 12),
                  Expanded(
                      child: InputField(
                          title: "End time",
                          hint: _endTime,
                          widget: IconButton(
                            onPressed: () {
                              _getTimeFromUser(false);
                            },
                            icon: Icon(Icons.access_time_rounded, color: Colors.grey),
                          ))),
                ],
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalette(),
                  ElevatedButton(
                    onPressed: () {
                      _validateData();
                    },
                    child: _isLoading ? CircularProgressIndicator() : Text("Update Task"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateData() async {
    setState(() {
      _isLoading = true;
    });
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      // Print task to the terminal
      print("Task Title: ${_titleController.text}");
      print("Task Note: ${_noteController.text}");
      print("Task Date: ${DateFormat.yMd().format(_selectedDate)}");
      print("Start Time: $_startTime");
      print("End Time: $_endTime");
      print("Color: $_selectedColor");

      // Create Task Map to send to the API
      Map<String, dynamic> task = {
        "title": _titleController.text,
        "note": _noteController.text,
        "isCompleted": false, // Change this as per your requirement
        "date": _selectedDate.toIso8601String(),
        "startTime": _startTime,
        "endTime": _endTime,
        "color": _selectedColor,
      };

      // Update task in the API
      final response = await http.put(
        Uri.parse(
            'https://to-do-app-api-4gdtqcnt5-jasmines-projects-f07974e7.vercel.app/update-to_do_list/${widget.task.id}'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'sbp_60f95df07af3b87486bcc73956b5dfd0df9aea9d',
        },
        body: jsonEncode(task),
      );

      print(response.statusCode);
      print(widget.task.id);

      // Check response from API
      if (response.statusCode == 200) {
        print("Task successfully updated in the database.");
        // Navigate back to home page and pass a signal to refresh the task list
        Get.back(result: true);
      } else {
        print("Failed to update task. ${response.body}");
      }
    } else {
      // Show error if input is invalid
      Get.snackbar(
        "Required",
        "All fields required!",
        snackPosition: SnackPosition.BOTTOM,
        colorText: pinkclr,
        backgroundColor: Colors.white,
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        SizedBox(height: 8.0),
        Wrap(
          children: List<Widget>.generate(
            3,
                (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: index == 0
                        ? primaryClr
                        : index == 1
                        ? pinkclr
                        : yellowClr,
                    child: _selectedColor == index
                        ? Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 16,
                    )
                        : Container(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("images/profile.jpg"),
        ),
        SizedBox(width: 20),
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2019),
        lastDate: DateTime(2090));

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
        print(_selectedDate);
      });
    } else {
      print("Please insert a valid date.");
    }
  }

  _getTimeFromUser(bool isStartTime) async {
    var _pickedTime = await _showTimePicker();
    String _formattedTime = _pickedTime.format(context);
    if (_pickedTime == null) {
      print("Please insert a valid time");
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formattedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formattedTime;
      });
    }
  }

  _showTimePicker() {
    return showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(":")[0]),
          minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        ));
  }
}