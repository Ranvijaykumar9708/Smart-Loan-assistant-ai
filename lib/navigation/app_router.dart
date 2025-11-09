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
import '../views/amortization_schedule_view.dart';
import '../views/prepayment_calculator_view.dart';
import '../views/bank_directory_view.dart';
import '../views/stock_market_dashboard_view.dart';
import '../views/virtual_portfolio_view.dart';
import '../views/stock_detail_view.dart';
import '../views/market_news_view.dart';
import '../models/stock.dart';

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
  static const String amortizationSchedule = '/amortization-schedule';
  static const String prepaymentCalculator = '/prepayment-calculator';
  static const String bankDirectory = '/bank-directory';
  static const String stockMarketDashboard = '/stock-market-dashboard';
  static const String virtualPortfolio = '/virtual-portfolio';
  static const String stockDetail = '/stock-detail';
  static const String marketNews = '/market-news';

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
    } else if (routeName == amortizationSchedule) {
      return MaterialPageRoute(builder: (_) => const AmortizationScheduleView());
    } else if (routeName == prepaymentCalculator) {
      return MaterialPageRoute(builder: (_) => const PrepaymentCalculatorView());
    } else if (routeName == bankDirectory) {
      return MaterialPageRoute(builder: (_) => const BankDirectoryView());
    } else if (routeName == stockMarketDashboard) {
      return MaterialPageRoute(builder: (_) => const StockMarketDashboardView());
    } else if (routeName == virtualPortfolio) {
      return MaterialPageRoute(builder: (_) => const VirtualPortfolioView());
    } else if (routeName == marketNews) {
      return MaterialPageRoute(builder: (_) => const MarketNewsView());
    } else if (routeName == stockDetail) {
      final stock = routeSettings.arguments as Stock;
      return MaterialPageRoute(builder: (_) => StockDetailView(stock: stock));
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

