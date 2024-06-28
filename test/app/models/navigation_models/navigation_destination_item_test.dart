import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flexivity/app/models/navigation_models/navigation_destination_item.dart';

void main() {
  test('NavigationDestinationItem properties test', () {
    // Create an instance of NavigationDestinationItem
    var item = const NavigationDestinationItem(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: "Home",
      route: "/",
    );

    // Verify that the properties are correctly set
    expect((item.icon as Icon).icon, Icons.home_outlined);
    expect((item.selectedIcon as Icon).icon, Icons.home);
    expect(item.label, "Home");
    expect(item.route, "/");
  });
}