/// Loan calculation model
class LoanCalculation {
  final double loanAmount;
  final double interestRate;
  final double tenureMonths;
  final double emi;
  final double totalPayment;
  final double totalInterest;

  LoanCalculation({
    required this.loanAmount,
    required this.interestRate,
    required this.tenureMonths,
    required this.emi,
    required this.totalPayment,
    required this.totalInterest,
  });

  Map<String, dynamic> toJson() => {
        'loanAmount': loanAmount,
        'interestRate': interestRate,
        'tenureMonths': tenureMonths,
        'emi': emi,
        'totalPayment': totalPayment,
        'totalInterest': totalInterest,
      };

  factory LoanCalculation.fromJson(Map<String, dynamic> json) =>
      LoanCalculation(
        loanAmount: (json['loanAmount'] as num).toDouble(),
        interestRate: (json['interestRate'] as num).toDouble(),
        tenureMonths: (json['tenureMonths'] as num).toDouble(),
        emi: (json['emi'] as num).toDouble(),
        totalPayment: (json['totalPayment'] as num).toDouble(),
        totalInterest: (json['totalInterest'] as num).toDouble(),
      );
}

