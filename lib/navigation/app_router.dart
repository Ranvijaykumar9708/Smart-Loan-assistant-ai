import 'package:flutter/material.dart';
import '../views/home_view.dart';
import '../views/chat_history_view.dart';
import '../views/emi_calculator_view.dart';
import '../views/loan_eligibility_view.dart';
import '../views/loan_comparison_view.dart';
import '../views/document_checklist_view.dart';
import '../views/loan_tips_view.dart';
import '../views/settings_view.dart';
import '../views/splash_view.dart';
import '../views/onboarding_view.dart';

/// App router for navigation
class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String chatHistory = '/chat-history';
  static const String emiCalculator = '/emi-calculator';
  static const String loanEligibility = '/loan-eligibility';
  static const String loanComparison = '/loan-comparison';
  static const String documentChecklist = '/document-checklist';
  static const String loanTips = '/loan-tips';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final routeName = routeSettings.name;
    
    if (routeName == splash) {
      return MaterialPageRoute(builder: (_) => const SplashView());
    } else if (routeName == onboarding) {
      return MaterialPageRoute(builder: (_) => const OnboardingView());
    } else if (routeName == home) {
      return MaterialPageRoute(builder: (_) => const HomeView());
    } else if (routeName == chatHistory) {
      return MaterialPageRoute(builder: (_) => const ChatHistoryView());
    } else if (routeName == emiCalculator) {
      return MaterialPageRoute(builder: (_) => const EmiCalculatorView());
    } else if (routeName == loanEligibility) {
      return MaterialPageRoute(builder: (_) => const LoanEligibilityView());
    } else if (routeName == loanComparison) {
      return MaterialPageRoute(builder: (_) => const LoanComparisonView());
    } else if (routeName == documentChecklist) {
      return MaterialPageRoute(builder: (_) => const DocumentChecklistView());
    } else if (routeName == loanTips) {
      return MaterialPageRoute(builder: (_) => const LoanTipsView());
    } else if (routeName == settings) {
      return MaterialPageRoute(builder: (_) => const SettingsView());
    } else {
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No route defined for $routeName'),
          ),
        ),
      );
    }
  }
}

