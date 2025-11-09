// 1. MODEL - chat_message.dart
class ChatMessage {
  final String id;
  final String question;
  final String response;
  final String loanType;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.question,
    required this.response,
    required this.loanType,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'response': response,
        'loanType': loanType,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'],
        question: json['question'],
        response: json['response'],
        loanType: json['loanType'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}