
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/services/theme_services.dart';
import 'package:to_do_app/ui/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).appBarTheme.backgroundColor);
    print(Theme.of(context).primaryColor);
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat.yMMMd().format(DateTime.now()),
                    style: subHeadingStyle,
                    ),
                    Text("Today", style: headingStyle,)
                  ],
                ),
              ),
            ],
          )
        ],
      ),

    );
  }
}

_appBar(){
  return AppBar(
    elevation: 0,
    leading: GestureDetector(
      onTap:(){
        ThemeService().switchTheme();
      },
      child: Icon(Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round, size: 20,
      color: Get.isDarkMode ? Colors.white : Colors.black),
    ),
    actions: const [
      CircleAvatar(
        backgroundImage: AssetImage("images/profile.jpg"),
      ),
      SizedBox(width: 20,),
    ],
  );
}
