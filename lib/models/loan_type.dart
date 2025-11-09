/// Loan type model
class LoanType {
  final String name;
  final String emoji;
  final int iconCode;
  final int colorValue;

  LoanType({
    required this.name,
    required this.emoji,
    required this.iconCode,
    required this.colorValue,
  });

  static final List<LoanType> allTypes = [
    LoanType(
      name: 'Personal Loan',
      emoji: '👤',
      iconCode: 0xe491, // Icons.person_outline
      colorValue: 0xFF6A5ACD,
    ),
    LoanType(
      name: 'Home Loan',
      emoji: '🏠',
      iconCode: 0xe88a, // Icons.home_outlined
      colorValue: 0xFF00B4D8,
    ),
    LoanType(
      name: 'Car Loan',
      emoji: '🚗',
      iconCode: 0xe52f, // Icons.directions_car_outlined
      colorValue: 0xFFFF6B6B,
    ),
    LoanType(
      name: 'Education Loan',
      emoji: '🎓',
      iconCode: 0xe80c, // Icons.school_outlined
      colorValue: 0xFFFFB84D,
    ),
    LoanType(
      name: 'Business Loan',
      emoji: '💼',
      iconCode: 0xe0af, // Icons.business_center_outlined
      colorValue: 0xFF4ECDC4,
    ),
    LoanType(
      name: 'Gold Loan',
      emoji: '💎',
      iconCode: 0xe1b9, // Icons.diamond_outlined
      colorValue: 0xFFFFD700,
    ),
  ];
}

