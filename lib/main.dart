import 'package:daily_planning/firebase_options.dart';
 import 'package:daily_planning/src/config/theme/theme.dart';
import 'package:daily_planning/src/core/backend/authentication/authentication.dart';
import 'package:daily_planning/src/core/backend/mission_backend/mission_repository.dart';
import 'package:daily_planning/src/core/backend/reminder_backend/reminder_repository.dart';
import 'package:daily_planning/src/featuers/intropage/view/intropage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));
  Get.put(MissionRepository());
  Get.put(ReminderRepository());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DPLMS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.subappcolor),
        useMaterial3: true,
      ),
      home: const IntroPage(),
    );
  }
}
