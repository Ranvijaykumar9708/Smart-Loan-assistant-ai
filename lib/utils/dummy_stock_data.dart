import 'dart:math' as math;
import '../models/stock.dart';
import '../models/market_news.dart';
import '../models/technical_indicator.dart';

/// Utility class for generating dummy stock market data
class DummyStockData {
  static final math.Random _random = math.Random();

  static final List<Stock> _baseStocks = [
    Stock(
      symbol: 'TCS',
      name: 'Tata Consultancy Services',
      currentPrice: 3450.0,
      previousPrice: 3420.0,
      change: 30.0,
      changePercent: 0.88,
      marketCap: 12500000000000,
      priceHistory: List.generate(20, (i) => 3400 + (i * 2.5)),
      sector: 'IT',
    ),
    Stock(
      symbol: 'RELIANCE',
      name: 'Reliance Industries',
      currentPrice: 2450.0,
      previousPrice: 2430.0,
      change: 20.0,
      changePercent: 0.82,
      marketCap: 16500000000000,
      priceHistory: List.generate(20, (i) => 2420 + (i * 1.5)),
      sector: 'Energy',
    ),
    Stock(
      symbol: 'INFY',
      name: 'Infosys',
      currentPrice: 1520.0,
      previousPrice: 1540.0,
      change: -20.0,
      changePercent: -1.30,
      marketCap: 6300000000000,
      priceHistory: List.generate(20, (i) => 1550 - (i * 1.5)),
      sector: 'IT',
    ),
    Stock(
      symbol: 'HDFCBANK',
      name: 'HDFC Bank',
      currentPrice: 1680.0,
      previousPrice: 1675.0,
      change: 5.0,
      changePercent: 0.30,
      marketCap: 12500000000000,
      priceHistory: List.generate(20, (i) => 1670 + (i * 0.5)),
      sector: 'Banking',
    ),
    Stock(
      symbol: 'ICICIBANK',
      name: 'ICICI Bank',
      currentPrice: 980.0,
      previousPrice: 975.0,
      change: 5.0,
      changePercent: 0.51,
      marketCap: 6800000000000,
      priceHistory: List.generate(20, (i) => 970 + (i * 0.5)),
      sector: 'Banking',
    ),
    Stock(
      symbol: 'HINDUNILVR',
      name: 'Hindustan Unilever',
      currentPrice: 2650.0,
      previousPrice: 2640.0,
      change: 10.0,
      changePercent: 0.38,
      marketCap: 6200000000000,
      priceHistory: List.generate(20, (i) => 2630 + (i * 1.0)),
      sector: 'FMCG',
    ),
    Stock(
      symbol: 'ITC',
      name: 'ITC Limited',
      currentPrice: 425.0,
      previousPrice: 428.0,
      change: -3.0,
      changePercent: -0.70,
      marketCap: 5300000000000,
      priceHistory: List.generate(20, (i) => 430 - (i * 0.25)),
      sector: 'FMCG',
    ),
    Stock(
      symbol: 'SBIN',
      name: 'State Bank of India',
      currentPrice: 620.0,
      previousPrice: 615.0,
      change: 5.0,
      changePercent: 0.81,
      marketCap: 5500000000000,
      priceHistory: List.generate(20, (i) => 610 + (i * 0.5)),
      sector: 'Banking',
    ),
    Stock(
      symbol: 'BHARTIARTL',
      name: 'Bharti Airtel',
      currentPrice: 1120.0,
      previousPrice: 1115.0,
      change: 5.0,
      changePercent: 0.45,
      marketCap: 6200000000000,
      priceHistory: List.generate(20, (i) => 1110 + (i * 0.5)),
      sector: 'Telecom',
    ),
    Stock(
      symbol: 'LT',
      name: 'Larsen & Toubro',
      currentPrice: 3450.0,
      previousPrice: 3440.0,
      change: 10.0,
      changePercent: 0.29,
      marketCap: 4800000000000,
      priceHistory: List.generate(20, (i) => 3430 + (i * 1.0)),
      sector: 'Infrastructure',
    ),
  ];

  /// Get all stocks with random price fluctuations
  static List<Stock> getStocks() {
    return _baseStocks.map((stock) {
      // Random price fluctuation within ±2%
      final fluctuation = (_random.nextDouble() * 0.04 - 0.02);
      final newPrice = stock.currentPrice * (1 + fluctuation);
      final change = newPrice - stock.previousPrice;
      final changePercent = (change / stock.previousPrice) * 100;

      // Update price history
      final newHistory = List<double>.from(stock.priceHistory);
      newHistory.removeAt(0);
      newHistory.add(newPrice);

      return stock.copyWith(
        currentPrice: newPrice,
        change: change,
        changePercent: changePercent,
        priceHistory: newHistory,
      );
    }).toList();
  }

  /// Get top gainers
  static List<Stock> getTopGainers() {
    final stocks = getStocks();
    stocks.sort((a, b) => b.changePercent.compareTo(a.changePercent));
    return stocks.take(5).toList();
  }

  /// Get top losers
  static List<Stock> getTopLosers() {
    final stocks = getStocks();
    stocks.sort((a, b) => a.changePercent.compareTo(b.changePercent));
    return stocks.take(5).toList();
  }

  /// Get market summary
  static Map<String, dynamic> getMarketSummary() {
    final stocks = getStocks();
    final avgChange = stocks.map((s) => s.changePercent).reduce((a, b) => a + b) /
        stocks.length;
    
    return {
      'nifty50': avgChange > 0 ? '↑ ${avgChange.toStringAsFixed(2)}%' : '↓ ${avgChange.abs().toStringAsFixed(2)}%',
      'sensex': avgChange > 0 ? '↑ ${(avgChange * 1.1).toStringAsFixed(2)}%' : '↓ ${(avgChange * 1.1).abs().toStringAsFixed(2)}%',
      'mood': avgChange > 0.5 ? 'Bullish 🐂' : avgChange < -0.5 ? 'Bearish 🐻' : 'Neutral ⚪',
    };
  }

  /// Get market news
  static List<MarketNews> getMarketNews() {
    final newsTemplates = [
      {
        'title': 'TCS Reports Strong Q4 Earnings, Beats Estimates',
        'category': 'Market',
        'sentiment': 'Positive',
        'aiComment': 'This positive news may drive short-term price appreciation.',
      },
      {
        'title': 'RBI Keeps Repo Rate Unchanged at 6.5%',
        'category': 'Economy',
        'sentiment': 'Neutral',
        'aiComment': 'Stable interest rates support banking sector stability.',
      },
      {
        'title': 'Global Tech Stocks Face Correction',
        'category': 'Global',
        'sentiment': 'Negative',
        'aiComment': 'IT sector may see short-term volatility.',
      },
      {
        'title': 'Infosys Announces Major AI Partnership',
        'category': 'Tech',
        'sentiment': 'Positive',
        'aiComment': 'Strategic partnerships could boost long-term growth.',
      },
      {
        'title': 'Oil Prices Surge Amid Supply Concerns',
        'category': 'Economy',
        'sentiment': 'Negative',
        'aiComment': 'Energy sector stocks may see increased volatility.',
      },
      {
        'title': 'HDFC Bank Expands Digital Services',
        'category': 'Market',
        'sentiment': 'Positive',
        'aiComment': 'Digital expansion supports future revenue growth.',
      },
      {
        'title': 'FMCG Sector Shows Resilience in Q4',
        'category': 'Market',
        'sentiment': 'Positive',
        'aiComment': 'Consumer goods stocks remain stable investment.',
      },
      {
        'title': 'Infrastructure Spending Increases',
        'category': 'Economy',
        'sentiment': 'Positive',
        'aiComment': 'Infrastructure stocks may benefit from government spending.',
      },
    ];

    return newsTemplates.map((template) {
      return MarketNews(
        id: DateTime.now().millisecondsSinceEpoch.toString() +
            _random.nextInt(1000).toString(),
        title: template['title'] as String,
        category: template['category'] as String,
        sentiment: template['sentiment'] as String,
        timestamp: DateTime.now().subtract(Duration(
          hours: _random.nextInt(24),
          minutes: _random.nextInt(60),
        )),
        aiComment: template['aiComment'] as String?,
      );
    }).toList();
  }

  /// Get technical indicators for a stock
  static TechnicalIndicator getTechnicalIndicator(String symbol) {
    final rsi = 30 + (_random.nextDouble() * 40); // 30-70 range
    final basePrice = _baseStocks.firstWhere((s) => s.symbol == symbol).currentPrice;
    final ma10 = basePrice * (0.98 + _random.nextDouble() * 0.04);
    final ma20 = basePrice * (0.97 + _random.nextDouble() * 0.06);
    final macd = (ma10 - ma20) * 0.1;

    String signal;
    if (rsi < 35 && ma10 > ma20) {
      signal = 'Buy';
    } else if (rsi > 65 && ma10 < ma20) {
      signal = 'Sell';
    } else {
      signal = 'Hold';
    }

    return TechnicalIndicator(
      symbol: symbol,
      rsi: rsi,
      ma10: ma10,
      ma20: ma20,
      macd: macd,
      signal: signal,
    );
  }

  /// Get AI insights
  static List<String> getAIInsights() {
    final insights = [
      '${_baseStocks[_random.nextInt(_baseStocks.length)].name} shows short-term bullish signs.',
      '${_baseStocks[_random.nextInt(_baseStocks.length)].name} may face correction after recent surge.',
      'IT sector shows strong momentum. Consider adding tech stocks.',
      'Banking stocks are undervalued. Good entry point for long-term investors.',
      'Market volatility expected. Diversify your portfolio.',
      '${_baseStocks[_random.nextInt(_baseStocks.length)].name} RSI indicates potential reversal.',
    ];
    return insights;
  }
}

