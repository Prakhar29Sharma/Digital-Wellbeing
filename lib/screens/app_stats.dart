import 'package:digital_wellbeing/models/app_info.dart';
import 'package:flutter/material.dart';

class AppScreenTimePage extends StatelessWidget {
  final String appName;

  const AppScreenTimePage({Key? key, required this.appName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Logic to fetch screen time for appName goes here
    // For now, let's assume you have a function to fetch screen time
    String screenTime = getScreenTimeForApp(appName);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          children: [
            Image.asset(
              appInfoMap[appName]?['imagePath'] ?? 'assets/apps/default_app.png',
              width: 30,
            ),
            const SizedBox(width: 10,),
            Text(appInfoMap[appName]?['name'] ?? appName, style: const TextStyle(color: Colors.white),),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Screen Time: $screenTime',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  // Function to fetch screen time for the app
  String getScreenTimeForApp(String appName) {
    return '2h 30m';
  }
}
