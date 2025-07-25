import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userStatus = userProvider.userStatus;
    Color statusColor;
    String statusText;
    switch (userStatus) {
      case 2:
        statusColor = Colors.green;
        statusText = "Active";
        break;
      case 1:
        statusColor = Colors.yellow;
        statusText = "Away";
        break;
      default:
        statusColor = Colors.red;
        statusText = "Offline";
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 4, 31, 73),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 32, color: const Color.fromARGB(255, 4, 31, 73)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kaviya M',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              statusText,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Senior Appraiser', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile( // Add ListTile widgets for navigation
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          ListTile(
            leading: Icon(Icons.qr_code_2_outlined),
            title: Text('Attendance'),
            onTap: () => Navigator.pushReplacementNamed(context, '/attendance'),
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Expenses'),
            onTap: () => Navigator.pushReplacementNamed(context, '/expenses'),
          ),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text('Calender'),
            onTap: () => Navigator.pushReplacementNamed(context, '/calendar'),
          ),
           ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () => Navigator.pushReplacementNamed(context, '/profile'),
          ),
        ],
      ),
    );
  }
}
