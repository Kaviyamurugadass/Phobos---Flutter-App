import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../widgets/nav_drawer.dart';
import '../main.dart';

class AppraiserProfileScreen extends StatefulWidget {
  const AppraiserProfileScreen({super.key});

  @override
  State<AppraiserProfileScreen> createState() => _AppraiserProfileScreenState();
}

class _AppraiserProfileScreenState extends State<AppraiserProfileScreen> {
  final primaryColor = const Color.fromARGB(255, 4, 31, 73);
  final goldColor = const Color(0xFFFFD700); // Gold

  String? uploadedFileName;

  Color statusColor(int userStatus) {
    switch (userStatus) {
      case 2:
        return Colors.green; // Active
      case 1:
        return Colors.yellow; // Away
      default:
        return Colors.red; // Offline
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

  Widget sectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      );

  Widget infoRow(String label, String value, {bool editable = false, VoidCallback? onEdit}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            "$label:",
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
          ),
        )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              Flexible(child: Text(value)),
              if (editable && onEdit != null)
                IconButton(
                  icon: Icon(Icons.edit, size: 16, color: Colors.black),
                  onPressed: onEdit,
                  tooltip: 'Edit $label',
                )
            ],
          ),
        )),
      ],
    );
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        uploadedFileName = result.files.first.name;
      });
      // You can handle the file upload logic here
      // For example, upload to server or save locally
    }
  }

  void showEditDialog(BuildContext context, String label, String initialValue, Function(String) onSave) {
    final controller = TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $label'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onSave(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userStatus = userProvider.userStatus;
    final phone = userProvider.phone;
    final email = userProvider.email;

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text('Your Profile'),
        backgroundColor: const Color.fromARGB(255, 4, 31, 73),
        foregroundColor: Colors.white,
        actions: [
          Row(
            children: [
              Text(
                statusText(userStatus),
                style: const TextStyle(color: Colors.white),
              ),
              Switch(
                value: userStatus == 2,
                activeColor: Colors.green,
                inactiveThumbColor: Colors.red,
                onChanged: (val) {
                  userProvider.setStatus(val ? 2 : 0);
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PROFILE PICTURE + STATUS
            Center(
              child: Stack(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: goldColor,
                        child: Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Kaviya M',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: primaryColor),
                      ),
                      Text('Senior Appraiser'),
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Center(
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: statusColor(userStatus),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            /// PERSONAL INFO
            sectionTitle("Personal Information"),
            infoRow("Appraiser ID", "APP-10234"),
            infoRow("Designation", "Senior Appraiser"),
            infoRow("Zone", "Chennai - South"),
            infoRow("Phone", phone, editable: true, onEdit: () {
              showEditDialog(context, "Phone", phone, (val) => userProvider.setPhone(val));
            }),
            infoRow("Email", email, editable: true, onEdit: () {
              showEditDialog(context, "Email", email, (val) => userProvider.setEmail(val));
            }),

            /// ACCOUNT
            sectionTitle("Account & Access"),
            infoRow("Login Method", "Zoho SSO"),
            infoRow("Role", "Full-Time"),
            infoRow("Last Login", "2025-07-21 10:32 AM"),
            infoRow("Account Status", statusText(userStatus)),

            /// WORK SUMMARY
            sectionTitle("Work Summary"),
            infoRow("Total Appraisals", "1285"),
            infoRow("This Month", "32"),
            infoRow("Pending Submissions", "4"),
            infoRow("QR Packets Scanned", "24"),
            infoRow("Incomplete Appraisals", "2"),

            /// DOCUMENT SECTION
            sectionTitle("🗂️ Documents & Verification"),
            infoRow("Aadhaar Status", "Uploaded - Verified"),
            infoRow("PAN Status", "Uploaded - Pending"),
            infoRow("Certification", "Missing"),
            if (uploadedFileName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Uploaded: '
                  '$uploadedFileName',
                  style: TextStyle(color: Colors.green[700]),
                ),
              ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: pickFile,
              icon: Icon(Icons.upload_file, color: primaryColor),
              label: const Text("Upload Documents"),
              style: ElevatedButton.styleFrom(
                backgroundColor: goldColor,
                foregroundColor: primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
