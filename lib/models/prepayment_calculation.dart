/// Prepayment calculation model
class PrepaymentCalculation {
  final double originalEMI;
  final double newEMI;
  final double totalSavings;
  final double interestSaved;
  final int monthsReduced;
  final double prepaymentAmount;

  PrepaymentCalculation({
    required this.originalEMI,
    required this.newEMI,
    required this.totalSavings,
    required this.interestSaved,
    required this.monthsReduced,
    required this.prepaymentAmount,
  });

  Map<String, dynamic> toJson() => {
        'originalEMI': originalEMI,
        'newEMI': newEMI,
        'totalSavings': totalSavings,
        'interestSaved': interestSaved,
        'monthsReduced': monthsReduced,
        'prepaymentAmount': prepaymentAmount,
      };

  factory PrepaymentCalculation.fromJson(Map<String, dynamic> json) =>
      PrepaymentCalculation(
        originalEMI: (json['originalEMI'] as num).toDouble(),
        newEMI: (json['newEMI'] as num).toDouble(),
        interestSaved: (json['interestSaved'] as num).toDouble(),
        totalSavings: (json['totalSavings'] as num).toDouble(),
        monthsReduced: json['monthsReduced'] as int,
        prepaymentAmount: (json['prepaymentAmount'] as num).toDouble(),
      );
}

