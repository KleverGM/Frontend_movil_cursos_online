import 'package:flutter/material.dart';

import '../../../courses/presentation/pages/courses_page.dart';
import '../../../courses/presentation/pages/instructor_dashboard_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

/// InheritedWidget para compartir la función de cambio de pestaña
class TabNavigator extends InheritedWidget {
  final Function(int) onTabChange;

  const TabNavigator({
    super.key,
    required this.onTabChange,
    required super.child,
  });

  static TabNavigator? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TabNavigator>();
  }

  @override
  bool updateShouldNotify(TabNavigator oldWidget) => false;
}

/// Layout principal para instructores
class InstructorMainLayout extends StatefulWidget {
  const InstructorMainLayout({super.key});

  @override
  State<InstructorMainLayout> createState() => InstructorMainLayoutState();
}

class InstructorMainLayoutState extends State<InstructorMainLayout> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const InstructorDashboardPage(),
      const CoursesPage(),
      const HomePage(), // Estadísticas del instructor
      const ProfilePage(),
    ];
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabNavigator(
        onTabChange: changeTab,
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: changeTab,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explorar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Actividad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
