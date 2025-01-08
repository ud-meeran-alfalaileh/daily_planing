import 'package:daily_planning/src/core/backend/authentication/authentication.dart';
import 'package:daily_planning/src/core/backend/user_repository/user_repository.dart';
import 'package:daily_planning/src/core/controller/user_controller.dart';
import 'package:daily_planning/src/featuers/add_mission/view/mession_view.dart';
import 'package:daily_planning/src/featuers/profile/model/profile_button_model.dart';
import 'package:daily_planning/src/featuers/reminder/view/reminder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final _authRepo = Get.put(AuthenticationRepository());

  late final email = _authRepo.firebaseUser.value?.email;

  final userRepository = Get.put(UserRepository());
  List<ProfileButton> profileList = [];

  @override
  void onInit() {
    super.onInit();
    userRepository.getUserDetails(email ?? '');

    profileList = [
      ProfileButton(
          title: 'My Reminder',
          icon: SvgPicture.asset(
            'assets/arrow.svg',
            matchTextDirection: true,
            width: 15,
            height: 15,
          ),
          onTap: () {
            print("object");
            Get.to(Reminderpage(
              userEmail: email!,
            ));
          }),
      ProfileButton(
          title: 'my Tasks',
          icon: SvgPicture.asset(
            'assets/arrow.svg',
            matchTextDirection: true,
            width: 15,
            height: 15,
          ),
          onTap: () => Get.to(
              MissionViewTest(
                userEmail: email!,
              ),
              transition: Transition.rightToLeft)),
      ProfileButton(
          title: 'my assigment',
          icon: SvgPicture.asset(
            'assets/arrow.svg',
            matchTextDirection: true,
            width: 15,
            height: 15,
          ),
          onTap: () =>
              Get.to(const Scaffold(), transition: Transition.rightToLeft)),
      ProfileButton(
        title: 'Logout',
        icon: SvgPicture.asset(
          'assets/arrow.svg',
          matchTextDirection: true,
          width: 15,
          height: 15,
        ),
        onTap: () => {
          AuthenticationRepository().logout(),
          UserController.instance.clearUserInfo()
        },
      ),
    ];
  }
}
