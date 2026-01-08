import 'package:flutter/material.dart';

/// App-wide ScaffoldMessenger key so snackbars can be shown even when
/// we replace the navigation stack.
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
