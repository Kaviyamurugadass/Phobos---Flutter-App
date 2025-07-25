import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/attendance_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/expenses_screen.dart';

class UserProvider extends ChangeNotifier {
  int userStatus = 2; // 0 = offline, 1 = away, 2 = active
  String phone = "+91 98765 43210";
  String email = "kaviya@example.com";

  void setStatus(int status) {
    userStatus = status;
    notifyListeners();
  }

  void setPhone(String newPhone) {
    phone = newPhone;
    notifyListeners();
  }

  void setEmail(String newEmail) {
    email = newEmail;
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: PhobosAppraiserApp(),
    ),
  );
}

class PhobosAppraiserApp extends StatelessWidget {
  const PhobosAppraiserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phobos',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/profile': (context) => AppraiserProfileScreen(),
        '/attendance': (context) => AttendanceScreen(),
        '/calendar': (context) => CalendarScreen(),
        '/expenses': (context) => ExpensesScreen(),
      },
    );
  }
}
