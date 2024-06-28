import 'package:badges/badges.dart' as badges;
import 'package:flexivity/app/models/navigation_models/navigation_destination_item.dart';
import 'package:flexivity/data/globals.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavbarWidget extends StatefulWidget {
  final int index;
  const NavbarWidget({super.key, required this.index});

  @override
  State<NavbarWidget> createState() => _NavbarWidgetState();
}

class _NavbarWidgetState extends State<NavbarWidget> {
  List<NavigationDestinationItem> destinations = [
    NavigationDestinationItem(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: "Home",
      route: "/home",
    ),
    NavigationDestinationItem(
      icon: Globals.friendNotificationsCount == 0
          ? Icon(Icons.group_outlined)
          : badges.Badge(
              badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
              position: badges.BadgePosition.topEnd(top: -12, end: -9),
              badgeContent: Text(Globals.friendNotificationsCount.toString()),
              child: Icon(Icons.group_outlined),
            ),
      selectedIcon: Icon(Icons.group),
      label: "Friends",
      route: "/friends",
    ),
    NavigationDestinationItem(
      icon: Globals.groupNotificationsCount == 0
          ? Icon(Icons.format_line_spacing_outlined)
          : badges.Badge(
              badgeStyle: badges.BadgeStyle(badgeColor: Colors.red),
              position: badges.BadgePosition.topEnd(top: -12, end: -9),
              badgeContent: Text(Globals.groupNotificationsCount.toString()),
              child: Icon(Icons.format_line_spacing_outlined),
            ),
      selectedIcon: Icon(Icons.format_line_spacing),
      label: "Groups",
      route: "/groups",
    ),
    NavigationDestinationItem(
      icon: Icon(Icons.query_stats_outlined),
      selectedIcon: Icon(Icons.query_stats),
      label: "Prediction",
      route: "/prediction",
    )
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: destinations,
      onDestinationSelected: (value) {
        GoRouter.of(context).push(destinations[value].route);
      },
      selectedIndex: widget.index,
    );
  }
}

CustomTransitionPage defaultTransition(
    BuildContext context, GoRouterState state, Widget page) {
  return CustomTransitionPage(
      key: state.pageKey,
      child: page,
      fullscreenDialog: true,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInToLinear).animate(animation),
          child: child,
        );
      });
}
