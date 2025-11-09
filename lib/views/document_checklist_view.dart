import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/loan_type.dart';

/// Document checklist view with glassmorphism design
class DocumentChecklistView extends StatefulWidget {
  const DocumentChecklistView({super.key});

  @override
  State<DocumentChecklistView> createState() => _DocumentChecklistViewState();
}

class _DocumentChecklistViewState extends State<DocumentChecklistView> {
  String _selectedLoanType = LoanType.allTypes[0].name;
  final Map<String, List<Map<String, dynamic>>> _documents = {
    'Personal Loan': [
      {'name': 'Identity Proof (Aadhaar/Passport)', 'checked': false},
      {'name': 'Address Proof (Utility Bill/Rental Agreement)', 'checked': false},
      {'name': 'Income Proof (Salary Slips/ITR)', 'checked': false},
      {'name': 'Bank Statements (Last 6 months)', 'checked': false},
      {'name': 'Employment Certificate', 'checked': false},
      {'name': 'PAN Card', 'checked': false},
    ],
    'Home Loan': [
      {'name': 'Identity Proof (Aadhaar/Passport)', 'checked': false},
      {'name': 'Address Proof', 'checked': false},
      {'name': 'Income Proof (Salary Slips/ITR)', 'checked': false},
      {'name': 'Bank Statements (Last 6 months)', 'checked': false},
      {'name': 'Property Documents', 'checked': false},
      {'name': 'Sale Agreement', 'checked': false},
      {'name': 'NOC from Builder/Society', 'checked': false},
      {'name': 'Property Valuation Report', 'checked': false},
    ],
    'Car Loan': [
      {'name': 'Identity Proof', 'checked': false},
      {'name': 'Address Proof', 'checked': false},
      {'name': 'Income Proof', 'checked': false},
      {'name': 'Bank Statements', 'checked': false},
      {'name': 'Car Quotation/Invoice', 'checked': false},
      {'name': 'Driving License', 'checked': false},
    ],
    'Education Loan': [
      {'name': 'Identity Proof', 'checked': false},
      {'name': 'Address Proof', 'checked': false},
      {'name': 'Income Proof (Parent/Guardian)', 'checked': false},
      {'name': 'Admission Letter', 'checked': false},
      {'name': 'Fee Structure', 'checked': false},
      {'name': 'Academic Records', 'checked': false},
    ],
    'Business Loan': [
      {'name': 'Identity Proof', 'checked': false},
      {'name': 'Address Proof', 'checked': false},
      {'name': 'Business Registration Certificate', 'checked': false},
      {'name': 'ITR (Last 2-3 years)', 'checked': false},
      {'name': 'Bank Statements (Last 12 months)', 'checked': false},
      {'name': 'Business Plan', 'checked': false},
      {'name': 'GST Certificate', 'checked': false},
    ],
    'Gold Loan': [
      {'name': 'Identity Proof', 'checked': false},
      {'name': 'Address Proof', 'checked': false},
      {'name': 'Gold Valuation Certificate', 'checked': false},
      {'name': 'Gold Purity Certificate', 'checked': false},
    ],
  };

  List<Map<String, dynamic>> get _currentDocuments =>
      _documents[_selectedLoanType] ?? [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Document Checklist',
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
            // Loan Type Selector
            _buildLoanTypeSelector(),
            const SizedBox(height: 24),

            // Document List
            _buildDocumentList(),
            const SizedBox(height: 24),

            // Progress Card
            _buildProgressCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanTypeSelector() {
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
                'Select Loan Type',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              DropdownButton<String>(
                value: _selectedLoanType,
                isExpanded: true,
                dropdownColor: const Color(0xFF1A1A2E),
                style: const TextStyle(color: Colors.white),
                items: LoanType.allTypes.map((type) {
                  return DropdownMenuItem(
                    value: type.name,
                    child: Text(type.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLoanType = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentList() {
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
                'Required Documents',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...List.generate(_currentDocuments.length, (index) {
                final doc = _currentDocuments[index];
                return _buildDocumentItem(doc, index);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentItem(Map<String, dynamic> doc, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Checkbox(
            value: doc['checked'] as bool,
            onChanged: (value) {
              setState(() {
                doc['checked'] = value ?? false;
              });
            },
            activeColor: const Color(0xFF667eea),
          ),
          Expanded(
            child: Text(
              doc['name'] as String,
              style: TextStyle(
                color: doc['checked'] as bool
                    ? Colors.white.withOpacity(0.5)
                    : Colors.white.withOpacity(0.9),
                fontSize: 14,
                decoration: doc['checked'] as bool
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final checkedCount =
        _currentDocuments.where((doc) => doc['checked'] == true).length;
    final totalCount = _currentDocuments.length;
    final progress = totalCount > 0 ? checkedCount / totalCount : 0.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF4ECDC4).withOpacity(0.2),
                const Color(0xFF44A08D).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF4ECDC4).withOpacity(0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$checkedCount / $totalCount',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                '${(progress * 100).toStringAsFixed(0)}% Complete',
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
}

