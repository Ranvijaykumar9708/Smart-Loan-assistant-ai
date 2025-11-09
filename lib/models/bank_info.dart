/// Bank/NBFC information model
class BankInfo {
  final String name;
  final String type; // 'Bank' or 'NBFC'
  final double minInterestRate;
  final double maxInterestRate;
  final double processingFee;
  final int minTenure;
  final int maxTenure;
  final double minLoanAmount;
  final double maxLoanAmount;
  final String logoUrl;
  final List<String> loanTypes;

  BankInfo({
    required this.name,
    required this.type,
    required this.minInterestRate,
    required this.maxInterestRate,
    required this.processingFee,
    required this.minTenure,
    required this.maxTenure,
    required this.minLoanAmount,
    required this.maxLoanAmount,
    required this.logoUrl,
    required this.loanTypes,
  });

  static final List<BankInfo> allBanks = [
    BankInfo(
      name: 'HDFC Bank',
      type: 'Bank',
      minInterestRate: 10.5,
      maxInterestRate: 18.0,
      processingFee: 0.5,
      minTenure: 12,
      maxTenure: 60,
      minLoanAmount: 50000,
      maxLoanAmount: 40000000,
      logoUrl: '',
      loanTypes: ['Personal Loan', 'Home Loan', 'Car Loan', 'Business Loan'],
    ),
    BankInfo(
      name: 'ICICI Bank',
      type: 'Bank',
      minInterestRate: 10.75,
      maxInterestRate: 18.5,
      processingFee: 0.5,
      minTenure: 12,
      maxTenure: 60,
      minLoanAmount: 50000,
      maxLoanAmount: 50000000,
      logoUrl: '',
      loanTypes: ['Personal Loan', 'Home Loan', 'Car Loan', 'Education Loan'],
    ),
    BankInfo(
      name: 'SBI Bank',
      type: 'Bank',
      minInterestRate: 10.25,
      maxInterestRate: 17.5,
      processingFee: 0.3,
      minTenure: 12,
      maxTenure: 60,
      minLoanAmount: 50000,
      maxLoanAmount: 20000000,
      logoUrl: '',
      loanTypes: ['Personal Loan', 'Home Loan', 'Car Loan', 'Education Loan'],
    ),
    BankInfo(
      name: 'Axis Bank',
      type: 'Bank',
      minInterestRate: 10.5,
      maxInterestRate: 18.0,
      processingFee: 0.5,
      minTenure: 12,
      maxTenure: 60,
      minLoanAmount: 50000,
      maxLoanAmount: 40000000,
      logoUrl: '',
      loanTypes: ['Personal Loan', 'Home Loan', 'Car Loan', 'Business Loan'],
    ),
    BankInfo(
      name: 'Bajaj Finserv',
      type: 'NBFC',
      minInterestRate: 11.0,
      maxInterestRate: 19.0,
      processingFee: 0.5,
      minTenure: 12,
      maxTenure: 60,
      minLoanAmount: 50000,
      maxLoanAmount: 25000000,
      logoUrl: '',
      loanTypes: ['Personal Loan', 'Home Loan', 'Car Loan', 'Business Loan'],
    ),
    BankInfo(
      name: 'Kotak Mahindra Bank',
      type: 'Bank',
      minInterestRate: 10.5,
      maxInterestRate: 18.0,
      processingFee: 0.5,
      minTenure: 12,
      maxTenure: 60,
      minLoanAmount: 50000,
      maxLoanAmount: 30000000,
      logoUrl: '',
      loanTypes: ['Personal Loan', 'Home Loan', 'Car Loan', 'Business Loan'],
    ),
  ];
}

