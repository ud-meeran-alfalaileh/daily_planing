import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planning/src/core/backend/authentication/authentication.dart';
import 'package:daily_planning/src/core/backend/user_repository/user_repository.dart';
import 'package:daily_planning/src/featuers/intropage/view/buttons_page.dart';
import 'package:daily_planning/src/featuers/login/view/login_page.dart';
import 'package:daily_planning/src/featuers/main_page/view/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserTypeCheck extends StatefulWidget {
  const UserTypeCheck({
    super.key,
  });

  @override
  State<UserTypeCheck> createState() => _UserTypeCheckState();
}

class _UserTypeCheckState extends State<UserTypeCheck> {
  final _authRepo = Get.put(AuthenticationRepository());
  late final email = _authRepo.firebaseUser.value?.email;
  final userRepository = Get.put(UserRepository());

  @override
  void initState() {
    super.initState();
    if (email != null) {
      userRepository.getUserDetails(email!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('User')
          .where('Email', isEqualTo: email ?? "")
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Loading...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return const ButtonsPage();
        }
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return const ButtonsPage(); // No user found, redirect to login
          }

          return const MainPage();
        }
        return const LoginScreen();
      },
    );
  }
}
