import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum MainTab { trip, map, budget, group }

/// Shared bottom nav for the main app (Trip/Map/Budget/Group tabs).
/// Only appears on primary tab screens — not on modal/detail/alert
/// screens, matching the navigation model decided in README.md.
class AppBottomNavBar extends StatelessWidget {
  final MainTab current;
  final ValueChanged<MainTab> onSelect;

  const AppBottomNavBar({super.key, required this.current, required this.onSelect});

  static const _items = [
    (tab: MainTab.trip, icon: Icons.event_note, label: 'Trip'),
    (tab: MainTab.map, icon: Icons.map_outlined, label: 'Map'),
    (tab: MainTab.budget, icon: Icons.account_balance_wallet_outlined, label: 'Budget'),
    (tab: MainTab.group, icon: Icons.groups_outlined, label: 'Group'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.only(bottom: 10, top: 8),
      decoration: const BoxDecoration(
        color: AppColors.cream,
        border: Border(top: BorderSide(color: AppColors.ink, width: 1.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _items.map((item) {
          final active = item.tab == current;
          final color = active ? AppColors.rust : AppColors.inkSoft;
          return InkWell(
            onTap: () => onSelect(item.tab),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, size: 20, color: color),
                const SizedBox(height: 4),
                Text(item.label.toUpperCase(), style: AppTextStyles.label.copyWith(fontSize: 9, color: color)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
