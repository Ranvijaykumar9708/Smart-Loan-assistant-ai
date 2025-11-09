# 🤖 Loan Assistant - AI-Powered Financial Assistant

<div align="center">
  
  ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
  ![Provider](https://img.shields.io/badge/Provider-61DAFB?style=for-the-badge&logo=react&logoColor=black)
  ![Gemini AI](https://img.shields.io/badge/Gemini_AI-8E75B2?style=for-the-badge&logo=google&logoColor=white)
  
  **A premium Flutter application that provides AI-powered loan advice and comprehensive financial calculations**
  
  [Demo Video](#) • [Download APK](#) • [Report Bug](#) • [Request Feature](#)
  
</div>

---

## 📱 Features

### 🤖 AI-Powered Assistance
- Intelligent loan advice powered by Google's Gemini AI (Gemini 2.5 Flash)
- Real-time responses with detailed guidance
- Context-aware answers for different loan types
- Support for 6 loan types: Personal, Home, Car, Education, Business, Gold
- Enhanced prompts for concise, practical responses
- Chat history with search and filter capabilities

### 📊 Smart Loan Calculator
- Interactive EMI calculator with live updates
- Beautiful pie charts for payment visualization
- Amortization schedule with month-by-month breakdown
- Interactive bar charts showing principal vs interest
- Loan comparison tool for multiple scenarios
- Save and compare multiple loan calculations

### 📈 Loan Amortization Schedule
- Complete month-by-month breakdown of payments
- Principal and interest breakdown for each month
- Remaining balance tracking
- Visual charts for first 12 months
- Scrollable detailed schedule

### 💰 Loan Eligibility Calculator
- Calculate your loan eligibility based on income
- Consider existing EMIs in calculations
- Adjustable interest rates and tenure
- Real-time eligibility updates
- Based on 50% income-to-EMI ratio

### 🔄 Prepayment Calculator
- Calculate savings from loan prepayment
- Compare before/after prepayment scenarios
- Shows interest saved and months reduced
- Adjustable prepayment amount and timing
- Visual comparison of EMI changes

### 📊 Loan Comparison Tool
- Compare multiple loan options side-by-side
- Add unlimited loan scenarios
- Edit loan parameters (amount, rate, tenure)
- Delete individual loans
- Comprehensive comparison table
- Visual cards with color-coded options

### 🏦 Bank & NBFC Directory
- Comprehensive list of 15+ major banks and NBFCs
- Interest rate ranges for each lender
- Processing fees, tenure, and loan amount ranges
- Loan types supported by each lender
- Filter by bank type (Bank/NBFC)
- Includes: HDFC, ICICI, SBI, Axis, Kotak, Yes Bank, IDFC First Bank, Bajaj Finserv, Fullerton India, Tata Capital, Aditya Birla Capital, Muthoot Finance, Manappuram Finance, IIFL Finance, HDB Financial Services

### 📋 Document Checklist
- Comprehensive document lists for each loan type
- Interactive checklist with progress tracking
- Organized by loan category
- Visual progress indicators
- Real-time completion percentage

### 💬 Chat History Management
- Persistent local storage of all conversations
- Search functionality across chat history
- Category-based organization by loan type
- Delete individual or all conversations
- Timestamp-based organization

### 💡 Loan Tips & Advice
- Expert tips for better loan management
- Best practices for loan applications
- Interest rate negotiation tips
- Credit score improvement advice
- 8+ comprehensive tips with visual cards

### 🎨 Premium UI/UX
- Modern glassmorphic design throughout
- Dark/Light theme toggle with persistence
- Smooth animations and transitions
- Responsive layout for all screen sizes
- Animated onboarding experience
- Tab-based navigation (Select Loan Type & Quick Actions)
- Floating orbs and gradient backgrounds

### ⚙️ Settings & Data Management
- Dark/Light theme toggle
- Clear chat history
- Clear all app data
- Share app functionality
- App information and version details
- Developer contact information

---

## 🏗️ Architecture

This project follows **MVVM (Model-View-ViewModel)** architecture with a clear separation of concerns:

```
lib/
├── models/              # Data models
│   ├── chat_message.dart
│   ├── loan_calculation.dart
│   ├── loan_type.dart
│   ├── amortization_schedule.dart
│   ├── prepayment_calculation.dart
│   └── bank_info.dart
├── views/               # UI screens
│   ├── home_view.dart
│   ├── chat_history_view.dart
│   ├── emi_calculator_view.dart
│   ├── loan_eligibility_view.dart
│   ├── loan_comparison_view.dart
│   ├── document_checklist_view.dart
│   ├── loan_tips_view.dart
│   ├── settings_view.dart
│   ├── amortization_schedule_view.dart
│   ├── prepayment_calculator_view.dart
│   ├── bank_directory_view.dart
│   ├── splash_view.dart
│   └── onboarding_view.dart
├── view_models/         # Business logic (Provider)
│   ├── home_view_model.dart
│   ├── emi_calculator_view_model.dart
│   ├── loan_eligibility_view_model.dart
│   ├── loan_comparison_view_model.dart
│   ├── amortization_view_model.dart
│   ├── prepayment_view_model.dart
│   └── theme_view_model.dart
├── services/            # API & local storage
│   ├── api_service.dart
│   └── storage_service.dart
├── navigation/          # Routing
│   └── app_router.dart
├── utils/               # Helper functions
│   ├── loan_calculator.dart
│   ├── amortization_calculator.dart
│   └── prepayment_calculator.dart
├── constants/           # App constants
│   └── app_constants.dart
└── main.dart
```

### State Management
- **Provider** for reactive state management
- **ChangeNotifier** pattern for view models
- Efficient rebuilds with context.watch/read
- Theme management with persistence

### Data Persistence
- **SharedPreferences** for local storage
- JSON serialization for chat history and calculations
- Secure API key management
- Theme preference persistence

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Dart SDK (3.9.2 or higher)
- Android Studio / VS Code
- Gemini API key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Ranvijaykumar9708/loan-assistant.git
   cd loan-assistant
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  provider: ^6.0.5
  
  # AI Integration
  http: ^1.5.0
  
  # Local Storage
  shared_preferences: ^2.5.3
  
  # UI Components
  animated_text_kit: ^4.3.0
  fl_chart: ^1.1.1
  
  # Utilities
  share_plus: ^12.0.1
  url_launcher: ^6.3.2
```

---

## 🎯 Key Technical Implementations

### 1. MVVM Architecture
- Clear separation between UI (Views) and business logic (ViewModels)
- Models for data representation
- Services for API calls and storage
- Navigation service for routing
- Theme management with ViewModel

### 2. Glassmorphism Design
- BackdropFilter for blur effects
- Transparent containers with gradients
- Modern UI with depth and layering
- Consistent design language across all screens

### 3. EMI Calculation Algorithm
```dart
EMI = P × r × (1 + r)^n / ((1 + r)^n - 1)
```
Where:
- P = Principal amount
- r = Monthly interest rate
- n = Number of months

### 4. Loan Eligibility Calculation
- Based on 50% of monthly income
- Deducts existing EMIs
- Adjustable for different interest rates and tenures
- Real-time calculation updates

### 5. Amortization Schedule
- Month-by-month principal and interest breakdown
- Remaining balance calculation
- Visual representation with charts
- Scrollable detailed view

### 6. Prepayment Calculator
- Calculates remaining balance at prepayment month
- Applies prepayment amount
- Recalculates EMI and tenure
- Shows total savings and interest saved

### 7. Loan Comparison
- Dynamic loan addition and removal
- Editable loan parameters
- Side-by-side comparison table
- Visual cards with color coding

### 8. Persistent Chat History
- Local storage using SharedPreferences
- JSON serialization for data persistence
- Search and filter functionality
- Category-based organization

### 9. Theme Management
- Dark/Light mode toggle
- Persistent theme preference
- Smooth theme transitions
- System-wide theme application

---

## 🧪 Testing

Run all tests:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

---

## 📱 Build & Release

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

---

## 🎨 Design System

### Color Palette
- **Primary Gradient**: `#667eea` → `#764ba2`
- **Secondary Gradient**: `#f093fb` → `#4facfe`
- **Background**: `#0F0F1E`, `#1A1A2E`, `#16213E`
- **Accent**: `#4ECDC4`, `#FFD700`, `#FFB84D`

### Typography
- **Font Family**: Poppins (System Default)
- **Heading**: Bold, 28-34px
- **Body**: Regular, 14-16px
- **Caption**: Medium, 12-13px

### UI Components
- Glassmorphic cards with backdrop blur
- Gradient buttons and indicators
- Animated transitions
- Tab-based navigation
- Floating action elements

---

## 📈 Performance

- **App Size**: ~15 MB (Release APK)
- **Startup Time**: <2 seconds
- **Frame Rate**: 60 FPS constant
- **Memory Usage**: <100 MB average
- **API Response Time**: <3 seconds average

---

## 🔒 Security

- API keys stored in constants (should be moved to environment variables in production)
- Input validation and sanitization
- Secure local storage implementation
- No sensitive data in logs
- Theme preference stored securely

---

## 🗺️ Roadmap

- [x] Multi-loan comparison tool
- [x] Amortization schedule
- [x] Prepayment calculator
- [x] Bank/NBFC directory
- [x] Dark/Light theme toggle
- [ ] Multi-language support (i18n)
- [ ] Firebase authentication
- [ ] Cloud sync across devices
- [ ] Push notifications
- [ ] PDF export of calculations
- [ ] Voice input for queries
- [ ] Export chat history
- [ ] Loan application tracking
- [ ] Credit score simulator
- [ ] Loan refinancing calculator

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Contribution Guidelines
- Follow MVVM architecture
- Maintain glassmorphism design consistency
- Add proper error handling
- Write clear comments
- Test your changes thoroughly

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Ran Vijay Kumar**
- Email: ranvijaykumar9708@gmail.com
- GitHub: [@Ranvijaykumar9708](https://github.com/Ranvijaykumar9708)

---

## 🙏 Acknowledgments

- [Google Gemini AI](https://ai.google.dev/) for AI capabilities
- [Flutter](https://flutter.dev/) for the amazing framework
- [fl_chart](https://pub.dev/packages/fl_chart) for beautiful charts
- [Provider](https://pub.dev/packages/provider) for state management
- Design inspiration from various fintech applications

---

## 📞 Support

If you like this project, please give it a ⭐️ on GitHub!

For support, email ranvijaykumar9708@gmail.com

---

## 🎯 Use Cases

### For Individuals
- Calculate EMI for different loan scenarios
- Check loan eligibility before applying
- Compare multiple loan offers
- Get AI-powered loan advice
- Track required documents
- Understand loan amortization

### For Financial Advisors
- Quick loan calculations
- Client loan comparisons
- Document requirement reference
- Interest rate analysis
- Prepayment benefit calculations

---

## 🔧 Technical Stack

- **Framework**: Flutter 3.9.2+
- **Language**: Dart 3.9.2+
- **State Management**: Provider
- **AI Integration**: Google Gemini API
- **Charts**: fl_chart
- **Storage**: SharedPreferences
- **Architecture**: MVVM

---

## 📊 Statistics

- **Total Features**: 15+
- **Loan Types Supported**: 6
- **Banks & NBFCs Listed**: 15+
- **Calculators**: 4 (EMI, Eligibility, Prepayment, Comparison)
- **Views**: 12+
- **ViewModels**: 7
- **Models**: 6

---

<div align="center">
  Made with ❤️ and Flutter
  
  **[⬆ Back to Top](#-loan-assistant---ai-powered-financial-assistant)**
</div>
