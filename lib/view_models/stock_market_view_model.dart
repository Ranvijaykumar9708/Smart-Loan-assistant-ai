import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import '../models/stock.dart';
import '../models/portfolio_holding.dart';
import '../models/market_news.dart';
import '../models/technical_indicator.dart';
import '../utils/dummy_stock_data.dart';
import '../services/storage_service.dart';

/// View model for stock market features
class StockMarketViewModel extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  
  List<Stock> _stocks = [];
  List<PortfolioHolding> _holdings = [];
  List<MarketNews> _news = [];
  double _virtualBalance = 100000.0; // Starting balance
  Timer? _priceUpdateTimer;
  String _selectedCategory = 'All';

  List<Stock> get stocks => _stocks;
  List<PortfolioHolding> get holdings => _holdings;
  List<MarketNews> get news => _filteredNews;
  double get virtualBalance => _virtualBalance;
  double get totalPortfolioValue => _calculateTotalPortfolioValue();
  double get totalProfitLoss => _calculateTotalProfitLoss();
  String get selectedCategory => _selectedCategory;

  StockMarketViewModel() {
    _initializeStocks();
    _loadPortfolio();
    _loadNews();
    _startPriceUpdates();
  }

  void _initializeStocks() {
    _stocks = DummyStockData.getStocks();
    notifyListeners();
  }

  void _startPriceUpdates() {
    _priceUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateStockPrices();
    });
  }

  void _updateStockPrices() {
    _stocks = DummyStockData.getStocks();
    // Update holdings with new prices
    for (var holding in _holdings) {
      final stock = _stocks.firstWhere(
        (s) => s.symbol == holding.symbol,
        orElse: () => _stocks.first,
      );
      // Update holding with new price (create new instance)
      final index = _holdings.indexOf(holding);
      _holdings[index] = PortfolioHolding(
        symbol: holding.symbol,
        name: holding.name,
        quantity: holding.quantity,
        averagePrice: holding.averagePrice,
        currentPrice: stock.currentPrice,
        purchaseDate: holding.purchaseDate,
      );
    }
    notifyListeners();
  }

  List<Stock> get topGainers => DummyStockData.getTopGainers();
  List<Stock> get topLosers => DummyStockData.getTopLosers();
  Map<String, dynamic> get marketSummary => DummyStockData.getMarketSummary();

  List<MarketNews> get _filteredNews {
    if (_selectedCategory == 'All') return _news;
    return _news.where((n) => n.category == _selectedCategory).toList();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> _loadPortfolio() async {
    try {
      final portfolioJson = await _storageService.loadPortfolio();
      _holdings = portfolioJson;
      _virtualBalance = await _storageService.loadVirtualBalance();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading portfolio: $e');
    }
  }

  Future<void> _savePortfolio() async {
    try {
      await _storageService.savePortfolio(_holdings);
      await _storageService.saveVirtualBalance(_virtualBalance);
    } catch (e) {
      debugPrint('Error saving portfolio: $e');
    }
  }

  Future<void> buyStock(Stock stock, int quantity) async {
    final totalCost = stock.currentPrice * quantity;
    if (totalCost > _virtualBalance) {
      throw Exception('Insufficient balance');
    }

    final existingHolding = _holdings.firstWhere(
      (h) => h.symbol == stock.symbol,
      orElse: () => PortfolioHolding(
        symbol: stock.symbol,
        name: stock.name,
        quantity: 0,
        averagePrice: 0,
        currentPrice: stock.currentPrice,
        purchaseDate: DateTime.now(),
      ),
    );

    if (existingHolding.quantity > 0) {
      // Update existing holding
      final newQuantity = existingHolding.quantity + quantity;
      final newAvgPrice = ((existingHolding.averagePrice * existingHolding.quantity) +
              (stock.currentPrice * quantity)) /
          newQuantity;
      
      final index = _holdings.indexOf(existingHolding);
      _holdings[index] = PortfolioHolding(
        symbol: stock.symbol,
        name: stock.name,
        quantity: newQuantity,
        averagePrice: newAvgPrice,
        currentPrice: stock.currentPrice,
        purchaseDate: existingHolding.purchaseDate,
      );
    } else {
      // Add new holding
      _holdings.add(PortfolioHolding(
        symbol: stock.symbol,
        name: stock.name,
        quantity: quantity,
        averagePrice: stock.currentPrice,
        currentPrice: stock.currentPrice,
        purchaseDate: DateTime.now(),
      ));
    }

    _virtualBalance -= totalCost;
    await _savePortfolio();
    notifyListeners();
  }

  Future<void> sellStock(String symbol, int quantity) async {
    final holding = _holdings.firstWhere(
      (h) => h.symbol == symbol,
      orElse: () => throw Exception('Stock not in portfolio'),
    );

    if (quantity > holding.quantity) {
      throw Exception('Insufficient quantity');
    }

    final saleValue = holding.currentPrice * quantity;
    _virtualBalance += saleValue;

    if (quantity == holding.quantity) {
      _holdings.remove(holding);
    } else {
      final index = _holdings.indexOf(holding);
      _holdings[index] = PortfolioHolding(
        symbol: holding.symbol,
        name: holding.name,
        quantity: holding.quantity - quantity,
        averagePrice: holding.averagePrice,
        currentPrice: holding.currentPrice,
        purchaseDate: holding.purchaseDate,
      );
    }

    await _savePortfolio();
    notifyListeners();
  }

  double _calculateTotalPortfolioValue() {
    return _holdings.fold(0.0, (sum, holding) => sum + holding.totalValue);
  }

  double _calculateTotalProfitLoss() {
    return _holdings.fold(0.0, (sum, holding) => sum + holding.profitLoss);
  }

  Map<String, double> getSectorAllocation() {
    final allocation = <String, double>{};
    for (var holding in _holdings) {
      final stock = _stocks.firstWhere(
        (s) => s.symbol == holding.symbol,
        orElse: () => _stocks.first,
      );
      allocation[stock.sector] =
          (allocation[stock.sector] ?? 0) + holding.totalValue;
    }
    return allocation;
  }

  String getAIPortfolioInsight() {
    final allocation = getSectorAllocation();
    final totalValue = _calculateTotalPortfolioValue();
    if (totalValue == 0) return 'Start building your portfolio!';

    final maxSector = allocation.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    final percentage = (maxSector.value / totalValue * 100).round();

    if (percentage > 60) {
      return 'Your portfolio is $percentage% ${maxSector.key}-heavy. Consider diversifying.';
    }
    return 'Your portfolio is well-diversified across sectors.';
  }

  List<double> getPortfolioGrowthHistory() {
    // Simulate portfolio growth over last 30 days
    final baseValue = _calculateTotalPortfolioValue();
    if (baseValue == 0) return List.generate(30, (_) => 0.0);
    return List.generate(30, (i) {
      final dayChange = (_random.nextDouble() * 0.04 - 0.02); // ±2% daily
      return baseValue * (1 + dayChange * (30 - i) / 30);
    });
  }

  TechnicalIndicator getTechnicalIndicator(String symbol) {
    return DummyStockData.getTechnicalIndicator(symbol);
  }

  List<String> getAIInsights() {
    return DummyStockData.getAIInsights();
  }

  void _loadNews() {
    _news = DummyStockData.getMarketNews();
    notifyListeners();
  }

  @override
  void dispose() {
    _priceUpdateTimer?.cancel();
    super.dispose();
  }

  static final _random = math.Random();
}

