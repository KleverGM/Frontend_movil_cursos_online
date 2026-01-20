import 'package:flutter/material.dart';

import '../../../../core/widgets/navigation/tab_navigator.dart';
import '../../../courses/presentation/pages/instructor_dashboard_page.dart';
import '../../../courses/presentation/pages/instructor_reviews_page.dart';
import 'profile_page.dart';

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
      const InstructorReviewsPage(),
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
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Mis Cursos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_outline),
            activeIcon: Icon(Icons.star),
            label: 'Reseñas',
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
