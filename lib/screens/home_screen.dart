import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../widgets/nav_drawer.dart';
import '../widgets/phobos_app_bar.dart';
import '../constants/app_colors.dart';
import 'full_map_screen.dart';

class BankRequest {
  final String bankName;
  final String branch;
  final String description;
  final String address;
  final String openHours;
  final bool isNearby;
  final String mapImageUrl;
  final double latitude;
  final double longitude;
  bool accepted;

  BankRequest({
    required this.bankName,
    required this.branch,
    required this.description,
    required this.address,
    required this.openHours,
    required this.isNearby,
    required this.mapImageUrl,
    required this.latitude,
    required this.longitude,
    this.accepted = false,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<BankRequest> requests;

  @override
  void initState() {
    super.initState();
    requests = [
      BankRequest(
        bankName: 'IOB Bank',
        branch: 'Vadapalani branch',
        description: 'Appraiser needed for 2 days',
        address: 'Indian Overseas Bank, 2A, J P Verticals, Kannan, Bala Nagar, Vadapalani, Chennai, Tamil Nadu 600026',
        openHours: 'Open - Closes 5pm',
        isNearby: true,
        mapImageUrl: 'https://maps.googleapis.com/maps/api/staticmap?center=Vadapalani,Chennai&zoom=15&size=400x200&markers=color:red%7Clabel:B%7CVadapalani',
        latitude: 13.0500,
        longitude: 80.2128,
      ),
      BankRequest(
        bankName: 'SBI Bank',
        branch: 'Coimbatore Main branch',
        description: 'Appraiser needed for a week',
        address: 'State Bank of India, Post Box No. 3860, State Bank Road, Coimbatore, Tamil Nadu 641018',
        openHours: 'Open - Closes 4pm',
        isNearby: false,
        mapImageUrl: 'https://maps.googleapis.com/maps/api/staticmap?center=Coimbatore&zoom=15&size=400x200&markers=color:blue%7Clabel:B%7CCoimbatore',
        latitude: 11.0168,
        longitude: 76.9558,
      ),
      BankRequest(
        bankName: 'HDFC Bank',
        branch: 'Kilpauk branch',
        description: 'Appraiser needed for 3 days',
        address: 'HDFC Bank, No. 808, Poonamalee High Road, Kilpauk, Chennai, Tamil Nadu 600010',
        openHours: 'Open - Closes 6pm',
        isNearby: false,
        mapImageUrl: 'https://maps.googleapis.com/maps/api/staticmap?center=Kilpauk,Chennai&zoom=15&size=400x200&markers=color:green%7Clabel:B%7CKilpauk',
        latitude: 13.0809,
        longitude: 80.2337,
      ),
      BankRequest(
        bankName: 'ICICI Bank',
        branch: 'Trichy Road branch',
        description: 'Appraiser needed for 1 day',
        address: 'ICICI Bank, J Building, No. 1600, Trichy Road, Coimbatore, Tamil Nadu 641018',
        openHours: 'Open - Closes 5pm',
        isNearby: false,
        mapImageUrl: 'https://maps.googleapis.com/maps/api/staticmap?center=Trichy Road,Coimbatore&zoom=15&size=400x200&markers=color:purple%7Clabel:B%7CTrichy+Road',
        latitude: 11.0062,
        longitude: 76.9786,
      ),
    ];
    
  }

  void _showRequestDetails(BankRequest request) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isEngaged = userProvider.userStatus == 3;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${request.bankName} - ${request.branch}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullMapScreen(
                            bankName: request.bankName,
                            branch: request.branch,
                            address: request.address,
                            latitude: request.latitude,
                            longitude: request.longitude,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.gold, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          children: [
                            Image.network(
                              request.mapImageUrl,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                height: 180,
                                color: AppColors.borderLight,
                                child: const Center(child: Icon(Icons.map, size: 60, color: Colors.grey)),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Tap to view full map',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Branch & request details:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${request.address}\n${request.openHours}',
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!isEngaged)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            for (var r in requests) {
                              r.accepted = false;
                            }
                            request.accepted = true;
                            userProvider.setStatus(3); // 3 = Engaged
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('ACCEPT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  if (isEngaged && request.accepted)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            request.accepted = false;
                            userProvider.setStatus(2); // 2 = Active
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('REJECT', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color statusColor(int userStatus) {
    switch (userStatus) {
      case 3:
        return AppColors.engaged; // Engaged
      case 2:
        return AppColors.active;
      case 1:
        return AppColors.away;
      default:
        return AppColors.offline;
    }
  }

  String statusText(int userStatus) {
    switch (userStatus) {
      case 3:
        return "Engaged";
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
    final isEngaged = userStatus == 3;
    final BankRequest? acceptedRequest = requests.where((r) => r.accepted).isNotEmpty ? requests.firstWhere((r) => r.accepted) : null;
    // Sort requests: nearby first
    final sortedRequests = [...requests]..sort((a, b) => b.isNearby ? 1 : -1);
    final requestsToShow = isEngaged && acceptedRequest != null ? [acceptedRequest] : sortedRequests;
    return Scaffold(
      drawer: NavDrawer(),
      appBar: PhobosAppBar(
        title: 'Home',
        statusText: userStatusText,
        statusColor: statusColor(userStatus),
        onNotificationTap: () {
          // TODO: Show notifications
        },
      ),
      body: Container(
        color: AppColors.background,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          itemCount: requestsToShow.length,
          separatorBuilder: (context, i) => const SizedBox(height: 16),
          itemBuilder: (context, i) {
            final req = requestsToShow[i];
            return GestureDetector(
              onTap: () => _showRequestDetails(req),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${req.bankName} - ${req.branch}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              req.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          if (req.isNearby)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Icon(Icons.location_on, color: AppColors.accent, size: 20),
                            ),
                          Icon(
                            req.accepted ? Icons.check_circle : Icons.circle,
                            color: req.accepted ? AppColors.success : AppColors.away,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
