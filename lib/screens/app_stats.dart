import 'package:digital_wellbeing/models/app_info.dart';
import 'package:digital_wellbeing/service/event_stats/event_stats.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:digital_wellbeing/service/format_time.dart';
import 'package:flutter/material.dart';
import 'package:digital_wellbeing/service/usage_stats/usage_stats.dart';
import 'package:digital_wellbeing/components/bar_chart/bar_graph.dart';
import 'package:digital_wellbeing/service/utility/limit_string_length.dart';

//eventTypeHash
final Map<int, String> eventTypeHash = {
  0: 'NONE',
  1: 'ACTIVITY_RESUMED',
  2: 'ACTIVITY_PAUSED',
  3: 'ACTIVITY_DESTROYED',
  4: 'ACTIVITY_STOPPED',
  5: 'CONFIGURATION_CHANGED',
  6: 'ACTIVITY_RECREATED',
  7: 'USER_INTERACTION',
  8: 'SHORTCUT_INVOCATION',
  9: 'ACTIVITY_CREATED',
  10: 'STAND_BY_BUCKET_ACTIVE',
  11: 'STAND_BY_BUCKET_CHANGED',
  12: 'NOTIFICATION_INTERRUPTION',
  13: 'KEYGUARD_SHOWN',
  14: 'KEYGUARD_HIDDEN',
  15: 'SCREEN_INTERACTIVE',
  16: 'SCREEN_NON_INTERACTIVE',
  17: 'KEYGUARD_SHOWN',
  18: 'KEYGUARD_HIDDEN',
  19: 'FOREGROUND_SERVICE_START',
  20: 'FOREGROUND_SERVICE_STOP',
  21: 'DEVICE_SCREEN_OFF',
  22: 'DEVICE_SCREEN_UNLOCK',
  23: 'ACTIVITY_STOPPED',
  24: 'DEVICE_SCREEN_USER_PRESENT',
  25: 'DEVICE_SCREEN_TURNED_ON',
  26: 'DEVICE_SCREEN_TURNED_OFF',
  27: 'DEVICE_SCREEN_UNLOCKED',
  28: 'DEVICE_SCREEN_LOCKED',
  29: 'DEVICE_SCREEN_USER_PRESENTED',
  30: 'DEVICE_SCREEN_TURNED_ONED',
  31: 'DEVICE_SCREEN_TURNED_OFFED',
  32: 'DEVICE_SCREEN_UNLOCKED',
  33: 'DEVICE_SCREEN_LOCKED',
  34: 'DEVICE_SCREEN_USER_PRESENTED',
  35: 'DEVICE_SCREEN_TURNED_ONED',
  36: 'DEVICE_SCREEN_TURNED_OFFED',
  37: 'DEVICE_SCREEN_UNLOCKED',
  38: 'DEVICE_SCREEN_LOCKED',
  39: 'DEVICE_SCREEN_USER_PRESENTED',
  40: 'DEVICE_SCREEN_TURNED_ONED',
  41: 'DEVICE_SCREEN_TURNED_OFFED',
  42: 'DEVICE_SCREEN_UNLOCKED',
  43: 'DEVICE_SCREEN_LOCKED',
  44: 'DEVICE_SCREEN_USER_PRESENTED',
  45: 'DEVICE_SCREEN_TURNED_ONED',
  46: 'DEVICE_SCREEN_TURNED_OFFED',
  47: 'DEVICE_SCREEN_UNLOCKED',
  48: 'DEVICE_SCREEN_LOCKED',
};

class AppScreenTimePage extends StatefulWidget {
  final String appName;

  const AppScreenTimePage({Key? key, required this.appName}) : super(key: key);

  @override
  _AppScreenTimePageState createState() => _AppScreenTimePageState();
}

class _AppScreenTimePageState extends State<AppScreenTimePage> {
  late Future<Map<String, double>> _weeklyData;
  late String _activeButton;
  late Future<List<EventUsageInfo>> _appEventLogs;

  @override
  void initState() {
    super.initState();
    _weeklyData = CurrentWeekAppUsage(widget.appName);
    _activeButton = "Current Week";
    _appEventLogs = getAppEventLogs(widget.appName);
  }

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
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          children: [
            Image.asset(
              appInfoMap[widget.appName]?['imagePath'] ??
                  'assets/apps/default_app.png',
              width: 30,
            ),
            const SizedBox(width: 10,),
            Text(appInfoMap[widget.appName]?['name'] ?? limit_string_length(widget.appName),
              overflow: TextOverflow.fade,
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
                // option to switch between current week and previous week
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _weeklyData = CurrentWeekAppUsage(widget.appName);
                          _activeButton = 'Current Week';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _activeButton == 'Current Week'
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Current Week',
                          style: TextStyle(color: _activeButton == 'Current Week'
                              ? Colors.white
                              : Theme.of(context).colorScheme.primary
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _weeklyData = PreviousWeekAppUsage(widget.appName);
                          _activeButton = 'Previous Week';
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _activeButton == 'Current Week'
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                              : Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('Previous Week',
                        style: TextStyle(color: _activeButton == 'Current Week'
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white
                        ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50,),
                FutureBuilder<Map<String, double>>(
                  future: _weeklyData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      // Display bar chart with weekly app usage data
                      // print(snapshot.data!);
                      return Container(
                        height: 220,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                          "Total Screen Time ${
                              _activeButton == 'Current Week' ? 'This Week' : 'Previous Week'

                          }",
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
                          future: _weeklyData,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            else if (snapshot.data!.isEmpty) {
                              return const Text(
                                'No data available',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )
                              );
                            }
                            else {
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
                  height: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            "App Event Logs",
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
                            future: _appEventLogs,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              else if (snapshot.data!.isEmpty) {
                                return const Text(
                                    'No data available',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                    )
                                );
                              }
                              else {
                                return Column(
                                  children: [
                                    for (var event in snapshot.data!)
                                      ListTile(
                                        leading: Image.asset(
                                          appInfoMap[widget.appName]?['imagePath'] ??
                                              'assets/apps/default_app.png',
                                          width: 30,
                                        ),
                                        title: Text(eventTypeHash[int.parse(event.eventType!)] ?? 'Unknown Event',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          DateTime.fromMillisecondsSinceEpoch(int.parse(event.timeStamp!)).toString().substring(0, 19),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                  ],
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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