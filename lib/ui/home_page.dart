
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:to_do_app/services/theme_services.dart';

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
      body: const Column(
        children: [
          Text("Theme Datas",
          style: TextStyle(
            fontSize: 30
          ),
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
