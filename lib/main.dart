import 'dart:developer';
import 'package:chatos_messenger/common/widgets/error.dart';
import 'package:chatos_messenger/common/widgets/loader.dart';
import 'package:chatos_messenger/features/auth/controller/auth_controller.dart';
import 'package:chatos_messenger/features/splash/screens/landing_screen.dart';
import 'package:chatos_messenger/firebase_options.dart';
import 'package:chatos_messenger/router.dart';
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

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chatos Messenger',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      onGenerateRoute: ((settings) => generateRoute(settings)),
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              log(user.toString());
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileLayoutScreen();
            },
            error: (err, trace) {
              return ErrorScreen(error: err.toString());
            },
            loading: () => const LoaderWidget(),
          ),
    );
  }
}
