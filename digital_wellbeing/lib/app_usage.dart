import 'package:flutter/material.dart';

class AppUsage extends StatelessWidget {
  AppUsage({Key? key}) : super(key: key);

  // Define the list of app names
  final List<String> appNames = [
    'Instagram',
    'Twitter',
    'Snapchat',
    'WhatsApp',
    'JioCinema',
    'Blynk',
    'DigitalWellbeing',
    'Nextwave'
  ];

  // Dummy values for total time used (in seconds)
  final List<int> totalTimeUsed = [
    3600, // 1 hour
    1800, // 30 minutes
    2700, // 45 minutes
    5400, // 1 hour 30 minutes
    1200, // 20 minutes
    900,  // 15 minutes
    7200, // 2 hours
    3000, // 50 minutes
  ];

  // Define the list of app images
  final List<String> appImages = [
    'assets/images/instagram.png',
    'assets/images/twitter.jpg',
    'assets/images/snapchat.png',
    'assets/images/whatsapp.png',
    'assets/images/Jiocinema.png',
    'assets/images/blynk.png',
    'assets/images/smartphone.png',
    'assets/images/nextwave.png',
  ];

  // Function to format time in hours, minutes, and seconds
  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedTime = '';

    if (hours > 0) {
      formattedTime += '$hours hours ';
    }
    if (minutes > 0) {
      formattedTime += '$minutes minutes ';
    }
    formattedTime += '$remainingSeconds seconds';

    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      height: 400,

      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Apps Usage Stats',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Adjust padding
                leading: SizedBox(
                  width: 30, // Adjust width of the leading image
                  height: 30, // Adjust height of the leading image
                  child: Image.asset(
                    appImages[index], // Use app images from the list
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(appNames[index], style: TextStyle(fontSize: 13),), // Use app names from the list
                subtitle: Text('Total Time Used: ${formatTime(totalTimeUsed[index])}', style: TextStyle(fontSize: 11),), // Display total time used
                trailing: Icon(Icons.navigate_next_rounded),
              ),
              itemCount: appNames.length, // Use the length of the app names list
            ),
          ),
          Divider(
            color: Colors.black,
            thickness: 0.8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              "Total Screen Time : ",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
    );
  }
}
