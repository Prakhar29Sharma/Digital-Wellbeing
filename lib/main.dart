import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:usage_stats/usage_stats.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<EventUsageInfo> events = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initUsage();
    });
  }

  Future<void> initUsage() async {
    UsageStats.grantUsagePermission();
    DateTime endDate = DateTime.now();
    DateTime startDate = DateTime.now().toLocal().subtract(Duration(hours: DateTime.now().hour, minutes: DateTime.now().minute, seconds: DateTime.now().second, milliseconds: DateTime.now().millisecond, microseconds: DateTime.now().microsecond));

    List<EventUsageInfo> queryEvents =
    await UsageStats.queryEvents(startDate, endDate);

    setState(() {
      events = queryEvents.reversed.toList();
    });
  }

  HashMap appData = HashMap<String, int>();
  Map<String, Duration> appUsageDuration = {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Usage Stats"),
        ),
        body: ListView.separated(
            itemBuilder: (context, index) {
              var title = events[index].packageName;
              var eventType = events[index].eventType;
              var timeStamp = events[index].timeStamp;
              // print("Title: " + title!);
              // print("Event Type: " + eventType!);
              // print("Time Stamp: " + timeStamp!);
              // print(events[index].timeStamp);
              // if (appData.containsKey(title)) {
              //   appData[title] = appData[title] + 1;
              // } else {
              //   appData[title] = 1;
              // }
              // Assuming events is a List<EventUsageInfo> containing usage events sorted by timestamp


              for (int i = 0; i < events.length - 1; i++) {
                String currentApp = events[i].packageName!;
                DateTime currentEventTime =
                DateTime.fromMillisecondsSinceEpoch(int.parse(events[i].timeStamp!));

                for (int j = i+1; j < events.length; j++) {
                  if (events[i].packageName == events[j].packageName && (events[i].eventType == '23' && events[j].eventType == '1')) {
                    String nextApp = events[j].packageName!;
                    DateTime nextEventTime = DateTime.fromMillisecondsSinceEpoch(int.parse(events[j].timeStamp!));
                    Duration duration = currentEventTime.difference(nextEventTime);
                    appUsageDuration.update(currentApp, (value) => value + duration,
                        ifAbsent: () => duration);
                    break;
                  }
                }

                for (int j = i+1; j < events.length; j++) {
                  if (events[i].packageName == events[j].packageName && (events[i].eventType == '1' && events[j].eventType == '2')) {
                    String nextApp = events[j].packageName!;
                    DateTime nextEventTime = DateTime.fromMillisecondsSinceEpoch(int.parse(events[j].timeStamp!));
                    Duration duration = currentEventTime.difference(nextEventTime);
                    appUsageDuration.update(currentApp, (value) => value - duration,
                        ifAbsent: () => duration);
                    break;
                  }
                }

                // String nextApp = events[i + 1].packageName!;
                // DateTime nextEventTime =
                // DateTime.fromMillisecondsSinceEpoch(int.parse(events[i + 1].timeStamp!));
                //
                // if (currentApp == nextApp && (events[i].eventType == '1' && events[i + 1].eventType == '2')) {
                //   Duration duration = nextEventTime.difference(currentEventTime);
                //   appUsageDuration.update(currentApp, (value) => value + duration,
                //       ifAbsent: () => duration);
                // }
              }

              return ListTile(
                title: Text(title!),
                subtitle: Text(
                    "Last time used: ${DateTime.fromMillisecondsSinceEpoch(int.parse(timeStamp!)).toIso8601String()}"),
                trailing: Text(eventType!),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: events.length),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            initUsage();
            String formatDuration(Duration duration) {
              int hours = duration.inHours;
              int minutes = duration.inMinutes.remainder(60);
              return '$hours hours and $minutes minutes';
            }
            // Print or use appUsageDuration map to display or process app usage durations
            appUsageDuration.forEach((app, duration) {
              print('App: $app, Usage Duration: ${formatDuration(duration)}');
            });
          },
          mini: true,
          child: const Icon(
            Icons.refresh,
          ),
        ),
      ),
    );
  }
}