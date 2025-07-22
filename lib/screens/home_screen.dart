import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../widgets/nav_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Color statusColor(int userStatus) {
    switch (userStatus) {
      case 2:
        return Colors.green;
      case 1:
        return Colors.yellow;
      default:
        return Colors.red;
    }
  }

  String statusText(int userStatus) {
    switch (userStatus) {
      case 2:
        return "Active";
      case 1:
        return "Away";
      default:
        return "Offline";
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userStatus = userProvider.userStatus;
    final userStatusText = statusText(userStatus);
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Row(
            children: [
              Container(
                width: 14,
                height: 14,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: statusColor(userStatus),
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                userStatusText,
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
      body: Container(
      color: const Color.fromARGB(255, 4, 31, 73), // Set the background color to indigo
        child: Center(
          child: Text(
            'Welcome to Phobos UI!',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Colors.white, // Optional: Make text visible on indigo
          ),
        ),
      ),
      ),
    );
  }
}
