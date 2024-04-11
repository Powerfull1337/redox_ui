import 'package:flutter/material.dart';
import 'package:redox_ui/colors.dart';
import 'package:redox_ui/common/widgets/custom_button.dart';
import 'package:redox_ui/screens/mobile_layout_screen.dart';
import 'package:redox_ui/widgets/contacts_list.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('We have sent an SMS with a code.'),
            SizedBox(
              width: size.width * 0.5,
              child: const TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '- - - - - -',
                  hintStyle: TextStyle(
                    fontSize: 30,
                  ),
                ),
              )
            ),
             const Spacer(), 
             SizedBox(
              width: 90,
              child: CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
                  );
                },
                text: 'NEXT',
              ),
            )
          ]
        )
      )
    );
  }
}