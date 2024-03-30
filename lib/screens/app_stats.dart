import 'package:digital_wellbeing/models/app_info.dart';
import 'package:flutter/material.dart';
import 'package:digital_wellbeing/service/usage_stats/usage_stats.dart';
import 'package:digital_wellbeing/components/bar_chart/bar_graph.dart';

class AppScreenTimePage extends StatelessWidget {
  final String appName;

  const AppScreenTimePage({Key? key, required this.appName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        title: Row(
          children: [
            Image.asset(
              appInfoMap[appName]?['imagePath'] ??
                  'assets/apps/default_app.png',
              width: 30,
            ),
            const SizedBox(width: 10,),
            Text(appInfoMap[appName]?['name'] ?? appName,
              style: const TextStyle(color: Colors.white),),
          ],
        ),
      ),
      body: Center(
        child: FutureBuilder<Map<String, double>>(
          future: WeeklyAppUsage(appName),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              // Display bar chart with weekly app usage data
              print(snapshot.data!);
              return SizedBox(
                height: 400,
                child: MyBarGraph(
                    weeklySummary: _prepareWeeklySummary(snapshot.data!)),
              );
            } else {
              return const Text('No data available');
            }
          },
        ),
      ),
    );
  }

  List<double> _prepareWeeklySummary(Map<String, double> weeklyData) {
    List<double> summary = List.filled(7, 0.0); // Initialize list with zeros

    // Map day names to their corresponding index in the summary list
    Map<String, int> dayIndex = {
      'Sun': 0,
      'Mon': 1,
      'Tue': 2,
      'Wed': 3,
      'Thu': 4,
      'Fri': 5,
      'Sat': 6,
    };

    // Update summary list with available data
    weeklyData.forEach((day, value) {
      if (dayIndex.containsKey(day)) {
        summary[dayIndex[day]!] = value.toDouble();
      }
    });

    return summary;
  }
}