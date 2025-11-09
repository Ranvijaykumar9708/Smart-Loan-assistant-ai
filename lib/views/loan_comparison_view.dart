import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/loan_comparison_view_model.dart';
import '../models/loan_calculation.dart';

/// Loan comparison view with glassmorphism design
class LoanComparisonView extends StatelessWidget {
  const LoanComparisonView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoanComparisonViewModel(),
      child: Scaffold(
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
        body: Consumer<LoanComparisonViewModel>(
          builder: (context, vm, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Comparison Cards
                  ...List.generate(vm.loans.length, (index) {
                    final calculation = vm.getCalculation(index);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildLoanCard(
                        context,
                        vm,
                        vm.loans[index]['name'] as String,
                        calculation,
                        index,
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Comparison Table
                  if (vm.loans.length >= 2) _buildComparisonTable(vm),

                  const SizedBox(height: 24),

                  // Add Loan Button
                  _buildAddLoanButton(context, vm),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoanCard(
    BuildContext context,
    LoanComparisonViewModel vm,
    String name,
    LoanCalculation calc,
    int index,
  ) {
    final colors = [
      [Color(0xFF667eea), Color(0xFF764ba2)],
      [Color(0xFFf093fb), Color(0xFF4facfe)],
      [Color(0xFF4ECDC4), Color(0xFF44A08D)],
      [Color(0xFFFFB84D), Color(0xFFFF6B6B)],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (vm.loans.length > 1)
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => vm.deleteLoan(index),
                      iconSize: 20,
                    ),
                ],
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
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _showEditLoanDialog(context, vm, index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
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

  Widget _buildComparisonTable(LoanComparisonViewModel vm) {
    final calculations = vm.loans.map((loan) {
      return vm.getCalculation(vm.loans.indexOf(loan));
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
                      _buildTableCell('', isHeader: true),
                      ...List.generate(vm.loans.length, (index) {
                        return _buildTableCell(
                          vm.loans[index]['name'] as String,
                          isHeader: true,
                        );
                      }),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell('EMI', isHeader: true),
                      ...List.generate(calculations.length, (index) {
                        return _buildTableCell(
                          '₹${calculations[index].emi.toStringAsFixed(0)}',
                        );
                      }),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell('Total Interest', isHeader: true),
                      ...List.generate(calculations.length, (index) {
                        return _buildTableCell(
                          '₹${calculations[index].totalInterest.toStringAsFixed(0)}',
                        );
                      }),
                    ],
                  ),
                  TableRow(
                    children: [
                      _buildTableCell('Total Payment', isHeader: true),
                      ...List.generate(calculations.length, (index) {
                        return _buildTableCell(
                          '₹${calculations[index].totalPayment.toStringAsFixed(0)}',
                        );
                      }),
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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

  Widget _buildAddLoanButton(BuildContext context, LoanComparisonViewModel vm) {
    return GestureDetector(
      onTap: () => vm.addLoan(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF667eea).withOpacity(0.3),
                  Color(0xFF764ba2).withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(0xFF667eea).withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF667eea).withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: Colors.white.withOpacity(0.9),
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Add Another Loan',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditLoanDialog(
    BuildContext context,
    LoanComparisonViewModel vm,
    int index,
  ) {
    final loan = vm.loans[index];
    double amount = loan['amount'] as double;
    double rate = loan['rate'] as double;
    double tenure = loan['tenure'] as double;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          title: Text(
            'Edit ${loan['name']}',
            style: const TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildEditSlider(
                  'Loan Amount',
                  '₹${amount.toStringAsFixed(0)}',
                  amount,
                  100000,
                  10000000,
                  50000,
                  (value) {
                    setState(() => amount = value);
                  },
                ),
                const SizedBox(height: 16),
                _buildEditSlider(
                  'Interest Rate',
                  '${rate.toStringAsFixed(1)}%',
                  rate,
                  1,
                  30,
                  0.5,
                  (value) {
                    setState(() => rate = value);
                  },
                ),
                const SizedBox(height: 16),
                _buildEditSlider(
                  'Tenure',
                  '${tenure.toInt()} months',
                  tenure,
                  6,
                  360,
                  6,
                  (value) {
                    setState(() => tenure = value);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                vm.setLoanAmount(index, amount);
                vm.setInterestRate(index, rate);
                vm.setTenure(index, tenure);
                Navigator.pop(context);
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Color(0xFF667eea)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditSlider(
    String label,
    String value,
    double currentValue,
    double min,
    double max,
    double divisions,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFF667eea),
            inactiveTrackColor: Colors.white.withOpacity(0.1),
            thumbColor: const Color(0xFF667eea),
            overlayColor: const Color(0xFF667eea).withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            trackHeight: 4,
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
    );
  }
}
