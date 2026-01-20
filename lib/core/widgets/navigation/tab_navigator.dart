import 'package:flutter/material.dart';

/// InheritedWidget reutilizable para compartir la función de cambio de pestaña
/// entre diferentes layouts con bottom navigation
class TabNavigator extends InheritedWidget {
  final Function(int) onTabChange;

  const TabNavigator({
    super.key,
    required this.onTabChange,
    required super.child,
  });

  /// Obtiene la instancia más cercana de TabNavigator en el árbol de widgets
  static TabNavigator? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TabNavigator>();
  }

  @override
  bool updateShouldNotify(TabNavigator oldWidget) => false;
}
