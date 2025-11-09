import '../models/prepayment_calculation.dart';
import 'loan_calculator.dart';

/// Utility class for prepayment calculations
class PrepaymentCalculator {
  /// Calculate prepayment benefits
  static PrepaymentCalculation calculatePrepayment({
    required double loanAmount,
    required double interestRate,
    required double tenureMonths,
    required double prepaymentAmount,
    required int prepaymentMonth,
  }) {
    // Original calculation
    final originalCalc = LoanCalculator.calculateEMI(
      loanAmount: loanAmount,
      interestRate: interestRate,
      tenureMonths: tenureMonths,
    );

    // Calculate remaining balance at prepayment month
    final monthlyRate = interestRate / (12 * 100);
    double remainingBalance = loanAmount;

    for (int month = 1; month <= prepaymentMonth; month++) {
      final interest = remainingBalance * monthlyRate;
      final principal = originalCalc.emi - interest;
      remainingBalance = remainingBalance - principal;
    }

    // Apply prepayment
    final newLoanAmount = remainingBalance - prepaymentAmount;
    final newTenureMonths = tenureMonths - prepaymentMonth;

    // New calculation
    final newCalc = LoanCalculator.calculateEMI(
      loanAmount: newLoanAmount,
      interestRate: interestRate,
      tenureMonths: newTenureMonths,
    );

    // Calculate savings
    final originalTotalInterest = originalCalc.totalInterest;
    final newTotalInterest = newCalc.totalInterest * (newTenureMonths / tenureMonths);
    final interestSaved = originalTotalInterest - newTotalInterest;
    final totalSavings = interestSaved;
    final monthsReduced = (tenureMonths - newTenureMonths).toInt();

    return PrepaymentCalculation(
      originalEMI: originalCalc.emi,
      newEMI: newCalc.emi,
      totalSavings: totalSavings,
      interestSaved: interestSaved,
      monthsReduced: monthsReduced,
      prepaymentAmount: prepaymentAmount,
    );
  }
}

