import 'package:digital_wellbeing/app_usage.dart';
import 'package:digital_wellbeing/splash_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'graphs/bar_graph.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  var nameFromHome;

  MyHomePage(this.nameFromHome);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Digital Wellbeing', style: TextStyle(color: Colors.white, fontSize: 16),),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Center(

            child: Column(

              children: [
                SizedBox(

                  height: 300,
                  child: BarGraph(),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 0.5,
                ),
                Container(

                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),

                    ),
                    child: AppUsage())
              ],
            ),
          ),
        ));
  }
}
