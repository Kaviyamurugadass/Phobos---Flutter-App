import 'package:flutter/material.dart';
import '../widgets/nav_drawer.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedStartDay;
  DateTime? _selectedEndDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(title: Text('Calendar & Leave Application')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                if (_selectedStartDay != null && _selectedEndDay != null) {
                  return day.isAtSameMomentAs(_selectedStartDay!) ||
                      day.isAtSameMomentAs(_selectedEndDay!) ||
                      (day.isAfter(_selectedStartDay!) && day.isBefore(_selectedEndDay!));
                } else if (_selectedStartDay != null) {
                  return day.isAtSameMomentAs(_selectedStartDay!);
                }
                return false;
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                  if (_selectedStartDay == null || (_selectedStartDay != null && _selectedEndDay != null)) {
                    _selectedStartDay = selectedDay;
                    _selectedEndDay = null;
                  } else if (_selectedStartDay != null && _selectedEndDay == null) {
                    if (selectedDay.isBefore(_selectedStartDay!)) {
                      _selectedStartDay = selectedDay;
                    } else {
                      _selectedEndDay = selectedDay;
                    }
                  }
                });
              },
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                rangeHighlightColor: Colors.indigo.shade100,
                selectedDecoration: BoxDecoration(
                  color: Colors.indigo,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.indigo.shade200,
                  shape: BoxShape.circle,
                ),
              ),
              rangeSelectionMode: RangeSelectionMode.toggledOn,
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeaveApplicationScreen(),
                    ),
                  );
                },
                child: Text('Apply for Leave'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaveApplicationScreen extends StatefulWidget {
  const LeaveApplicationScreen({super.key});

  @override
  State<LeaveApplicationScreen> createState() => _LeaveApplicationScreenState();
}

class _LeaveApplicationScreenState extends State<LeaveApplicationScreen> {
  DateTime? _selectedStartDay;
  DateTime? _selectedEndDay;
  final TextEditingController _reasonController = TextEditingController();
  String _leaveType = 'Casual';
  final List<String> _leaveTypes = [
    'Casual',
    'Sick',
    'Annual',
    'Emergency Leave',
  ];

  int get _totalDays {
    if (_selectedStartDay != null && _selectedEndDay != null) {
      return _selectedEndDay!.difference(_selectedStartDay!).inDays + 1;
    }
    return 0;
  }

  void _submitLeave() {
    if (_reasonController.text.isEmpty || _selectedStartDay == null || _selectedEndDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Leave Applied'),
        content: Text('Your leave application has been submitted.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
    _reasonController.clear();
    setState(() {
      _selectedStartDay = null;
      _selectedEndDay = null;
      _leaveType = 'Casual';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Apply for Leave')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: 'Leave Reason',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedStartDay ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedStartDay = picked;
                          if (_selectedEndDay != null && _selectedEndDay!.isBefore(picked)) {
                            _selectedEndDay = null;
                          }
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(_selectedStartDay == null
                          ? 'Select'
                          : '${_selectedStartDay!.toLocal()}'.split(' ')[0]),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedEndDay ?? (_selectedStartDay ?? DateTime.now()),
                        firstDate: _selectedStartDay ?? DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedEndDay = picked;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        border: OutlineInputBorder(),
                      ),
                      child: Text(_selectedEndDay == null
                          ? 'Select'
                          : '${_selectedEndDay!.toLocal()}'.split(' ')[0]),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Total Days',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(_totalDays > 0 ? '$_totalDays' : '-'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _leaveType,
                    items: _leaveTypes
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        _leaveType = val!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Leave Type',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitLeave,
                    child: Text('Apply'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
