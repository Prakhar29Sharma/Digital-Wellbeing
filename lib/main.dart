import 'dart:async';
import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  tzdata.initializeTimeZones();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<UsageInfo> appUsageStats = [];
  int totalScreenTime = 0;

  // Define a list of system app package names
  List<String> systemApps = [
    "com.android.launcher",
    "com.android.settings",
    "com.android.systemui",
    "com.android.providers.calendar",
    "com.android.stk",
    "com.android.ons",
    "com.android.se",
    "com.android.providers.settings",
    "com.android.providers.downloads",
    "com.android.providers.telephony",
    "com.android.providers.contacts",
    "com.android.providers.blockednumber",
    "com.android.providers.userdictionary",
    "com.android.phone",
    "com.android.providers.media.module",
    "com.android.providers.downloads.ui",
    "com.android.carrierconfig",
    "com.android.inputdevices",
    "com.android.bluetoothmidiservice",
    "com.coloros.alarmclock",
    "com.coloros.calculator",
    "com.google.android.googlequicksearchbox",
    "com.google.android.apps.nbu.paisa.user",
    "com.google.android.dialer",
    "com.google.android.gm",
    "com.oplus.safecenter",
    "com.oplus.wirelesssettings",
    "com.oppo.quicksearchbox",
    "com.oplus.screenshot",
    "android",
    "com.android.vending",
    "com.google.android.gms",
    "com.google.android.permissioncontroller",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      initUsage();
    });
  }

  Future<void> initUsage() async {
    UsageStats.grantUsagePermission();

    tz.Location ist = tz.getLocation('Asia/Kolkata');
    tz.TZDateTime now = tz.TZDateTime.now(ist);

    tz.TZDateTime startDate = tz.TZDateTime(
      ist,
      now.year,
      now.month,
      now.day,
      0, // Start from the beginning of the day
      0,
      0,
    );

    DateTime startDateUtc = startDate.toUtc();
    DateTime endDateUtc = now.toUtc();

    Map<String, UsageInfo> maxUsageMap = {};

    List<UsageInfo> usageStats =
    await UsageStats.queryUsageStats(startDateUtc, endDateUtc);

    for (var usageInfo in usageStats) {
      String packageName = usageInfo.packageName!;
      // Exclude system apps from calculation
      if (!systemApps.contains(packageName)) {
        if (!maxUsageMap.containsKey(packageName) ||
            int.parse(usageInfo.totalTimeInForeground ?? '0') >
                int.parse(maxUsageMap[packageName]?.totalTimeInForeground ?? '0')) {
          maxUsageMap[packageName] = usageInfo;
        }
      }
    }

    List<UsageInfo> result = maxUsageMap.values.toList();

    result.sort((a, b) => int.parse(b.totalTimeInForeground ?? '0')
        .compareTo(int.parse(a.totalTimeInForeground ?? '0')));

    int total = 0;
    for (var usageInfo in result) {
      total += int.parse(usageInfo.totalTimeInForeground ?? '0');
    }

    setState(() {
      appUsageStats = result;
      totalScreenTime = total;
    });
  }

  String formatTime(int milliseconds) {
    int seconds = (milliseconds / 1000).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String formattedTime = '';
    if (hours > 0) {
      formattedTime += '$hours hours ';
      minutes %= 60; // Correct minutes for hours
    }
    if (minutes > 0) {
      formattedTime += '$minutes minutes ';
    }
    formattedTime += '${seconds % 60} seconds';

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("App Usage Stats"),
        ),
        body: ListView.builder(
          itemCount: appUsageStats.length,
          itemBuilder: (context, index) {
            var title = appUsageStats[index].packageName;
            var subtitle = formatTime(
                int.parse(appUsageStats[index].totalTimeInForeground ?? '0'));
            return ListTile(
              title: Text(title ?? ""),
              subtitle: Text("Total Time Used: $subtitle"),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            initUsage();
            for (var usageInfo in appUsageStats) {
              print(
                  "${usageInfo.packageName}: ${usageInfo.totalTimeInForeground}");
            }
          },
          mini: true,
          child: const Icon(Icons.refresh),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 50.0,
            child: Center(
              child: Text(
                "Total Screen Time: ${formatTime(totalScreenTime)}",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
