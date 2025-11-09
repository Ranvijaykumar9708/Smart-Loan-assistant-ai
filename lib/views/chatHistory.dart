

// 2. VIEWMODEL - Update your home_view_model.dart
import 'dart:convert';
import 'dart:ui';
import 'package:agent/view_models/chatHistoryModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomeViewModel extends ChangeNotifier {
  String _loanType = 'Personal Loan';
  String _query = '';
  String _response = '';
  bool _isLoading = false;
  List<ChatMessage> _chatHistory = [];
  
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
    const apiKey = 'YOUR_GEMINI_API_KEY'; // Move to env file
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: apiKey,
    );
  }

  // Load chat history from local storage
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

  // Save chat history to local storage
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

  // Generate content with Gemini
  Future<void> generateContent() async {
    if (_query.trim().isEmpty) return;

    _isLoading = true;
    _response = '';
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
      final response = await _model.generateContent(content);

      _response = response.text ?? 'Sorry, I could not generate a response.';
      
      // Save to history
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        question: _query,
        response: _response,
        loanType: _loanType,
        timestamp: DateTime.now(),
      );
      
      _chatHistory.insert(0, message); // Add to top
      await _saveChatHistory();
      
    } catch (e) {
      _response = 'Error: Unable to connect to AI service. Please check your internet connection and API key.';
      debugPrint('Gemini API Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
}

// 3. CHAT HISTORY SCREEN - chat_history_view.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'dart:ui';
// import '../view_models/home_view_model.dart';

class ChatHistoryView extends StatefulWidget {
  const ChatHistoryView({super.key});

  @override
  State<ChatHistoryView> createState() => _ChatHistoryViewState();
}

class _ChatHistoryViewState extends State<ChatHistoryView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final filteredHistory = vm.searchHistory(_searchQuery);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Chat History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (vm.chatHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.white),
              onPressed: () => _showClearDialog(context, vm),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search conversations...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // History List
          Expanded(
            child: filteredHistory.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 80,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No chat history yet'
                              : 'No results found',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredHistory.length,
                    itemBuilder: (context, index) {
                      final chat = filteredHistory[index];
                      return _buildChatCard(context, chat, vm);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatCard(BuildContext context, ChatMessage chat, HomeViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              chat.loanType,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _formatDate(chat.timestamp),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.white.withOpacity(0.5),
                          size: 20,
                        ),
                        onPressed: () => vm.deleteChat(chat.id),
                      ),
                    ],
                  ),
                ),
                // Question
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white.withOpacity(0.7),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Question',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        chat.question,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.white.withOpacity(0.7),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Answer',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        chat.response,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          height: 1.5,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showClearDialog(BuildContext context, HomeViewModel vm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Clear All History?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will permanently delete all your chat history.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              vm.clearAllHistory();
              Navigator.pop(context);
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

