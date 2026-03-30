import 'package:flutter/cupertino.dart';

class WindowState extends ChangeNotifier {
bool _isMinimized = false;
bool _isMaximized = false;

bool get isMinimized => _isMinimized;
bool get isMaximized => _isMaximized;

void setMinimized(bool minimized) {
  _isMinimized = minimized;
  notifyListeners();
}

void setMaximized(bool maximized) {
  _isMaximized = maximized;
  notifyListeners();
}
}
