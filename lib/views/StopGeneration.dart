// Updated HomeViewModel with Stop Generation Feature
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomeViewModel extends ChangeNotifier {
  String _loanType = 'Personal Loan';
  String _query = '';
  String _response = '';
  bool _isLoading = false;
  List<ChatMessage> _chatHistory = [];
  
  // For stopping generation
  bool _shouldStop = false;
  StreamSubscription? _streamSubscription;
  
  // Gemini API
  late GenerativeModel _model;
  
  String get loanType => _loanType;
  String get query => _query;
  String get response => _response;
  bool get isLoading => _isLoading;
  List<ChatMessage> get chatHistory => _chatHistory;

  HomeViewModel() {
    _initializeGemini();
    _loadChatHistory();
  }

  void _initializeGemini() {
    const apiKey = 'YOUR_GEMINI_API_KEY'; // Move to .env file
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
  }

  Future<void> _loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('chat_history');
      
      if (historyJson != null) {
        final List<dynamic> decoded = json.decode(historyJson);
        _chatHistory = decoded.map((e) => ChatMessage.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading chat history: $e');
    }
  }

  Future<void> _saveChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = json.encode(
        _chatHistory.map((e) => e.toJson()).toList(),
      );
      await prefs.setString('chat_history', historyJson);
    } catch (e) {
      debugPrint('Error saving chat history: $e');
    }
  }

  void setLoanType(String type) {
    _loanType = type;
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  // Stop the current generation
  void stopGeneration() {
    _shouldStop = true;
    _streamSubscription?.cancel();
    _streamSubscription = null;
    
    if (_response.isNotEmpty) {
      // Save partial response
      _response += '\n\n[Generation stopped by user]';
      _savePartialResponse();
    } else {
      _response = 'Generation was stopped before completion.';
    }
    
    _isLoading = false;
    notifyListeners();
    
    debugPrint('Generation stopped by user');
  }

  Future<void> _savePartialResponse() async {
    if (_query.trim().isEmpty || _response.isEmpty) return;
    
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      question: _query,
      response: _response,
      loanType: _loanType,
      timestamp: DateTime.now(),
    );
    
    _chatHistory.insert(0, message);
    await _saveChatHistory();
  }

  // Generate content with streaming (allows stopping)
  Future<void> generateContent() async {
    if (_query.trim().isEmpty) return;

    _isLoading = true;
    _response = '';
    _shouldStop = false;
    notifyListeners();

    try {
      final prompt = '''
You are a helpful loan advisor assistant. The user has selected: $_loanType

User Question: $_query

Provide a clear, concise, and helpful answer about this loan type. Include:
- Key information about the loan
- Important considerations
- Practical advice

Keep the response under 200 words and make it easy to understand.
''';

      final content = [Content.text(prompt)];
      
      // Use streaming for real-time response
      final stream = _model.generateContentStream(content);
      
      _streamSubscription = stream.listen(
        (chunk) {
          if (_shouldStop) {
            _streamSubscription?.cancel();
            return;
          }
          
          final text = chunk.text;
          if (text != null) {
            _response += text;
            notifyListeners(); // Update UI in real-time
          }
        },
        onDone: () {
          if (!_shouldStop) {
            _saveCompletedResponse();
          }
          _isLoading = false;
          _streamSubscription = null;
          notifyListeners();
        },
        onError: (error) {
          if (!_shouldStop) {
            _response = 'Error: Unable to connect to AI service. Please check your internet connection and API key.';
            debugPrint('Gemini API Error: $error');
          }
          _isLoading = false;
          _streamSubscription = null;
          notifyListeners();
        },
        cancelOnError: true,
      );
      
    } catch (e) {
      if (!_shouldStop) {
        _response = 'Error: Unable to generate response. Please try again.';
        debugPrint('Generation Error: $e');
      }
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveCompletedResponse() async {
    if (_query.trim().isEmpty || _response.isEmpty) return;
    
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      question: _query,
      response: _response,
      loanType: _loanType,
      timestamp: DateTime.now(),
    );
    
    _chatHistory.insert(0, message);
    await _saveChatHistory();
  }

  // Delete specific chat
  Future<void> deleteChat(String id) async {
    _chatHistory.removeWhere((chat) => chat.id == id);
    await _saveChatHistory();
    notifyListeners();
  }

  // Clear all history
  Future<void> clearAllHistory() async {
    _chatHistory.clear();
    await _saveChatHistory();
    notifyListeners();
  }

  // Search in history
  List<ChatMessage> searchHistory(String searchQuery) {
    if (searchQuery.isEmpty) return _chatHistory;
    
    return _chatHistory.where((chat) {
      return chat.question.toLowerCase().contains(searchQuery.toLowerCase()) ||
             chat.response.toLowerCase().contains(searchQuery.toLowerCase()) ||
             chat.loanType.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  // Get history by loan type
  List<ChatMessage> getHistoryByLoanType(String type) {
    return _chatHistory.where((chat) => chat.loanType == type).toList();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}

// ChatMessage Model (same as before)
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

// USAGE NOTES:
/*
1. The stop buttons in your home_view.dart should now call:
   onTap: () => vm.stopGeneration(),

2. This implementation uses Gemini's streaming API which allows:
   - Real-time response generation (typewriter effect naturally)
   - Ability to stop generation at any time
   - Saves partial responses if stopped
   
3. The streaming response updates the UI automatically as text arrives

4. When stopped:
   - Cancels the stream subscription
   - Saves partial response to history
   - Shows "[Generation stopped by user]" marker
   - Cleans up resources properly

5. Error handling:
   - Network errors handled gracefully
   - API errors don't crash the app
   - User-friendly error messages

6. Memory management:
   - Stream subscription properly disposed
   - No memory leaks from uncancelled subscriptions
*/

// ENVIRONMENT VARIABLE SETUP (.env file):
/*
Create a .env file in your project root:

GEMINI_API_KEY=your_actual_api_key_here

Then use flutter_dotenv package:

dependencies:
  flutter_dotenv: ^5.1.0

In main.dart:
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

In HomeViewModel:
void _initializeGemini() {
  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  _model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: apiKey,
  );
}

Add to .gitignore:
.env
*/