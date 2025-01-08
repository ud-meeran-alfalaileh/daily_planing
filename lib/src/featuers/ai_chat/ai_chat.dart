import 'package:daily_planning/src/config/theme/theme.dart';
import 'package:daily_planning/src/featuers/ai_chat/ai_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AiChat extends StatefulWidget {
  const AiChat({
    super.key,
  });

  @override
  State<AiChat> createState() => _AiChatState();
}

class _AiChatState extends State<AiChat> {
  final ChatController controller = Get.put(
    ChatController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainAppColor,
      body: SafeArea(
        child: Column(
          children: [
            //
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      color: Color(0xffffffff),
                    )),
                Text("ChatBot"),
              ],
            ),
            // Chat messages
            Obx(
              () => Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: controller.chatMessages.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 10,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                              controller.chatMessages[index].user.id == '1'
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * .6,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColor.textFiledcolor),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(controller
                                        .chatMessages[index].user.firstName!),
                                    Text(controller.chatMessages[index].text),
                                  ],
                                )),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white
                  .withOpacity(0.4), // Add background for better visibility
              child: Row(
                children: [
                  // Text input
                  Expanded(
                    child: TextField(
                        controller: controller.messageController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.4),
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                          ),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.1),
                            ),
                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                          ),
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(
                            fontFamily: "kanti",
                            fontWeight: FontWeight.w200,
                            letterSpacing: .5,
                            color: Colors.black.withOpacity(.5),
                            fontSize: 20,
                          ),
                        )),
                  ),
                  // Send button
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: AppColor.subappcolor,
                    ),
                    onPressed: () {
                      final message = controller.messageController.text.trim();
                      if (message.isNotEmpty) {
                        controller.sendMessage();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
