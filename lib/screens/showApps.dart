import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../service/format_time.dart';

class ShowAllPageWrapper extends StatelessWidget {
  final List<MapEntry<String, int>> appEntries;

  const ShowAllPageWrapper({Key? key, required this.appEntries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('All Apps', style: TextStyle(color: Colors.white),),
      ),
      body: ShowAllAppsPage(appEntries: appEntries),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class ShowAllAppsPage extends StatelessWidget {
  final List<MapEntry<String, int>> appEntries;

  const ShowAllAppsPage({Key? key, required this.appEntries}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black.withOpacity(0.5), // Color of the border
          width: 1, // Width of the border
        ),

      ),
      child: ListView.separated(
        itemCount: appEntries.length,
        itemBuilder: (context, index) {
          final appEntry = appEntries[index];
          return ListTile(
            title: Text(appEntry.key, style: (TextStyle(fontSize: 13)),),
            subtitle: Text(formatTime(appEntry.value), style: (TextStyle(fontSize: 11)),),
            trailing: Icon(Icons.navigate_next_rounded),
          );
        },
        separatorBuilder: (context, index) => Divider(), // Add a divider between each list tile
      ),
    );
  }
}