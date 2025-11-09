import 'dart:math' as math;
import '../models/loan_calculation.dart';

/// Utility class for loan calculations
class LoanCalculator {
  /// Calculate EMI using the standard formula
  /// EMI = P × r × (1 + r)^n / ((1 + r)^n - 1)
  static LoanCalculation calculateEMI({
    required double loanAmount,
    required double interestRate,
    required double tenureMonths,
  }) {
    final double principal = loanAmount;
    final double monthlyRate = interestRate / (12 * 100);
    final double months = tenureMonths;

    double emi;
    if (monthlyRate == 0) {
      emi = principal / months;
    } else {
      final double power = math.pow(1 + monthlyRate, months).toDouble();
      emi = principal * monthlyRate * power / (power - 1);
    }

    final double totalPayment = emi * months;
    final double totalInterest = totalPayment - principal;

    return LoanCalculation(
      loanAmount: principal,
      interestRate: interestRate,
      tenureMonths: months,
      emi: emi,
      totalPayment: totalPayment,
      totalInterest: totalInterest,
    );
  }

  /// Calculate loan eligibility based on income
  static double calculateEligibility({
    required double monthlyIncome,
    required double existingEMI,
    required double interestRate,
    required double tenureMonths,
  }) {
    // Typically, banks allow 40-60% of income for EMI
    const double emiToIncomeRatio = 0.5; // 50%
    final double maxEMI = (monthlyIncome * emiToIncomeRatio) - existingEMI;

    if (maxEMI <= 0) return 0;

    // Reverse calculate loan amount from EMI
    final double monthlyRate = interestRate / (12 * 100);
    final double months = tenureMonths;

    if (monthlyRate == 0) {
      return maxEMI * months;
    }

    final double power = math.pow(1 + monthlyRate, months).toDouble();
    final double loanAmount = maxEMI * (power - 1) / (monthlyRate * power);

    return loanAmount;
  }
}

