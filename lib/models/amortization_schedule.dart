/// Amortization schedule entry model
class AmortizationEntry {
  final int month;
  final double principal;
  final double interest;
  final double emi;
  final double remainingBalance;

  AmortizationEntry({
    required this.month,
    required this.principal,
    required this.interest,
    required this.emi,
    required this.remainingBalance,
  });

  Map<String, dynamic> toJson() => {
        'month': month,
        'principal': principal,
        'interest': interest,
        'emi': emi,
        'remainingBalance': remainingBalance,
      };

  factory AmortizationEntry.fromJson(Map<String, dynamic> json) =>
      AmortizationEntry(
        month: json['month'] as int,
        principal: (json['principal'] as num).toDouble(),
        interest: (json['interest'] as num).toDouble(),
        emi: (json['emi'] as num).toDouble(),
        remainingBalance: (json['remainingBalance'] as num).toDouble(),
      );
}

