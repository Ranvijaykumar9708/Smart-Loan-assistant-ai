import 'package:flutter/foundation.dart';
import '../models/loan_calculation.dart';
import '../utils/loan_calculator.dart';

/// View model for loan comparison
class LoanComparisonViewModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _loans = [
    {
      'name': 'Loan Option 1',
      'amount': 500000.0,
      'rate': 10.5,
      'tenure': 24.0,
    },
    {
      'name': 'Loan Option 2',
      'amount': 500000.0,
      'rate': 11.0,
      'tenure': 24.0,
    },
  ];

  List<Map<String, dynamic>> get loans => _loans;

  LoanCalculation getCalculation(int index) {
    final loan = _loans[index];
    return LoanCalculator.calculateEMI(
      loanAmount: loan['amount'] as double,
      interestRate: loan['rate'] as double,
      tenureMonths: loan['tenure'] as double,
    );
  }

  void addLoan() {
    final newLoanNumber = _loans.length + 1;
    _loans.add({
      'name': 'Loan Option $newLoanNumber',
      'amount': 500000.0,
      'rate': 10.5,
      'tenure': 24.0,
    });
    notifyListeners();
  }

  void updateLoan(int index, Map<String, dynamic> updatedLoan) {
    if (index >= 0 && index < _loans.length) {
      _loans[index] = updatedLoan;
      notifyListeners();
    }
  }

  void deleteLoan(int index) {
    if (_loans.length > 1 && index >= 0 && index < _loans.length) {
      _loans.removeAt(index);
      // Rename remaining loans
      for (int i = 0; i < _loans.length; i++) {
        _loans[i]['name'] = 'Loan Option ${i + 1}';
      }
      notifyListeners();
    }
  }

  void setLoanAmount(int index, double amount) {
    if (index >= 0 && index < _loans.length) {
      _loans[index]['amount'] = amount;
      notifyListeners();
    }
  }

  void setInterestRate(int index, double rate) {
    if (index >= 0 && index < _loans.length) {
      _loans[index]['rate'] = rate;
      notifyListeners();
    }
  }

  void setTenure(int index, double tenure) {
    if (index >= 0 && index < _loans.length) {
      _loans[index]['tenure'] = tenure;
      notifyListeners();
    }
  }
}

