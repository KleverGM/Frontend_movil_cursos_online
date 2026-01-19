import 'package:flutter/material.dart';
import '../../../courses/presentation/pages/admin_courses_page.dart';
import '../../../courses/presentation/pages/global_stats_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

/// InheritedWidget para compartir la función de cambio de pestaña
class AdminTabNavigator extends InheritedWidget {
  final Function(int) onTabChange;

  const AdminTabNavigator({
    super.key,
    required this.onTabChange,
    required super.child,
  });

  static AdminTabNavigator? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AdminTabNavigator>();
  }

  @override
  bool updateShouldNotify(AdminTabNavigator oldWidget) => false;
}

/// Layout principal con bottom navigation para administradores
class AdminMainLayout extends StatefulWidget {
  const AdminMainLayout({super.key});

  @override
  State<AdminMainLayout> createState() => AdminMainLayoutState();
}

class AdminMainLayoutState extends State<AdminMainLayout> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const AdminCoursesPage(),
      const GlobalStatsPage(),
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
      body: AdminTabNavigator(
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
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_outlined),
            activeIcon: Icon(Icons.admin_panel_settings),
            label: 'Cursos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: 'Estadísticas',
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
