import 'package:flutter/material.dart';
import '../widgets/nav_drawer.dart';

class AttendanceScreen extends StatelessWidget {
  final List<String> attendance = [
    'Svelte & SvelteKit',
    'Java',
    'React.js',
    'Tailwind CSS',
    'JavaScript',
    'Flutter (Beginner)',
    'Dart (Beginner)',
    'Git & GitHub',
    'Zod Validation',
    'Google OAuth (Lucia)',
    'Data curation',
    'FastAPI',
    'MongoDB',
    'Docker',
    'UI/UX Implementation',
    'API Integration',
  ];

  AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: Text('Attendance')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: attendance.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            leading: Icon(Icons.check_circle_outline),
            title: Text(attendance[index]),
          ),
        ),
      ),
    );
  }
}
