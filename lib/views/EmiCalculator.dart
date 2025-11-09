// loan_calculator_view.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:ui';
import 'dart:math' as math;

class LoanCalculatorView extends StatefulWidget {
  const LoanCalculatorView({super.key});

  @override
  State<LoanCalculatorView> createState() => _LoanCalculatorViewState();
}

class _LoanCalculatorViewState extends State<LoanCalculatorView> {
  double _loanAmount = 500000;
  double _interestRate = 10.5;
  double _tenure = 24; // months
  double _emi = 0;
  double _totalPayment = 0;
  double _totalInterest = 0;

  @override
  void initState() {
    super.initState();
    _calculateEMI();
  }

  void _calculateEMI() {
    // EMI Formula: P × r × (1 + r)^n / ((1 + r)^n - 1)
    double principal = _loanAmount;
    double monthlyRate = _interestRate / (12 * 100);
    double months = _tenure;

    if (monthlyRate == 0) {
      _emi = principal / months;
    } else {
      _emi = principal *
          monthlyRate *
          math.pow(1 + monthlyRate, months) /
          (math.pow(1 + monthlyRate, months) - 1);
    }

    _totalPayment = _emi * months;
    _totalInterest = _totalPayment - principal;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Loan Calculator',
          style: TextStyle(
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
            // EMI Result Card
            _buildResultCard(),
            const SizedBox(height: 24),

            // Pie Chart
            _buildPieChart(),
            const SizedBox(height: 24),

            // Input Sliders
            _buildInputCard(
              'Loan Amount',
              '₹${_loanAmount.toStringAsFixed(0)}',
              _loanAmount,
              100000,
              10000000,
              50000,
              Icons.currency_rupee,
              (value) {
                setState(() {
                  _loanAmount = value;
                  _calculateEMI();
                });
              },
            ),
            const SizedBox(height: 16),

            _buildInputCard(
              'Interest Rate (Annual)',
              '${_interestRate.toStringAsFixed(1)}%',
              _interestRate,
              1,
              30,
              0.5,
              Icons.percent,
              (value) {
                setState(() {
                  _interestRate = value;
                  _calculateEMI();
                });
              },
            ),
            const SizedBox(height: 16),

            _buildInputCard(
              'Loan Tenure',
              '${_tenure.toInt()} months (${(_tenure / 12).toStringAsFixed(1)} years)',
              _tenure,
              6,
              360,
              6,
              Icons.calendar_today,
              (value) {
                setState(() {
                  _tenure = value;
                  _calculateEMI();
                });
              },
            ),
            const SizedBox(height: 24),

            // Breakdown Card
            _buildBreakdownCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667eea).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Monthly EMI',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '₹${_emi.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 280,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 60,
              sections: [
                PieChartSectionData(
                  value: _loanAmount,
                  title: 'Principal\n₹${(_loanAmount / 100000).toStringAsFixed(1)}L',
                  color: const Color(0xFF667eea),
                  radius: 70,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: _totalInterest,
                  title: 'Interest\n₹${(_totalInterest / 100000).toStringAsFixed(1)}L',
                  color: const Color(0xFFf093fb),
                  radius: 70,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(
    String label,
    String value,
    double currentValue,
    double min,
    double max,
    double divisions,
    IconData icon,
    Function(double) onChanged,
  ) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        label,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFF667eea),
                  inactiveTrackColor: Colors.white.withOpacity(0.1),
                  thumbColor: const Color(0xFF667eea),
                  overlayColor: const Color(0xFF667eea).withOpacity(0.2),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                  trackHeight: 6,
                ),
                child: Slider(
                  value: currentValue,
                  min: min,
                  max: max,
                  divisions: ((max - min) / divisions).round(),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownCard() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Breakdown',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildBreakdownRow(
                'Loan Amount',
                '₹${_loanAmount.toStringAsFixed(0)}',
                const Color(0xFF667eea),
              ),
              const SizedBox(height: 16),
              _buildBreakdownRow(
                'Total Interest',
                '₹${_totalInterest.toStringAsFixed(0)}',
                const Color(0xFFf093fb),
              ),
              const SizedBox(height: 16),
              _buildBreakdownRow(
                'Total Payment',
                '₹${_totalPayment.toStringAsFixed(0)}',
                const Color(0xFF4ECDC4),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white24),
              const SizedBox(height: 16),
              _buildBreakdownRow(
                'Monthly EMI',
                '₹${_emi.toStringAsFixed(0)}',
                Colors.white,
                isHighlight: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(
    String label,
    String value,
    Color color, {
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: isHighlight ? 16 : 14,
                fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: isHighlight ? 18 : 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// Add to pubspec.yaml:
/*
dependencies:
  fl_chart: ^0.66.0
*/

// Add navigation button in home_view.dart AppBar:
/*
IconButton(
  icon: const Icon(Icons.calculate, color: Colors.white),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoanCalculatorView(),
      ),
    );
  },
),
*/