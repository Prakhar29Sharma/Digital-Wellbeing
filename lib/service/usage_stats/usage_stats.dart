import 'package:usage_stats/usage_stats.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

Future<int> DailyTotalUsage() async {
  UsageStats.grantUsagePermission();

  // Initialize time zones
  tzdata.initializeTimeZones();

  tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime startDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day);

  DateTime startDateUtc = startDate.toUtc();
  DateTime endDateUtc = now.toUtc();

  int totalScreenTime = 0;

  // Define a list of system app package names
  List<String> systemApps = [
    // system apps any if we want to exclude
    "com.android.launcher",
  ];

  Map<String, UsageInfo> maxUsageMap = {};

  List<UsageInfo> usageStats =
      await UsageStats.queryUsageStats(startDateUtc, endDateUtc);

  for (var usageInfo in usageStats) {
    String packageName = usageInfo.packageName!;
    // Exclude system apps from calculation
    if (!systemApps.contains(packageName)) {
      if (!maxUsageMap.containsKey(packageName) ||
          int.parse(usageInfo.totalTimeInForeground ?? '0') >
              int.parse(
                  maxUsageMap[packageName]?.totalTimeInForeground ?? '0')) {
        maxUsageMap[packageName] = usageInfo;
      }
    }
  }

  List<UsageInfo> result = maxUsageMap.values.toList();

  result.sort((a, b) => int.parse(b.totalTimeInForeground ?? '0')
      .compareTo(int.parse(a.totalTimeInForeground ?? '0')));

  for (var usageInfo in result) {
    totalScreenTime += int.parse(usageInfo.totalTimeInForeground ?? '0');
  }

  return totalScreenTime;
}

// package_name : usage_duration in percentage
Future<Map<String, double>> DailyAppUsage() async {
  UsageStats.grantUsagePermission();

  // Initialize time zones
  tzdata.initializeTimeZones();

  tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime startDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day);

  DateTime startDateUtc = startDate.toUtc();
  DateTime endDateUtc = now.toUtc();

  Map<String, double> appUsageStats = {};

  // Define a list of system app package names
  List<String> systemApps = [
    // system apps any if we want to exclude
    "com.android.launcher",
  ];

  Map<String, UsageInfo> maxUsageMap = {};

  List<UsageInfo> usageStats =
      await UsageStats.queryUsageStats(startDateUtc, endDateUtc);

  for (var usageInfo in usageStats) {
    String packageName = usageInfo.packageName!;
    // Exclude system apps from calculation
    if (!systemApps.contains(packageName)) {
      if (!maxUsageMap.containsKey(packageName) ||
          int.parse(usageInfo.totalTimeInForeground ?? '0') >
              int.parse(
                  maxUsageMap[packageName]?.totalTimeInForeground ?? '0')) {
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

  for (var usageInfo in result) {
    appUsageStats[usageInfo.packageName!] =
        ((int.parse(usageInfo.totalTimeInForeground ?? '0') / total) * 100);
  }

  return appUsageStats;
}

// package_name : usage_duration in percentage
Future<Map<String, int>> ActualDailyAppUsage() async {
  UsageStats.grantUsagePermission();

  // Initialize time zones
  tzdata.initializeTimeZones();

  tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime startDate =
      tz.TZDateTime(tz.local, now.year, now.month, now.day);

  DateTime startDateUtc = startDate.toUtc();
  DateTime endDateUtc = now.toUtc();

  Map<String, int> appUsageStats = {};

  // Define a list of system app package names
  List<String> systemApps = [
    // system apps any if we want to exclude
    "com.android.launcher",
  ];

  Map<String, UsageInfo> maxUsageMap = {};

  List<UsageInfo> usageStats =
      await UsageStats.queryUsageStats(startDateUtc, endDateUtc);

  for (var usageInfo in usageStats) {
    String packageName = usageInfo.packageName!;
    // Exclude system apps from calculation
    if (!systemApps.contains(packageName)) {
      if (!maxUsageMap.containsKey(packageName) ||
          int.parse(usageInfo.totalTimeInForeground ?? '0') >
              int.parse(
                  maxUsageMap[packageName]?.totalTimeInForeground ?? '0')) {
        maxUsageMap[packageName] = usageInfo;
      }
    }
  }

  List<UsageInfo> result = maxUsageMap.values.toList();

  result.sort((a, b) => int.parse(b.totalTimeInForeground ?? '0')
      .compareTo(int.parse(a.totalTimeInForeground ?? '0')));

  for (var usageInfo in result) {
    appUsageStats[usageInfo.packageName!] =
        int.parse(usageInfo.totalTimeInForeground ?? '0');
  }

  return appUsageStats;
}
