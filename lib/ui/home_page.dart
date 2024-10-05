import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      body: Column(
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
    leading: GestureDetector(
      onTap:(){
        ThemeService().switchTheme();
      },
      child: Icon(Icons.nightlight_round, size: 20,),
    ),
    actions: [
      Icon(Icons.person, size: 20,),
      SizedBox(width: 20,),
    ],
  );
}
