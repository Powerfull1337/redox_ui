import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redox_ui/colors.dart';
import 'package:redox_ui/common/widgets/error.dart';
import 'package:redox_ui/common/widgets/loader.dart';
import 'package:redox_ui/features/auth/conrtoller/auth_controller.dart';

import 'package:redox_ui/features/landing/screens/landing_screen.dart';
import 'package:redox_ui/firebase_options.dart';
import 'package:redox_ui/router.dart';
import 'package:redox_ui/screens/mobile_layout_screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp( 
      debugShowCheckedModeBanner: false,
      title: 'redox UI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarColor,
        ) 
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: //const LandingScreen(), 
      ref.watch(userDataAuthProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              }
              return const MobileLayoutScreen();
            },
            error: (err, trace) {
              return ErrorScreen(
                error: err.toString(),
              );
            },
            loading: () => const Loader(),
          ),
      /*UserInformationScreen()*/
      /*const ResponsiveLayout(
        mobileScreenLayout: MobileLayoutScreen(),
        webScreenLayout: WebLayoutScreen(),
      ),*/
    );
  }
}
