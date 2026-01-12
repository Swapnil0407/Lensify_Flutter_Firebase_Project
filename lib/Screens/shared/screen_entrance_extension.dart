import 'package:flutter/material.dart';

import 'screen_entrance.dart';

extension ScreenEntranceExtension on Widget {
  Widget withScreenEntrance({
    Duration duration = const Duration(milliseconds: 2200),
    Key? key,
  }) {
    return ScreenEntrance(key: key, duration: duration, child: this);
  }
}
