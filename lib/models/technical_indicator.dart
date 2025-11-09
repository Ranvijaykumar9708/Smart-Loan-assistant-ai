/// Technical indicator model
class TechnicalIndicator {
  final String symbol;
  final double rsi; // 0-100
  final double ma10; // 10-day moving average
  final double ma20; // 20-day moving average
  final double macd;
  final String signal; // 'Buy', 'Sell', 'Hold'

  TechnicalIndicator({
    required this.symbol,
    required this.rsi,
    required this.ma10,
    required this.ma20,
    required this.macd,
    required this.signal,
  });

  String get rsiStatus {
    if (rsi > 70) return 'Overbought';
    if (rsi < 30) return 'Oversold';
    return 'Neutral';
  }

  Map<String, dynamic> toJson() => {
        'symbol': symbol,
        'rsi': rsi,
        'ma10': ma10,
        'ma20': ma20,
        'macd': macd,
        'signal': signal,
      };

  factory TechnicalIndicator.fromJson(Map<String, dynamic> json) =>
      TechnicalIndicator(
        symbol: json['symbol'] as String,
        rsi: (json['rsi'] as num).toDouble(),
        ma10: (json['ma10'] as num).toDouble(),
        ma20: (json['ma20'] as num).toDouble(),
        macd: (json['macd'] as num).toDouble(),
        signal: json['signal'] as String,
      );
}

