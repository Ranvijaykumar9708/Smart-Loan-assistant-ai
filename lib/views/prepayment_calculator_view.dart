import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/prepayment_view_model.dart';

/// Prepayment calculator view with glassmorphism design
class PrepaymentCalculatorView extends StatelessWidget {
  const PrepaymentCalculatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrepaymentViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F1E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Prepayment Calculator',
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
        body: Consumer<PrepaymentViewModel>(
          builder: (context, vm, child) {
            final calc = vm.calculation;
            if (calc == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Savings Card
                  _buildSavingsCard(calc),
                  const SizedBox(height: 24),

                  // Input Cards
                  _buildInputCard(
                    'Loan Amount',
                    '₹${vm.loanAmount.toStringAsFixed(0)}',
                    vm.loanAmount,
                    100000,
                    10000000,
                    50000,
                    Icons.currency_rupee,
                    vm.setLoanAmount,
                  ),
                  const SizedBox(height: 16),

                  _buildInputCard(
                    'Interest Rate (Annual)',
                    '${vm.interestRate.toStringAsFixed(1)}%',
                    vm.interestRate,
                    1,
                    30,
                    0.5,
                    Icons.percent,
                    vm.setInterestRate,
                  ),
                  const SizedBox(height: 16),

                  _buildInputCard(
                    'Loan Tenure',
                    '${vm.tenureMonths.toInt()} months',
                    vm.tenureMonths,
                    6,
                    360,
                    6,
                    Icons.calendar_today,
                    vm.setTenureMonths,
                  ),
                  const SizedBox(height: 16),

                  _buildInputCard(
                    'Prepayment Amount',
                    '₹${vm.prepaymentAmount.toStringAsFixed(0)}',
                    vm.prepaymentAmount,
                    10000,
                    5000000,
                    10000,
                    Icons.payment,
                    vm.setPrepaymentAmount,
                  ),
                  const SizedBox(height: 16),

                  _buildInputCard(
                    'Prepayment Month',
                    'Month ${vm.prepaymentMonth}',
                    vm.prepaymentMonth.toDouble(),
                    1,
                    vm.tenureMonths,
                    1,
                    Icons.schedule,
                    (value) => vm.setPrepaymentMonth(value.toInt()),
                  ),
                  const SizedBox(height: 24),

                  // Comparison Card
                  _buildComparisonCard(vm, calc),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSavingsCard(calc) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4ECDC4).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Total Savings',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '₹${calc.totalSavings.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSavingsItem('Interest Saved', '₹${calc.interestSaved.toStringAsFixed(0)}'),
                  _buildSavingsItem('Months Reduced', '${calc.monthsReduced}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavingsItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 12,
          ),
        ),
      ],
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
                  activeTrackColor: const Color(0xFF4ECDC4),
                  inactiveTrackColor: Colors.white.withOpacity(0.1),
                  thumbColor: const Color(0xFF4ECDC4),
                  overlayColor: const Color(0xFF4ECDC4).withOpacity(0.2),
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

  Widget _buildComparisonCard(PrepaymentViewModel vm, calc) {
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
                'Before vs After Prepayment',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildComparisonRow('EMI', '₹${calc.originalEMI.toStringAsFixed(0)}', '₹${calc.newEMI.toStringAsFixed(0)}'),
              const SizedBox(height: 16),
              _buildComparisonRow('Interest Saved', '-', '₹${calc.interestSaved.toStringAsFixed(0)}'),
              const SizedBox(height: 16),
              _buildComparisonRow('Tenure', '${vm.tenureMonths.toInt()} months', '${(vm.tenureMonths - calc.monthsReduced).toInt()} months'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String label, String before, String after) {
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
              before,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              after,
              style: const TextStyle(
                color: Color(0xFF4ECDC4),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

