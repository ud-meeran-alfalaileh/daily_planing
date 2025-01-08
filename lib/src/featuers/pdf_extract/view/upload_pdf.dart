import 'package:daily_planning/src/config/theme/theme.dart';
import 'package:daily_planning/src/core/widget/buttons/buttons.dart';
import 'package:daily_planning/src/featuers/pdf_extract/view/extract_page.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/src/media_type.dart';

class PdfUpload extends StatefulWidget {
  const PdfUpload({
    super.key,
    required this.email,
  });
  final String email;
  @override
  _PdfUploadState createState() => _PdfUploadState();
}

class _PdfUploadState extends State<PdfUpload> {
  String? path;
  bool isLoading = false;

  Future<void> _pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      String filePath = result.files.single.path!;

      try {
        // Save the file path in Firestore
        uploadMedia(filePath);
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload file: $e')),
        );
      }
    } else {
      // User canceled the picker
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
        setState(() {
          path = fileName;
          isLoading = false;
        });
      } else {
        // isLoading.value = false;
      }
    } catch (e) {
      // isLoading.value = false;

      print(" $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Your PDF'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.picture_as_pdf,
                      size: 100,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Upload Your PDF',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: isLoading ? null : _pickAndUploadFile,
                      icon: const Icon(Icons.upload_file),
                      label: Text(isLoading ? 'Uploading...' : 'Select PDF'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (path != null)
                Column(
                  children: [
                    Text(
                      'File uploaded to: $path',
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              const Spacer(),
              Buttons.selectedButton(
                  'lets go',
                  () => path == null
                      ? Get.snackbar("Filed", "please upload the pdf",
                          snackPosition: SnackPosition.BOTTOM,
                          colorText: AppColor.mainAppColor,
                          backgroundColor: AppColor.error)
                      : Get.to(PdfTextExtractorScreen(
                          pdfPath: path ?? '',
                          email: widget.email,
                        )))
            ],
          ),
        ),
      ),
    );
  }
}
