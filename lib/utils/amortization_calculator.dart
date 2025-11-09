import '../models/amortization_schedule.dart';

/// Utility class for amortization schedule calculations
class AmortizationCalculator {
  /// Generate amortization schedule
  static List<AmortizationEntry> generateSchedule({
    required double loanAmount,
    required double interestRate,
    required double tenureMonths,
    required double emi,
  }) {
    final List<AmortizationEntry> schedule = [];
    double remainingBalance = loanAmount;
    final double monthlyRate = interestRate / (12 * 100);

    for (int month = 1; month <= tenureMonths; month++) {
      final double interest = remainingBalance * monthlyRate;
      final double principal = emi - interest;
      remainingBalance = remainingBalance - principal;

      schedule.add(AmortizationEntry(
        month: month,
        principal: principal,
        interest: interest,
        emi: emi,
        remainingBalance: remainingBalance > 0 ? remainingBalance : 0,
      ));
    }

    return schedule;
  }
}

