import 'package:http/http.dart' as http;
import 'api_key.dart';
import 'dart:convert';
import '../../models/chat_request.dart';

class ChatService {
  static final Uri chatUri = Uri.parse('https://${ApiKey.openAIApiEndpoint}/openai/deployments/gpt-4o/chat/completions?api-version=2024-02-01&api-key=${ApiKey.openAIApiKey}');
  Map<String, String> headers = {
  'Content-Type': 'application/json',
  };

  Future<String?> request(String prompt, String photoBase64) async {
    try {
      Message message = Message(
        role: "user",
          content: [
            {"type": "text", "text": prompt},
            {
              "type": "image_url",
              "image_url": {"url": "data:image/png;base64,$photoBase64"},
            },
          ],
        );

      ChatRequest request = ChatRequest(maxTokens: 50, messages: [message]);
      if (prompt.isEmpty) {
        return null;
      }
      http.Response response = await http.post(
        chatUri,
        headers: headers,
        body: request.toJson(),
      );
      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var result = responseBody['choices'][0]['message']['content'];
        return result;
      } else {
        return null;
      }
    } catch (e) {
      print("an error was found: $e");
    }
    return null;
  }
}