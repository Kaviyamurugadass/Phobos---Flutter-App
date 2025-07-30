import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class PhobosAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String statusText;
  final Color statusColor;
  final VoidCallback? onNotificationTap;

  const PhobosAppBar({
    super.key,
    required this.title,
    required this.statusText,
    required this.statusColor,
    this.onNotificationTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      title: Text(title),
      actions: [
        Row(
          children: [
            Container(
              width: 14,
              height: 14,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
            ),
            Text(
              statusText,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: onNotificationTap ?? () {},
              tooltip: 'Notifications',
            ),
          ],
        ),
      ],
    );
  }
} 