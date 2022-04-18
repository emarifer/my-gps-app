import 'package:flutter/material.dart';

class UIProvider extends ChangeNotifier {
  bool _showRightControls = false;

  bool get showRightControls => _showRightControls;

  set showRightControls(bool value) {
    _showRightControls = value;

    notifyListeners();
  }
}