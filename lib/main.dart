import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lensify/Screens/FavoritesScreen.dart';
import 'package:lensify/Screens/LoginScreen.dart';
import 'package:lensify/Screens/SignUpScreen.dart';
import 'package:lensify/Screens/SplashScreen.dart';
import 'package:lensify/Screens/MainNavScreen.dart';
import 'firebase_options.dart';

import 'package:lensify/Screens/EyeGlasses/EyglassesKids.dart';
import 'package:lensify/Screens/EyeGlasses/EyglassesMen.dart';
import 'package:lensify/Screens/EyeGlasses/EyglassesWomen.dart';
import 'package:lensify/Screens/SunGlasses/SunglassesKids.dart';
import 'package:lensify/Screens/SunGlasses/SunglassesMen.dart';
import 'package:lensify/Screens/SunGlasses/SunglassesWomen.dart';

import 'package:lensify/Screens/shared/cart_controller.dart';
import 'package:lensify/Screens/shared/product_controller.dart';
import 'package:lensify/Screens/shared/order_controller.dart';
import 'package:lensify/Screens/shared/profile_mode_controller.dart';

import 'app_keys.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProductScope(
      child: CartScope(
        child: OrderScope(
          child: ProfileModeScope(
            child: MaterialApp(
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            initialRoute: "/splash",
            routes: {
              "/splash": (context) => const SplashScreen(),

              "/login": (context) => const loginScreen(),
              "/signup": (context) => const signUpScreen(),
              "/home": (context) => const MainNavScreen(initialIndex: 0),

              "/orders": (context) => const MainNavScreen(initialIndex: 1),

              "/cart": (context) => const MainNavScreen(initialIndex: 2),
              "/favorites": (context) => const FavoritesScreen(),
              "/profile": (context) => const MainNavScreen(initialIndex: 3),

              "/eyeglasses/men": (context) => const EyeglassMen(),
              "/eyeglasses/women": (context) => const EyeglassWomen(),
              "/eyeglasses/kids": (context) => const EyeglassKids(),

              "/sunglasses/men": (context) => const SunglassMen(),
              "/sunglasses/women": (context) => const SunglassWomen(),
              "/sunglasses/kids": (context) => const SunglassKids(),
            },
            ),
          ),
        ),
      ),
    );
  }
}
