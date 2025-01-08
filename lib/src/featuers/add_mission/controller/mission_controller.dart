import 'package:daily_planning/src/config/theme/theme.dart';
import 'package:daily_planning/src/core/backend/mission_backend/mission_repository.dart';
import 'package:daily_planning/src/core/model/mission.dart';
import 'package:daily_planning/src/featuers/add_mission/view/mession_view.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/src/media_type.dart';

class MissionController extends GetxController {
  TextEditingController missionNameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController pdfPathController = TextEditingController();
  final MissionRepository _missionRepository = MissionRepository.instance;
  final addformkey = GlobalKey<FormState>();
  RxList<Mission> userMissions = <Mission>[].obs;
  RxString? _uploadedImageUrl;
  clear() {
    missionNameController.clear();

    typeController.clear();
    startDateController.clear();
    endDateController.clear();
    pdfPathController.clear();
    statusController.clear();
  }

  validateDescription(String? title) {
    if (title!.isNotEmpty) {
      return null;
    }
    return 'Description is not vaild';
  }

  void createMission(Mission mission) {
    _missionRepository.createMission(mission);
    userMissions.add(mission);
  }

  void updateMission(Mission mission) {
    _missionRepository.updateMission(mission);
  }

  Future<void> fetchUserMissions(String userEmail) async {
    final missions = await _missionRepository.getUserMissions(userEmail);
    userMissions.value = missions;
  }

  vaildateServue(String? userName) {
    if (GetUtils.isUsername(userName!)) {
      return null;
    }
    return 'UserName is not vaild';
  }

  vaildateFild(dynamic text) {
    if (GetUtils.isBlank(text!)!) {
      return null;
    }
    return 'UserName is not vaild';
  }

  notEmpty(controller) {
    return controller?.text != null && controller.text.isNotEmpty;
  }

  onadd(Mission mission) {
    if (addformkey.currentState!.validate()) {
      createMission(mission);
      Get.off(MissionViewTest(userEmail: mission.userEmail));
      Get.snackbar("Success", "Added successfult",
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColor.mainAppColor,
          backgroundColor: AppColor.success);
      clear();
    } else if (typeController.text.isEmpty) {
      Get.snackbar("ERROR", "please chose the type",
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColor.mainAppColor,
          backgroundColor: AppColor.error);
    } else {
      Get.snackbar("ERROR", "invild form",
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColor.mainAppColor,
          backgroundColor: AppColor.error);
    }
  }

  Future<void> uploadMedia(String file) async {
    dio.Dio dioInstance = dio.Dio();
    dio.FormData formData = dio.FormData.fromMap({
      'file': await dio.MultipartFile.fromFile(
        file,
        contentType: MediaType('file', 'pdf'),
      ),
    });

    try {
      final response = await dioInstance.post(
        "https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/ImageUpload/upload",
        data: formData,
        options: dio.Options(
          headers: {
            "Accept": 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      print(response.data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // isLoading.value = false;
        final jsonData = response.data;
        final fileName = jsonData['path'];
        print(fileName);
        pdfPathController.text = fileName;
        _uploadedImageUrl = fileName;
      } else {
        // isLoading.value = false;
      }
    } catch (e) {
      // isLoading.value = false;

      print(" $e");
    }
  }

  @override
  void onClose() {
    // Close resources here if necessary
    super.onClose();
  }
}
