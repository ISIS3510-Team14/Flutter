import 'dart:convert';

class ChatRequest {
  final List<Message> messages;
  final int maxTokens;

  ChatRequest({
    required this.messages,
    required this.maxTokens,
  });

  String toJson() {
    return json.encode({
      'messages': messages.map((message) => message.toJson()).toList(),
      'max_tokens': maxTokens,
    });
  }

}

class Message {
  final String role;
  final List<Map<String, dynamic>> content;

  Message({required this.role, required this.content});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'],
      content: List<Map<String, dynamic>>.from(json['content']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
}
