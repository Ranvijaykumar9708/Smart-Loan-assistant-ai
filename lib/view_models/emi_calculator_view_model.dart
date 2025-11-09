import 'package:flutter/foundation.dart';
import '../models/loan_calculation.dart';
import '../services/storage_service.dart';
import '../utils/loan_calculator.dart';

/// View model for EMI calculator
class EmiCalculatorViewModel extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  double _loanAmount = 500000;
  double _interestRate = 10.5;
  double _tenureMonths = 24;
  LoanCalculation? _currentCalculation;
  List<LoanCalculation> _savedCalculations = [];

  double get loanAmount => _loanAmount;
  double get interestRate => _interestRate;
  double get tenureMonths => _tenureMonths;
  LoanCalculation? get currentCalculation => _currentCalculation;
  List<LoanCalculation> get savedCalculations => _savedCalculations;

  EmiCalculatorViewModel() {
    _calculateEMI();
    _loadSavedCalculations();
  }

  /// Set loan amount
  void setLoanAmount(double value) {
    _loanAmount = value;
    _calculateEMI();
    notifyListeners();
  }

  /// Set interest rate
  void setInterestRate(double value) {
    _interestRate = value;
    _calculateEMI();
    notifyListeners();
  }

  /// Set tenure in months
  void setTenureMonths(double value) {
    _tenureMonths = value;
    _calculateEMI();
    notifyListeners();
  }

  /// Calculate EMI
  void _calculateEMI() {
    _currentCalculation = LoanCalculator.calculateEMI(
      loanAmount: _loanAmount,
      interestRate: _interestRate,
      tenureMonths: _tenureMonths,
    );
    notifyListeners();
  }

  /// Save current calculation
  Future<void> saveCalculation() async {
    if (_currentCalculation == null) return;

    _savedCalculations.insert(0, _currentCalculation!);
    await _storageService.saveLoanCalculations(_savedCalculations);
    notifyListeners();
  }

  /// Load saved calculations
  Future<void> _loadSavedCalculations() async {
    try {
      _savedCalculations = await _storageService.loadLoanCalculations();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading saved calculations: $e');
    }
  }

  /// Delete saved calculation
  Future<void> deleteCalculation(int index) async {
    if (index >= 0 && index < _savedCalculations.length) {
      _savedCalculations.removeAt(index);
      await _storageService.saveLoanCalculations(_savedCalculations);
      notifyListeners();
    }
  }
}

