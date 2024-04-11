import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:redox_ui/colors.dart';
import 'package:redox_ui/features/auth/screens/login_screen.dart';
import 'package:redox_ui/features/auth/screens/otp_screen.dart';
import 'package:redox_ui/features/landing/screens/landing_screen.dart';
import 'package:redox_ui/firebase_options.dart';
import 'package:redox_ui/router.dart';
//import 'package:redox_ui/widgets/contacts_list.dart';
/*import 'package:redox_ui/screens/mobile_layout_screen.dart';
import 'package:redox_ui/screens/web_layout_screen.dart';
import 'package:redox_ui/utils/responsive_layout.dart';*/

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const  MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      home: const LandingScreen(),
      /*const ResponsiveLayout(
        mobileScreenLayout: MobileLayoutScreen(),
        webScreenLayout: WebLayoutScreen(),
      ),*/
    );
  }
}
