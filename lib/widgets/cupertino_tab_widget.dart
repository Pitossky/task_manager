import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/model/tab_items.dart';
import 'package:task_manager/screens/home_page.dart';

class CupertinoTabWidget extends StatelessWidget {
  const CupertinoTabWidget({
    Key? key,
    required this.currentTab,
    required this.selectedTabs,
    required this.tabBuilders,
    required this.navKeys,
  }) : super(key: key);

  final TabItems currentTab;
  final ValueChanged<TabItems> selectedTabs;
  final Map<TabItems, WidgetBuilder> tabBuilders;
  final Map<TabItems, GlobalKey<NavigatorState>> navKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildTabItems(TabItems.tasks),
          _buildTabItems(TabItems.entries),
          _buildTabItems(TabItems.account),
        ],
        onTap: (index) => selectedTabs(
          TabItems.values[index],
        ),
      ),
      tabBuilder: (ctx, i){
        final tabContents = TabItems.values[i];
        return CupertinoTabView(
          navigatorKey: navKeys[tabContents],
          builder: (c) => tabBuilders[tabContents]!(c)
        );
      },
    );
  }

  BottomNavigationBarItem _buildTabItems(TabItems tabItems) {
    final itemData = TabItemData.allTabItems[tabItems];
    final tabColor = currentTab == tabItems ? Colors.blueGrey : Colors.grey;

    return BottomNavigationBarItem(
      icon: Icon(
        itemData!.tabIcon,
        color: tabColor,
      ),
      label: itemData.tabTitle,
    );
  }
}
