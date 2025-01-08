// ignore_for_file: avoid_print

import 'package:daily_planning/src/config/theme/theme.dart';
import 'package:daily_planning/src/core/backend/exceptions/exceptions.dart';
import 'package:daily_planning/src/core/backend/user_repository/user_repository.dart';
import 'package:daily_planning/src/featuers/main_page/view/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    // Bind the current user to the firebaseUser Rx variable
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen); // Monitor user changes
  }

  void _setInitialScreen(User? user) {
    print(user!.email);
    // Navigate to the main page if user is logged in
    Get.offAll(() => const MainPage());
  }

  Future<bool> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      _showErrorSnackbar(e.message);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      print(LogInWithEmailAndPasswordFailure.code(e.code).message);
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  void _showErrorSnackbar(String? message) {
    Get.snackbar(
      "ERROR",
      message ?? "An unexpected error occurred",
      snackPosition: SnackPosition.BOTTOM,
      colorText: AppColor.mainAppColor,
      backgroundColor: AppColor.error,
    );
  }
}
