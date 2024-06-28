import 'package:flexivity/app/models/ui_state.dart';
import 'package:flutter/material.dart';

/// UIStateSwitcher is a widget that switches its child widget based on the UIState
// ignore: must_be_immutable
class UIStateSwitcher extends StatefulWidget {
  UIState uiState;
  Widget normalState;
  Widget loadingState;
  Widget? errorState;
  Widget? emptySate;

  UIStateSwitcher(
      {super.key,
      required this.uiState,
      required this.normalState,
      required this.loadingState,
      this.emptySate,
      this.errorState});

  @override
  State<UIStateSwitcher> createState() => _UIStateSwitcherState();
}

class _UIStateSwitcherState extends State<UIStateSwitcher> {
  Widget _buildBody() {
    switch (widget.uiState) {
      case UIState.empty:
        return widget.emptySate ?? const Center(child: Text('No data available'));
      case UIState.loading:
        return widget.loadingState;
      case UIState.normal:
        return widget.normalState;
      case UIState.error:
        return widget.errorState ?? const Center(child: Text('An error occurred'));
      default:
        return const Center(child: Text('Unknown state'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
