import 'package:flutter/material.dart';

enum TabItems { tasks, entries, account }

class TabItemData {
  final String tabTitle;
  final IconData tabIcon;

  const TabItemData({
    required this.tabTitle,
    required this.tabIcon,
  });

  static const Map<TabItems, TabItemData> allTabItems = {
    TabItems.tasks: TabItemData(
      tabTitle: 'Tasks',
      tabIcon: Icons.work,
    ),
    TabItems.entries: TabItemData(
      tabTitle: 'Entries',
      tabIcon: Icons.view_headline,
    ),
    TabItems.account: TabItemData(
      tabTitle: 'Profile',
      tabIcon: Icons.person,
    ),
  };
}
