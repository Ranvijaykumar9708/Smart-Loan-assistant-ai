import 'package:flutter/foundation.dart';
import '../utils/loan_calculator.dart';

/// View model for loan eligibility calculator
class LoanEligibilityViewModel extends ChangeNotifier {
  double _monthlyIncome = 50000;
  double _existingEMI = 0;
  double _interestRate = 10.5;
  double _tenureMonths = 24;
  double _eligibleAmount = 0;

  double get monthlyIncome => _monthlyIncome;
  double get existingEMI => _existingEMI;
  double get interestRate => _interestRate;
  double get tenureMonths => _tenureMonths;
  double get eligibleAmount => _eligibleAmount;

  LoanEligibilityViewModel() {
    _calculateEligibility();
  }

  /// Set monthly income
  void setMonthlyIncome(double value) {
    _monthlyIncome = value;
    _calculateEligibility();
    notifyListeners();
  }

  /// Set existing EMI
  void setExistingEMI(double value) {
    _existingEMI = value;
    _calculateEligibility();
    notifyListeners();
  }

  /// Set interest rate
  void setInterestRate(double value) {
    _interestRate = value;
    _calculateEligibility();
    notifyListeners();
  }

  /// Set tenure in months
  void setTenureMonths(double value) {
    _tenureMonths = value;
    _calculateEligibility();
    notifyListeners();
  }

  /// Calculate eligibility
  void _calculateEligibility() {
    _eligibleAmount = LoanCalculator.calculateEligibility(
      monthlyIncome: _monthlyIncome,
      existingEMI: _existingEMI,
      interestRate: _interestRate,
      tenureMonths: _tenureMonths,
    );
    notifyListeners();
  }
}

