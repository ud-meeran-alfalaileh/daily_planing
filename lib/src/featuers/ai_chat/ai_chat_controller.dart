import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  RxList<ChatMessage> chatMessages = <ChatMessage>[].obs;
  RxBool isWriting = false.obs;
  late ChatUser currentUser = ChatUser(
    id: "0",
    firstName: 'User',
  );

  ChatUser chatGptUser = ChatUser(
    id: "1",
    firstName: "AI",
  );

  List<Map<String, dynamic>> conversationHistory = [];

  Future<void> sendMessage() async {
    // messageController.clear();
    isWriting.value = true;
    // Add user's message to chatMessages
    ChatMessage userMessage = ChatMessage(
      user: currentUser,
      createdAt: DateTime.now(),
      text: messageController.text,
    );
    chatMessages.insert(0, userMessage);
    messageController.clear();

    // Add message to conversationHistory
    conversationHistory
        .add({'role': 'user', 'content': messageController.text});

    await generateResponse(messageController.text);
  }

  Future<void> generateResponse(
    String message,
  ) async {
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
            {'role': 'user', 'content': message},
            ...conversationHistory,
          ],
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        var data = json.decode(utf8.decode(response.bodyBytes));
        var responseText = data['choices'][0]['message']['content'];

        // Add AI's response to chatMessages
        ChatMessage aiMessage = ChatMessage(
          user: chatGptUser,
          createdAt: DateTime.now(),
          text: responseText,
        );
        chatMessages.insert(0, aiMessage);

        // Update conversationHistory
        conversationHistory.add({'role': 'assistant', 'content': responseText});
      } else {
        ChatMessage errorMessage = ChatMessage(
          user: chatGptUser,
          createdAt: DateTime.now(),
          text: "Error: Unable to fetch response.",
        );
        chatMessages.insert(0, errorMessage);
      }
    } catch (e) {
      ChatMessage errorMessage = ChatMessage(
        user: chatGptUser,
        createdAt: DateTime.now(),
        text: "Error: Unable to fetch response.",
      );
      chatMessages.insert(0, errorMessage);
    }
  }
}
