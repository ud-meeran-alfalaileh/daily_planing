import 'package:daily_planning/src/config/theme/theme.dart';
import 'package:daily_planning/src/core/widget/buttons/buttons.dart';
import 'package:daily_planning/src/core/widget/text/text.dart';
import 'package:daily_planning/src/featuers/login/view/login_page.dart';
import 'package:daily_planning/src/featuers/signup/view/register_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ButtonsPage extends StatelessWidget {
  const ButtonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColor.mainAppColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(20),
            TextApp.mainAppText('Daily Plaing and \n learing mangmnent'),
            const Gap(20),
            Buttons.selectedButton("login", () => Get.to(const LoginScreen())),
            const Gap(20),
            Buttons.selectedButton(
                "sign up", () => Get.to(const RegisterScreen()))
          ],
        ),
      ),
    ));
  }
}
