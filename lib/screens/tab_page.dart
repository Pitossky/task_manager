import 'package:flutter/material.dart';
import 'package:task_manager/model/tab_items.dart';
import 'package:task_manager/screens/profile_page.dart';
import 'package:task_manager/services/entries/entries_det_page.dart';
import 'package:task_manager/widgets/cupertino_tab_widget.dart';

import 'home_page.dart';

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  TabItems _currentTab = TabItems.tasks;

  final Map<TabItems, GlobalKey<NavigatorState>> navKeys = {
    TabItems.tasks: GlobalKey<NavigatorState>(),
    TabItems.entries: GlobalKey<NavigatorState>(),
    TabItems.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItems, WidgetBuilder> get tabBuilders {
    return {
      TabItems.tasks: (_) => const HomePage(),
      TabItems.entries: (_) => EntryDetPage.create(_),
      TabItems.account: (_) => const ProfilePage(),
    };
  }

  void _selectTab(TabItems tabItems) {
    if (tabItems == _currentTab) {
      navKeys[tabItems]!.currentState!.popUntil(
            (route) => route.isFirst,
          );
    } else {
      setState(() {
        _currentTab = tabItems;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navKeys[_currentTab]!.currentState!.maybePop(),
      child: CupertinoTabWidget(
        currentTab: _currentTab,
        selectedTabs: _selectTab,
        tabBuilders: tabBuilders,
        navKeys: navKeys,
      ),
    );
  }
}
