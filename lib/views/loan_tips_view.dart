import 'dart:ui';
import 'package:flutter/material.dart';

/// Loan tips and advice view with glassmorphism design
class LoanTipsView extends StatelessWidget {
  const LoanTipsView({super.key});

  final List<Map<String, dynamic>> _tips = const [
    {
      'title': 'Check Your Credit Score',
      'description':
          'A good credit score (750+) can help you get better interest rates. Check your score regularly and work on improving it.',
      'icon': Icons.star,
      'color': 0xFFFFD700,
    },
    {
      'title': 'Compare Interest Rates',
      'description':
          'Don\'t settle for the first offer. Compare rates from multiple banks and NBFCs to find the best deal.',
      'icon': Icons.compare_arrows,
      'color': 0xFF667eea,
    },
    {
      'title': 'Read the Fine Print',
      'description':
          'Always read the loan agreement carefully. Pay attention to processing fees, prepayment charges, and other hidden costs.',
      'icon': Icons.description,
      'color': 0xFFf093fb,
    },
    {
      'title': 'Maintain a Good Debt-to-Income Ratio',
      'description':
          'Keep your total EMIs below 40-50% of your monthly income. This shows lenders you can manage debt responsibly.',
      'icon': Icons.trending_up,
      'color': 0xFF4ECDC4,
    },
    {
      'title': 'Consider Prepayment',
      'description':
          'If you have extra funds, consider prepaying your loan. This can save you significant interest over time.',
      'icon': Icons.savings,
      'color': 0xFFFFB84D,
    },
    {
      'title': 'Keep Documents Ready',
      'description':
          'Having all required documents ready can speed up the loan approval process significantly.',
      'icon': Icons.folder_open,
      'color': 0xFF00B4D8,
    },
    {
      'title': 'Negotiate Terms',
      'description':
          'Don\'t hesitate to negotiate interest rates, processing fees, or other terms with your lender.',
      'icon': Icons.handshake,
      'color': 0xFFFF6B6B,
    },
    {
      'title': 'Avoid Multiple Applications',
      'description':
          'Too many loan applications in a short time can hurt your credit score. Apply only when you\'re serious.',
      'icon': Icons.warning,
      'color': 0xFFFF6B6B,
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
          'Loan Tips & Advice',
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
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _tips.length,
        itemBuilder: (context, index) {
          final tip = _tips[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildTipCard(tip),
          );
        },
      ),
    );
  }

  Widget _buildTipCard(Map<String, dynamic> tip) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(tip['color'] as int).withOpacity(0.2),
                Color(tip['color'] as int).withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Color(tip['color'] as int).withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(tip['color'] as int).withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(tip['color'] as int).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  tip['icon'] as IconData,
                  color: Color(tip['color'] as int),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tip['title'] as String,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tip['description'] as String,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 14,
                        height: 1.5,
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
}

