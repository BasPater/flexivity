import 'package:flutter/material.dart';

class NavigationDestinationItem extends NavigationDestination {
  final String route;

  const NavigationDestinationItem({
    super.key,
    required super.icon,
    super.selectedIcon,
    required super.label,
    super.tooltip,
    super.enabled = true,
    required this.route
  });
}
