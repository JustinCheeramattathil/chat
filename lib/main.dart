import 'dart:developer';
import 'package:chatos_messenger/common/widgets/error.dart';
import 'package:chatos_messenger/common/widgets/loader.dart';
import 'package:chatos_messenger/features/auth/controller/auth_controller.dart';
import 'package:chatos_messenger/features/splash/screens/error_screen.dart';
import 'package:chatos_messenger/features/splash/screens/landing_screen.dart';
import 'package:chatos_messenger/firebase_options.dart';
import 'package:chatos_messenger/router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatos_messenger/colors.dart';
import 'package:chatos_messenger/screens/mobile_layout_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// ...

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Future<void> checkAndNavigate(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // Navigate to the error screen
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ErrorPage()),
      );
    } else {
      // Navigate to the home screen or other appropriate screen
      ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const LandingScreen()),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const MobileLayoutScreen()),
                );
              }
            },
            error: (err, trace) {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => ErrorScreen(error: err.toString())),
              );
            },
            loading: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const LoaderWidget()),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatos Messenger',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      onGenerateRoute: ((settings) => generateRoute(settings)),
      home: Builder(
        builder: (context) {
          checkAndNavigate(context); 
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}


