/// Stock model for market data
class Stock {
  final String symbol;
  final String name;
  final double currentPrice;
  final double previousPrice;
  final double change;
  final double changePercent;
  final double marketCap;
  final List<double> priceHistory; // Last 20 prices for sparkline
  final String sector;

  Stock({
    required this.symbol,
    required this.name,
    required this.currentPrice,
    required this.previousPrice,
    required this.change,
    required this.changePercent,
    required this.marketCap,
    required this.priceHistory,
    required this.sector,
  });

  double get changePercentAbs => changePercent.abs();

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'name': name,
        'currentPrice': currentPrice,
        'previousPrice': previousPrice,
        'change': change,
        'changePercent': changePercent,
        'marketCap': marketCap,
        'priceHistory': priceHistory,
        'sector': sector,
      };

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        symbol: json['symbol'] as String,
        name: json['name'] as String,
        currentPrice: (json['currentPrice'] as num).toDouble(),
        previousPrice: (json['previousPrice'] as num).toDouble(),
        change: (json['change'] as num).toDouble(),
        changePercent: (json['changePercent'] as num).toDouble(),
        marketCap: (json['marketCap'] as num).toDouble(),
        priceHistory: (json['priceHistory'] as List)
            .map((e) => (e as num).toDouble())
            .toList(),
        sector: json['sector'] as String,
      );

  Stock copyWith({
    String? symbol,
    String? name,
    double? currentPrice,
    double? previousPrice,
    double? change,
    double? changePercent,
    double? marketCap,
    List<double>? priceHistory,
    String? sector,
  }) {
    return Stock(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      currentPrice: currentPrice ?? this.currentPrice,
      previousPrice: previousPrice ?? this.previousPrice,
      change: change ?? this.change,
      changePercent: changePercent ?? this.changePercent,
      marketCap: marketCap ?? this.marketCap,
      priceHistory: priceHistory ?? this.priceHistory,
      sector: sector ?? this.sector,
    );
  }
}

