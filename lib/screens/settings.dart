import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  final User? user; // Current user obtained after authentication

  const SettingsPage({Key? key, this.user}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _showAccountInfo = false;

  // Get the current user
  User? get user => FirebaseAuth.instance.currentUser;

  // Developer information
  final List<Map<String, String>> developers = [
    {
      'name': 'Prakhar Sharma',
      'github': 'https://github.com/Prakhar29Sharma',
    },
    {
      'name': 'Aryaan Sawant',
      'github': 'https://github.com/ARYAAN2903',
    },
    {
      'name': 'Divij Sarkale',
      'github': 'https://github.com/divijms07',
    },
    {
      'name': 'Sraina Panchangam',
      'github': 'https://github.com/PSraina',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () {
              // Show logout confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Logout user
                          FirebaseAuth.instance.signOut();
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Account Settings
              ListTile(
                title: const Text('Account Information'),
                leading: const Icon(Icons.account_circle),
                onTap: () {
                  setState(() {
                    _showAccountInfo = !_showAccountInfo;
                  });
                },
              ),
              // Display Account Information if _showAccountInfo is true
              if (_showAccountInfo)
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // get the user's email
                      Text('Email: ${user!.email}', style: TextStyle(color: Theme.of(context).colorScheme.primary.withOpacity(1.0),)),
                    ],
                  ),
                ),
              // Help and Support
              ListTile(
                title: const Text('Help and Support'),
                leading: const Icon(Icons.help),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Help and Support'),
                        content: const SingleChildScrollView(
                          child: ListBody(
                            children: [
                              Text('For assistance, please contact us at 321prakhar0039@dbit.in'),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              // Reset Password
              ListTile(
                title: const Text('Reset Password'),
                leading: const Icon(Icons.lock),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // Reset password
                      FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);

                      return AlertDialog(
                        title: const Text('Reset Password'),
                        content: const Text('Please check your email for password reset instructions.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              // Developer Credentials
              Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text('Developer Credits', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color:Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(1.0), )),
                            ),
                            const SizedBox(height: 5),
                            const Divider(),
                            for (var developer in developers)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(developer['name']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color:Theme.of(context).colorScheme.primary.withOpacity(1.0),)),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Launch the GitHub URL
                                      launchUrl(developer['github']! as Uri);
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/apps/github.png", width: 15,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          developer['github']!,
                                          style: const TextStyle(fontSize: 12, color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
