import 'package:flutter/material.dart';

enum ProfileMode { buyer, seller }

class ProfileModeController extends ChangeNotifier {
  ProfileMode _mode = ProfileMode.buyer;

  ProfileMode get mode => _mode;

  void setMode(ProfileMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
  }
}

class ProfileModeScope extends InheritedNotifier<ProfileModeController> {
  ProfileModeScope({super.key, required Widget child})
      : super(notifier: ProfileModeController(), child: child);

  static ProfileModeController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ProfileModeScope>();
    assert(scope != null, 'ProfileModeScope not found in widget tree');
    return scope!.notifier!;
  }
}
