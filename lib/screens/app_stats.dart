import 'package:digital_wellbeing/models/app_info.dart';
import 'package:digital_wellbeing/service/format_time.dart';
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
              style: const TextStyle(color: Colors.white, fontSize: 16),),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 50,),
                FutureBuilder<Map<String, double>>(
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
                const SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    left: 10,
                    right: 10,
                  ),
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Total Screen Time (Last Week)",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      FutureBuilder(
                          future: WeeklyAppUsage(appName),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else {
                              return Text(formatTime(snapshot.data!.values.reduce((a, b) => a + b).toInt()),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ));
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
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