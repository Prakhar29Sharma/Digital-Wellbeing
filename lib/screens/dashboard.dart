import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/pie_chart/pie_chart.dart';
import '../service/usage_stats/usage_stats.dart';
import '../service/format_time.dart';

class Dashboard extends StatelessWidget {
  const Dashboard ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text("Today's App Usage", style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),),
                    const SizedBox(height: 40,),
                    const PieChartSample(),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          const Center(
                            child: Text("Total Screen Time", style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),),
                          ),
                          FutureBuilder(future: DailyTotalUsage(), builder:
                            (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text('Something went wrong!');
                              } else {
                                return Text(formatTime(snapshot.data!), style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ));
                              }
                            }
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Center(
                            child: Text("Most Used App", style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),),
                          ),
                          // list view of all apps with their usage time
                          FutureBuilder(future: ActualDailyAppUsage(), builder:
                            (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text('Something went wrong!');
                              } else {
                                return Column(
                                  children: snapshot.data!.entries.map((entry) {
                                    return ListTile(
                                      title: Text(entry.key),
                                      subtitle: Text(formatTime(entry.value.toInt())),
                                    );
                                  }).toList(),
                                );
                              }
                            }
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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