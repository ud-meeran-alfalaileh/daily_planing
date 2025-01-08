import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planning/src/featuers/main_page/view/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SchuldePage extends StatefulWidget {
  const SchuldePage(
      {required this.pdfText,
      required this.strartDate,
      required this.endDate,
      required this.email,
      super.key});

  final String pdfText;
  final String strartDate;
  final String email;

  final String endDate;

  @override
  _SchuldePageState createState() => _SchuldePageState();
}

class _SchuldePageState extends State<SchuldePage> {
  String schludeData = "";

  @override
  void initState() {
    super.initState();
    fetchData();
    print(widget.pdfText);
    print(widget.pdfText);
    print(widget.pdfText);
  }

  Future<void> addStudyPlanToFirebase(String userEmail, String startDate,
      String endDate, String studyPlan) async {
    try {
      // Access Firestore instance
      FirebaseFirestore firestore =
          FirebaseFirestore.instance; // Collection reference
      CollectionReference studyPlansCollection =
          firestore.collection('study_plans'); // Add data to Firestore
      await studyPlansCollection.add({
        'user_email': userEmail,
        'start_date': startDate,
        'end_date': endDate,
        'study_plan': studyPlan,
      });
      print('Study plan added successfully!');
    } catch (error) {
      print('Error adding study plan: $error');
    }
  }

  Future<void> generateResponse() async {
    try {
      var response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
""        },
        body: json.encode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'user',
              'content':
                  "for a study plan ${widget.pdfText} that from date ${widget.strartDate} to ${widget.endDate}"
            },
          ],
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
        var responseText = data['choices'][0]['message']['content'];
        setState(() {
          schludeData = responseText;
        });
        // Add AI's response to chatMessages
      } else {}
    } catch (e) {}
  }

  Future<void> fetchData() async {
    print(widget.pdfText);
    generateResponse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(widget.email);

          await addStudyPlanToFirebase(
              widget.email, widget.strartDate, widget.endDate, schludeData);

          Get.to(
            const MainPage(),
          );
        },
        child: Icon(Icons.exit_to_app),
      ),
      appBar: AppBar(
        title: const Text('schulde'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Text(
                schludeData,
                style: TextStyle(),
              )),
        ),
      ),
    );
  }
}
