import 'package:flutter/material.dart';
import '../widgets/nav_drawer.dart';  

class ExpensesScreen extends StatelessWidget {
  ExpensesScreen({super.key});

  final List<Map<String, dynamic>> expenses = [
    {'date': '2023-10-01', 'amount': 150.00, 'description': 'Office Supplies'},
    {'date': '2023-10-05', 'amount': 200.00, 'description': 'Travel Expenses'},
    {'date': '2023-10-10', 'amount': 50.00, 'description': 'Lunch with Client'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text('Expenses'),
        backgroundColor: const Color.fromARGB(255, 4, 31, 73),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];
          return Card(
            child: ListTile(
              title: Text('${expense['date']} - \$${expense['amount']}'),
              subtitle: Text(expense['description']),
            ),
          );
        },
      ),
    );
  }
}