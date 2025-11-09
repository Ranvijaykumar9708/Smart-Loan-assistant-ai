import 'package:flutter/foundation.dart';
import '../models/prepayment_calculation.dart';
import '../utils/prepayment_calculator.dart';

/// View model for prepayment calculator
class PrepaymentViewModel extends ChangeNotifier {
  double _loanAmount = 500000;
  double _interestRate = 10.5;
  double _tenureMonths = 24;
  double _prepaymentAmount = 100000;
  int _prepaymentMonth = 12;
  PrepaymentCalculation? _calculation;

  double get loanAmount => _loanAmount;
  double get interestRate => _interestRate;
  double get tenureMonths => _tenureMonths;
  double get prepaymentAmount => _prepaymentAmount;
  int get prepaymentMonth => _prepaymentMonth;
  PrepaymentCalculation? get calculation => _calculation;

  PrepaymentViewModel() {
    _calculatePrepayment();
  }

  void setLoanAmount(double value) {
    _loanAmount = value;
    _calculatePrepayment();
    notifyListeners();
  }

  void setInterestRate(double value) {
    _interestRate = value;
    _calculatePrepayment();
    notifyListeners();
  }

  void setTenureMonths(double value) {
    _tenureMonths = value;
    _calculatePrepayment();
    notifyListeners();
  }

  void setPrepaymentAmount(double value) {
    _prepaymentAmount = value;
    _calculatePrepayment();
    notifyListeners();
  }

  void setPrepaymentMonth(int value) {
    _prepaymentMonth = value;
    _calculatePrepayment();
    notifyListeners();
  }

  void _calculatePrepayment() {
    _calculation = PrepaymentCalculator.calculatePrepayment(
      loanAmount: _loanAmount,
      interestRate: _interestRate,
      tenureMonths: _tenureMonths,
      prepaymentAmount: _prepaymentAmount,
      prepaymentMonth: _prepaymentMonth,
    );
    notifyListeners();
  }
}

