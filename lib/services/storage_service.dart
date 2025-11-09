import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_message.dart';
import '../models/loan_calculation.dart';
import '../constants/app_constants.dart';

/// Service for handling local storage operations
class StorageService {
  /// Save chat history
  Future<void> saveChatHistory(List<ChatMessage> history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(
        history.map((e) => e.toJson()).toList(),
      );
      await prefs.setString(AppConstants.chatHistoryKey, json);
    } catch (e) {
      throw Exception('Failed to save chat history: $e');
    }
  }

  /// Load chat history
  Future<List<ChatMessage>> loadChatHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(AppConstants.chatHistoryKey);

      if (historyJson == null) return [];

      final List<dynamic> decoded = jsonDecode(historyJson);
      return decoded.map((e) => ChatMessage.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Save loan calculations
  Future<void> saveLoanCalculations(
      List<LoanCalculation> calculations) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(
        calculations.map((e) => e.toJson()).toList(),
      );
      await prefs.setString(AppConstants.loanCalculationsKey, json);
    } catch (e) {
      throw Exception('Failed to save loan calculations: $e');
    }
  }

  /// Load loan calculations
  Future<List<LoanCalculation>> loadLoanCalculations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final calculationsJson =
          prefs.getString(AppConstants.loanCalculationsKey);

      if (calculationsJson == null) return [];

      final List<dynamic> decoded = jsonDecode(calculationsJson);
      return decoded
          .map((e) => LoanCalculation.fromJson(e))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Check if onboarding is complete
  Future<bool> isOnboardingComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(AppConstants.onboardingCompleteKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Mark onboarding as complete
  Future<void> setOnboardingComplete(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.onboardingCompleteKey, value);
    } catch (e) {
      throw Exception('Failed to save onboarding status: $e');
    }
  }

  /// Clear all data
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.chatHistoryKey);
      await prefs.remove(AppConstants.loanCalculationsKey);
    } catch (e) {
      throw Exception('Failed to clear data: $e');
    }
  }
}

