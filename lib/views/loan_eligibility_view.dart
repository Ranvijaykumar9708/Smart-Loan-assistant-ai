import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/loan_eligibility_view_model.dart';

/// Loan eligibility calculator view with glassmorphism design
class LoanEligibilityView extends StatelessWidget {
  const LoanEligibilityView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoanEligibilityViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0F1E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Loan Eligibility',
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
        body: Consumer<LoanEligibilityViewModel>(
          builder: (context, vm, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Eligibility Result Card
                  _buildResultCard(vm.eligibleAmount),
                  const SizedBox(height: 24),

                  // Input Cards
                  _buildInputCard(
                    'Monthly Income',
                    '₹${vm.monthlyIncome.toStringAsFixed(0)}',
                    vm.monthlyIncome,
                    10000,
                    1000000,
                    10000,
                    Icons.account_balance_wallet,
                    vm.setMonthlyIncome,
                  ),
                  const SizedBox(height: 16),

                  _buildInputCard(
                    'Existing EMI',
                    '₹${vm.existingEMI.toStringAsFixed(0)}',
                    vm.existingEMI,
                    0,
                    100000,
                    5000,
                    Icons.payment,
                    vm.setExistingEMI,
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
                    '${vm.tenureMonths.toInt()} months (${(vm.tenureMonths / 12).toStringAsFixed(1)} years)',
                    vm.tenureMonths,
                    6,
                    360,
                    6,
                    Icons.calendar_today,
                    vm.setTenureMonths,
                  ),
                  const SizedBox(height: 24),

                  // Info Card
                  _buildInfoCard(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultCard(double eligibleAmount) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFf093fb), Color(0xFF4facfe)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFf093fb).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Eligible Loan Amount',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '₹${eligibleAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Based on 50% of your income',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
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
                  activeTrackColor: const Color(0xFFf093fb),
                  inactiveTrackColor: Colors.white.withOpacity(0.1),
                  thumbColor: const Color(0xFFf093fb),
                  overlayColor: const Color(0xFFf093fb).withOpacity(0.2),
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

  Widget _buildInfoCard() {
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
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.white.withOpacity(0.7),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'How it works',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Banks typically allow 40-60% of your monthly income for EMI payments. This calculator uses 50% as a standard ratio. Your existing EMIs are deducted from this amount to calculate your eligibility.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

