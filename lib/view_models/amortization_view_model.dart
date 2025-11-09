import 'package:flutter/foundation.dart';
import '../models/amortization_schedule.dart';
import '../models/loan_calculation.dart';
import '../utils/amortization_calculator.dart';
import '../utils/loan_calculator.dart';

/// View model for amortization schedule
class AmortizationViewModel extends ChangeNotifier {
  double _loanAmount = 500000;
  double _interestRate = 10.5;
  double _tenureMonths = 24;
  List<AmortizationEntry> _schedule = [];
  LoanCalculation? _calculation;

  double get loanAmount => _loanAmount;
  double get interestRate => _interestRate;
  double get tenureMonths => _tenureMonths;
  List<AmortizationEntry> get schedule => _schedule;
  LoanCalculation? get calculation => _calculation;

  AmortizationViewModel() {
    _calculateSchedule();
  }

  void setLoanAmount(double value) {
    _loanAmount = value;
    _calculateSchedule();
    notifyListeners();
  }

  void setInterestRate(double value) {
    _interestRate = value;
    _calculateSchedule();
    notifyListeners();
  }

  void setTenureMonths(double value) {
    _tenureMonths = value;
    _calculateSchedule();
    notifyListeners();
  }

  void _calculateSchedule() {
    _calculation = LoanCalculator.calculateEMI(
      loanAmount: _loanAmount,
      interestRate: _interestRate,
      tenureMonths: _tenureMonths,
    );

    if (_calculation != null) {
      _schedule = AmortizationCalculator.generateSchedule(
        loanAmount: _loanAmount,
        interestRate: _interestRate,
        tenureMonths: _tenureMonths,
        emi: _calculation!.emi,
      );
    }
    notifyListeners();
  }
}

