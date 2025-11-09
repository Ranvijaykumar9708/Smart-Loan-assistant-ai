import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/loan_type.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

/// View model for home screen
class HomeViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  String _loanType = LoanType.allTypes[0].name;
  String _query = '';
  String _response = '';
  bool _isLoading = false;
  List<ChatMessage> _chatHistory = [];

  String get loanType => _loanType;
  String get query => _query;
  String get response => _response;
  bool get isLoading => _isLoading;
  List<ChatMessage> get chatHistory => _chatHistory;

  HomeViewModel() {
    _loadChatHistory();
  }

  /// Load chat history from storage
  Future<void> _loadChatHistory() async {
    try {
      _chatHistory = await _storageService.loadChatHistory();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading chat history: $e');
    }
  }

  /// Set loan type
  void setLoanType(String type) {
    _loanType = type;
    notifyListeners();
  }

  /// Set query text
  void setQuery(String value) {
    _query = value.trim();
    notifyListeners();
  }

  /// Generate content using AI
  Future<void> generateContent() async {
    if (_query.isEmpty) {
      _response = 'Please enter your question about $_loanType.';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _response = '';
    notifyListeners();

    try {
      // Enhance query with summarization constraint
      final enhancedQuery = '''
Provide a clear and concise response (strictly maximum 500 words, without using astericks in text) about $_loanType to the following question:

$_query

Focus on key points and practical information. Avoid unnecessary details. Don't use astericks, **, or hashes in the text. Add emojis where appropriate.
''';

      final response = await _apiService.generateContent(
        query: enhancedQuery,
        loanType: _loanType,
      );

      _response = response;

      // Save to history
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        question: _query,
        response: _response,
        loanType: _loanType,
        timestamp: DateTime.now(),
      );

      _chatHistory.insert(0, message);
      await _storageService.saveChatHistory(_chatHistory);
    } catch (e) {
      _response = '❌ Error: ${e.toString()}';
      debugPrint('Error generating content: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete specific chat
  Future<void> deleteChat(String id) async {
    _chatHistory.removeWhere((chat) => chat.id == id);
    await _storageService.saveChatHistory(_chatHistory);
    notifyListeners();
  }

  /// Clear all history
  Future<void> clearAllHistory() async {
    _chatHistory.clear();
    await _storageService.saveChatHistory(_chatHistory);
    notifyListeners();
  }

  /// Search in history
  List<ChatMessage> searchHistory(String searchQuery) {
    if (searchQuery.isEmpty) return _chatHistory;

    return _chatHistory.where((chat) {
      return chat.question.toLowerCase().contains(searchQuery.toLowerCase()) ||
          chat.response.toLowerCase().contains(searchQuery.toLowerCase()) ||
          chat.loanType.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  /// Get history by loan type
  List<ChatMessage> getHistoryByLoanType(String type) {
    return _chatHistory.where((chat) => chat.loanType == type).toList();
  }
}
