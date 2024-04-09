import 'package:flutter/material.dart';
import 'package:redox_ui/colors.dart';
import 'package:redox_ui/screens/mobile_layout_screen.dart';
import 'package:redox_ui/screens/web_layout_screen.dart';
import 'package:redox_ui/utils/responsive_layout.dart';

void main() {
  runApp(const MyApp());
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
      ),
      home: const ResponsiveLayout(
        mobileScreenLayout: MobileLayoutScreen(),
        webScreenLayout: WebLayoutScreen(),
      ),
    );
  }
}
