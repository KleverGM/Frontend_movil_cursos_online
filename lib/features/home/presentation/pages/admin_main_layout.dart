import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/navigation/tab_navigator.dart';
import '../../../admin/presentation/pages/admin_dashboard_page.dart';
import '../../../courses/presentation/pages/admin_courses_page.dart';
import '../../../courses/presentation/pages/global_stats_page.dart';
import '../../../courses/presentation/bloc/global_stats_bloc.dart';
import 'profile_page.dart';

/// Layout principal con bottom navigation para administradores
class AdminMainLayout extends StatefulWidget {
  const AdminMainLayout({super.key});

  @override
  State<AdminMainLayout> createState() => AdminMainLayoutState();
}

class AdminMainLayoutState extends State<AdminMainLayout> {
  int _currentIndex = 0;
  int _coursesPageVersion = 0; // Para forzar la reconstrucción

  List<Widget> _buildPages() {
    return [
      const AdminDashboardPage(),
      AdminCoursesPage(key: ValueKey('courses_$_coursesPageVersion')),
      GlobalStatsPage(bloc: getIt<GlobalStatsBloc>()),
      const ProfilePage(),
    ];
  }

  void changeTab(int index) {
    setState(() {
      // Si cambiamos a la pestaña de cursos (index 1), incrementar la versión para recrearla
      if (index == 1 && index != _currentIndex) {
        _coursesPageVersion++;
      }
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();
    
    return Scaffold(
      body: TabNavigator(
        onTabChange: changeTab,
        child: IndexedStack(
          index: _currentIndex,
          children: pages,
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
