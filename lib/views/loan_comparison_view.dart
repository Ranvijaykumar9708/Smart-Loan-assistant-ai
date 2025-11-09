import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/loan_calculator.dart';
import '../models/loan_calculation.dart';

/// Loan comparison view with glassmorphism design
class LoanComparisonView extends StatefulWidget {
  const LoanComparisonView({super.key});

  @override
  State<LoanComparisonView> createState() => _LoanComparisonViewState();
}

class _LoanComparisonViewState extends State<LoanComparisonView> {
  final List<Map<String, dynamic>> _loans = [
    {
      'name': 'Loan Option 1',
      'amount': 500000.0,
      'rate': 10.5,
      'tenure': 24.0,
    },
    {
      'name': 'Loan Option 2',
      'amount': 500000.0,
      'rate': 11.0,
      'tenure': 24.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Compare Loans',
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
            // Comparison Cards
            ...List.generate(_loans.length, (index) {
              final loan = _loans[index];
              final calculation = LoanCalculator.calculateEMI(
                loanAmount: loan['amount'],
                interestRate: loan['rate'],
                tenureMonths: loan['tenure'],
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildLoanCard(loan['name'], calculation, index),
              );
            }),

            const SizedBox(height: 24),

            // Comparison Table
            _buildComparisonTable(),

            const SizedBox(height: 24),

            // Add Loan Button
            _buildAddLoanButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanCard(String name, LoanCalculation calc, int index) {
    final colors = [
      [Color(0xFF667eea), Color(0xFF764ba2)],
      [Color(0xFFf093fb), Color(0xFF4facfe)],
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors[index % colors.length],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: colors[index % colors.length][0].withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem('EMI', '₹${calc.emi.toStringAsFixed(0)}'),
                  _buildStatItem('Total', '₹${calc.totalPayment.toStringAsFixed(0)}'),
                  _buildStatItem('Interest', '₹${calc.totalInterest.toStringAsFixed(0)}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
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

  Widget _buildComparisonTable() {
    final calculations = _loans.map((loan) {
      return LoanCalculator.calculateEMI(
        loanAmount: loan['amount'],
        interestRate: loan['rate'],
        tenureMonths: loan['tenure'],
      );
    }).toList();

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
                'Comparison',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Table(
                children: [
                  TableRow(
                    children: [
                      _buildTableCell('EMI', isHeader: true),
                      _buildTableCell('₹${calculations[0].emi.toStringAsFixed(0)}'),
                      _buildTableCell('₹${calculations[1].emi.toStringAsFixed(0)}'),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell('Total Interest', isHeader: true),
                      _buildTableCell('₹${calculations[0].totalInterest.toStringAsFixed(0)}'),
                      _buildTableCell('₹${calculations[1].totalInterest.toStringAsFixed(0)}'),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell('Total Payment', isHeader: true),
                      _buildTableCell('₹${calculations[0].totalPayment.toStringAsFixed(0)}'),
                      _buildTableCell('₹${calculations[1].totalPayment.toStringAsFixed(0)}'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          color: isHeader
              ? Colors.white.withOpacity(0.7)
              : Colors.white,
          fontSize: isHeader ? 12 : 14,
          fontWeight: isHeader ? FontWeight.w500 : FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildAddLoanButton() {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_outline,
                color: Colors.white.withOpacity(0.7),
              ),
              const SizedBox(width: 8),
              Text(
                'Add Another Loan',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

