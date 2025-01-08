import 'package:daily_planning/src/config/theme/theme.dart';
import 'package:daily_planning/src/featuers/intropage/view/check_login_page.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.subappcolor,
        body: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserTypeCheck()),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset('assets/AppImage.png')],
          ),
        ),
      ),
    );
  }
}
