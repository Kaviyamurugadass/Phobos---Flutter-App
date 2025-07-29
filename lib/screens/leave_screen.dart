import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({Key? key}) : super(key: key);

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _leaveType;
  DateTime? _fromDate;
  DateTime? _toDate;
  PlatformFile? _pickedFile;
  int _totalDays = 0;
  Map<DateTime, List<String>> _leaveDays = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final List<String> _leaveTypes = [
    'Casual Leave',
    'Sick Leave',
    'Earned Leave',
    'Maternity Leave',
    'Other',
  ];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFile = result.files.first;
      });
    }
  }

  void _calculateTotalDays() {
    if (_fromDate != null && _toDate != null) {
      setState(() {
        _totalDays = _toDate!.difference(_fromDate!).inDays + 1;
      });
    }
  }

  void _applyLeave() {
    if (_formKey.currentState!.validate() && _fromDate != null && _toDate != null) {
      List<DateTime> days = [];
      for (int i = 0; i < _totalDays; i++) {
        days.add(_fromDate!.add(Duration(days: i)));
      }
      setState(() {
        for (var day in days) {
          final key = DateTime(day.year, day.month, day.day);
          _leaveDays[key] = [_leaveType ?? 'Leave'];
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Leave applied and marked on calendar!'), backgroundColor: Colors.green),
      );
      _formKey.currentState!.reset();
      setState(() {
        _leaveType = null;
        _fromDate = null;
        _toDate = null;
        _pickedFile = null;
        _totalDays = 0;
      });
    }
  }

  List<String> _getEventsForDay(DateTime day) {
    return _leaveDays[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    var _reasonController;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Application'),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Leave Type',
                            border: OutlineInputBorder(),
                          ),
                          value: _leaveType,
                          items: _leaveTypes
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (val) {
                            setState(() {
                              _leaveType = val;
                            });
                          },
                          validator: (val) => val == null ? 'Select leave type' : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: _fromDate ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _fromDate = picked;
                                      if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
                                        _toDate = null;
                                      }
                                    });
                                    _calculateTotalDays();
                                  }
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'From Date',
                                    border: OutlineInputBorder(),
                                  ),
                                  child: Text(_fromDate == null
                                      ? 'Select'
                                      : '${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}'),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: _toDate ?? (_fromDate ?? DateTime.now()),
                                    firstDate: _fromDate ?? DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _toDate = picked;
                                    });
                                    _calculateTotalDays();
                                  }
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                    labelText: 'To Date',
                                    border: OutlineInputBorder(),
                                  ),
                                  child: Text(_toDate == null
                                      ? 'Select'
                                      : '${_toDate!.day}/${_toDate!.month}/${_toDate!.year}'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16), 
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _reasonController,
                                decoration: const InputDecoration(
                                  labelText: 'Reason',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _pickFile,
                                icon: const Icon(Icons.attach_file),
                                label: Text(_pickedFile == null ? 'Upload File' : 'File Selected'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 229, 232, 233),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            if (_pickedFile != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(Icons.check_circle, color: Colors.green),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text('Total Days:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            Text(_totalDays > 0 ? '$_totalDays' : '-'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _applyLeave,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Apply Leave', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    firstDay: DateTime(2000),
                    lastDay: DateTime(2100),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                    eventLoader: _getEventsForDay,
                    calendarStyle: const CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
