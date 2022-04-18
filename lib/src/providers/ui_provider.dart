import 'package:flutter/material.dart';

class UIProvider extends ChangeNotifier {
  bool _showRightControls = false;
  bool _showLeftControls = false;

  bool get showRightControls => _showRightControls;
  bool get showLeftControls => _showLeftControls;

  set showRightControls(bool value) {
    _showRightControls = value;

    notifyListeners();
  }

  set showLeftControls(bool value) {
    _showLeftControls = value;

    notifyListeners();
  }
}
