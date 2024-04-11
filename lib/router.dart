
import 'package:flutter/material.dart';
import 'package:redox_ui/common/widgets/error.dart';
import 'package:redox_ui/features/auth/screens/login_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
      default:
      return MaterialPageRoute(builder: (context)=> const Scaffold(
        body: ErrorScreen(error: 'This page does\'nt exist'),
      ),);
  }
} 