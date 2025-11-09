/// Portfolio holding model
class PortfolioHolding {
  final String symbol;
  final String name;
  final int quantity;
  final double averagePrice;
  final double currentPrice;
  final DateTime purchaseDate;

  PortfolioHolding({
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.averagePrice,
    required this.currentPrice,
    required this.purchaseDate,
  });

  double get totalValue => quantity * currentPrice;
  double get totalInvestment => quantity * averagePrice;
  double get profitLoss => totalValue - totalInvestment;
  double get profitLossPercent =>
      averagePrice > 0 ? ((profitLoss / totalInvestment) * 100) : 0;

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'name': name,
        'quantity': quantity,
        'averagePrice': averagePrice,
        'currentPrice': currentPrice,
        'purchaseDate': purchaseDate.toIso8601String(),
      };

  factory PortfolioHolding.fromJson(Map<String, dynamic> json) =>
      PortfolioHolding(
        symbol: json['symbol'] as String,
        name: json['name'] as String,
        quantity: json['quantity'] as int,
        averagePrice: (json['averagePrice'] as num).toDouble(),
        currentPrice: (json['currentPrice'] as num).toDouble(),
        purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      );
}

