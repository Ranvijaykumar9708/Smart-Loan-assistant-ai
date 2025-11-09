import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/stock_market_view_model.dart';
import '../models/stock.dart';
import '../models/technical_indicator.dart';
import '../navigation/app_router.dart';

/// Stock Detail view with technical indicators
class StockDetailView extends StatelessWidget {
  final Stock stock;

  const StockDetailView({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StockMarketViewModel(),
      child: Consumer<StockMarketViewModel>(
        builder: (context, vm, child) {
          final indicator = vm.getTechnicalIndicator(stock.symbol);
          final isPositive = stock.changePercent >= 0;

          return Scaffold(
          backgroundColor: const Color(0xFF0F0F1E),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              stock.symbol,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Stock Header
                _buildStockHeader(stock, isPositive),
                const SizedBox(height: 20),

                // Technical Indicators
                _buildSectionHeader('Technical Indicators', Icons.show_chart),
                const SizedBox(height: 12),
                _buildTechnicalIndicators(indicator),
                const SizedBox(height: 20),

                // Stock Info
                _buildSectionHeader('Stock Information', Icons.info_outline),
                const SizedBox(height: 12),
                _buildStockInfo(stock),
                const SizedBox(height: 20),

                // Action Buttons
                _buildActionButtons(context, vm, stock),
              ],
            ),
          ),
        );
        },
      ),
    );
  }

  Widget _buildStockHeader(Stock stock, bool isPositive) {
    final color = isPositive ? const Color(0xFF4ECDC4) : const Color(0xFFFF6B6B);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF667eea).withOpacity(0.3),
                Color(0xFF764ba2).withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stock.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '₹${stock.currentPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                            color: color,
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${isPositive ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%',
                              style: TextStyle(
                                color: color,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem('Market Cap', _formatMarketCap(stock.marketCap)),
                  _buildInfoItem('Sector', stock.sector),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatMarketCap(double marketCap) {
    if (marketCap >= 1000000000000) {
      return '₹${(marketCap / 1000000000000).toStringAsFixed(2)}T';
    } else if (marketCap >= 10000000000) {
      return '₹${(marketCap / 10000000000).toStringAsFixed(2)}K Cr';
    }
    return '₹${(marketCap / 1000000000).toStringAsFixed(2)}B';
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 14),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTechnicalIndicators(TechnicalIndicator indicator) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              _buildIndicatorRow('RSI', '${indicator.rsi.toStringAsFixed(1)}', indicator.rsiStatus),
              const Divider(color: Colors.white24, height: 24),
              _buildIndicatorRow('MA(10)', '₹${indicator.ma10.toStringAsFixed(2)}', ''),
              const Divider(color: Colors.white24, height: 24),
              _buildIndicatorRow('MA(20)', '₹${indicator.ma20.toStringAsFixed(2)}', ''),
              const Divider(color: Colors.white24, height: 24),
              _buildIndicatorRow('MACD', indicator.macd.toStringAsFixed(2), ''),
              const Divider(color: Colors.white24, height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF667eea).withOpacity(0.3),
                      Color(0xFF764ba2).withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      indicator.signal == 'Buy'
                          ? Icons.trending_up
                          : indicator.signal == 'Sell'
                              ? Icons.trending_down
                              : Icons.trending_flat,
                      color: indicator.signal == 'Buy'
                          ? Color(0xFF4ECDC4)
                          : indicator.signal == 'Sell'
                              ? Color(0xFFFF6B6B)
                              : Colors.white70,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Signal: ${indicator.signal}',
                      style: TextStyle(
                        color: indicator.signal == 'Buy'
                            ? Color(0xFF4ECDC4)
                            : indicator.signal == 'Sell'
                                ? Color(0xFFFF6B6B)
                                : Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicatorRow(String label, String value, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (status.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStockInfo(Stock stock) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Column(
            children: [
              _buildInfoRow('Symbol', stock.symbol),
              const Divider(color: Colors.white24, height: 20),
              _buildInfoRow('Previous Close', '₹${stock.previousPrice.toStringAsFixed(2)}'),
              const Divider(color: Colors.white24, height: 20),
              _buildInfoRow('Change', '₹${stock.change.toStringAsFixed(2)}'),
              const Divider(color: Colors.white24, height: 20),
              _buildInfoRow('Change %', '${stock.changePercent.toStringAsFixed(2)}%'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, StockMarketViewModel vm, Stock stock) {
    return Column(
      children: [
        _buildActionButton(
          context,
          'Buy Stock',
          Icons.shopping_cart,
          const Color(0xFF4ECDC4),
          () => _showBuyDialog(context, vm, stock),
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          context,
          'View Portfolio',
          Icons.account_balance_wallet,
          const Color(0xFF667eea),
          () {
            Navigator.pushNamed(context, AppRouter.virtualPortfolio);
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.3), color.withOpacity(0.2)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: color.withOpacity(0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBuyDialog(BuildContext context, StockMarketViewModel vm, Stock stock) {
    int quantity = 1;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          title: Text(
            'Buy ${stock.symbol}',
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Available Balance: ₹${vm.virtualBalance.toStringAsFixed(0)}',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white),
                    onPressed: quantity > 1
                        ? () => setState(() => quantity--)
                        : null,
                  ),
                  Text(
                    '$quantity',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: (stock.currentPrice * (quantity + 1)) <= vm.virtualBalance
                        ? () => setState(() => quantity++)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Total Cost: ₹${(stock.currentPrice * quantity).toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await vm.buyStock(stock, quantity);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Bought $quantity shares of ${stock.symbol}'),
                      backgroundColor: const Color(0xFF667eea),
                    ),
                  );
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                'Buy',
                style: TextStyle(color: Color(0xFF4ECDC4)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

