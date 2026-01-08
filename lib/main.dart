import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lenscart/Screens/FavoritesScreen.dart';
import 'package:lenscart/Screens/LoginScreen.dart';
import 'package:lenscart/Screens/SignUpScreen.dart';
import 'package:lenscart/Screens/SplashScreen.dart';
import 'package:lenscart/Screens/MainNavScreen.dart';
import 'firebase_options.dart';

import 'package:lenscart/Screens/EyeGlasses/EyglassesKids.dart';
import 'package:lenscart/Screens/EyeGlasses/EyglassesMen.dart';
import 'package:lenscart/Screens/EyeGlasses/EyglassesWomen.dart';
import 'package:lenscart/Screens/SunGlasses/SunglassesKids.dart';
import 'package:lenscart/Screens/SunGlasses/SunglassesMen.dart';
import 'package:lenscart/Screens/SunGlasses/SunglassesWomen.dart';

import 'package:lenscart/Screens/shared/cart_controller.dart';
import 'package:lenscart/Screens/shared/product_controller.dart';
import 'package:lenscart/Screens/shared/order_controller.dart';
import 'package:lenscart/Screens/shared/profile_mode_controller.dart';

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
