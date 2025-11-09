# 🤖 Loan Assistant - AI-Powered Financial Assistant

<div align="center">
  
  ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
  ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
  ![Provider](https://img.shields.io/badge/Provider-61DAFB?style=for-the-badge&logo=react&logoColor=black)
  ![Gemini AI](https://img.shields.io/badge/Gemini_AI-8E75B2?style=for-the-badge&logo=google&logoColor=white)
  
  **A premium Flutter application that provides AI-powered loan advice and financial calculations**
  
  [Demo Video](#) • [Download APK](#) • [Report Bug](#) • [Request Feature](#)
  
</div>

---

## 📱 Features

### 🤖 AI-Powered Assistance
- Intelligent loan advice powered by Google's Gemini AI
- Real-time responses with detailed guidance
- Context-aware answers for different loan types
- Support for 6 loan types: Personal, Home, Car, Education, Business, Gold

### 📊 Smart Loan Calculator
- Interactive EMI calculator with live updates
- Beautiful pie charts for payment visualization
- Amortization breakdown with detailed insights
- Loan comparison tool for multiple scenarios

### 💰 Loan Eligibility Calculator
- Calculate your loan eligibility based on income
- Consider existing EMIs in calculations
- Adjustable interest rates and tenure
- Real-time eligibility updates

### 📋 Document Checklist
- Comprehensive document lists for each loan type
- Interactive checklist with progress tracking
- Organized by loan category
- Visual progress indicators

### 💬 Chat History Management
- Persistent local storage of all conversations
- Search functionality across chat history
- Category-based organization by loan type
- Delete individual or all conversations

### 💡 Loan Tips & Advice
- Expert tips for better loan management
- Best practices for loan applications
- Interest rate negotiation tips
- Credit score improvement advice

### 🎨 Premium UI/UX
- Modern glassmorphic design
- Dark theme with gradient accents
- Smooth animations and transitions
- Responsive layout for all screen sizes
- Animated onboarding experience

### ⚙️ Settings & Data Management
- Clear chat history
- Clear all app data
- Share app functionality
- App information and version details

---

## 🏗️ Architecture

This project follows **MVVM (Model-View-ViewModel)** architecture with a clear separation of concerns:

```
lib/
├── models/              # Data models
│   ├── chat_message.dart
│   ├── loan_calculation.dart
│   └── loan_type.dart
├── views/               # UI screens
│   ├── home_view.dart
│   ├── chat_history_view.dart
│   ├── emi_calculator_view.dart
│   ├── loan_eligibility_view.dart
│   ├── loan_comparison_view.dart
│   ├── document_checklist_view.dart
│   ├── loan_tips_view.dart
│   ├── settings_view.dart
│   ├── splash_view.dart
│   └── onboarding_view.dart
├── view_models/         # Business logic (Provider)
│   ├── home_view_model.dart
│   ├── emi_calculator_view_model.dart
│   └── loan_eligibility_view_model.dart
├── services/            # API & local storage
│   ├── api_service.dart
│   └── storage_service.dart
├── navigation/          # Routing
│   └── app_router.dart
├── utils/               # Helper functions
│   └── loan_calculator.dart
├── constants/           # App constants
│   └── app_constants.dart
└── main.dart
```

### State Management
- **Provider** for reactive state management
- **ChangeNotifier** pattern for view models
- Efficient rebuilds with context.watch/read

### Data Persistence
- **SharedPreferences** for local storage
- JSON serialization for chat history and calculations
- Secure API key management

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
  provider: ^6.1.1
  
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

### 2. Glassmorphism Design
- BackdropFilter for blur effects
- Transparent containers with gradients
- Modern UI with depth and layering

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

### 5. Persistent Chat History
- Local storage using SharedPreferences
- JSON serialization for data persistence
- Search and filter functionality

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

---

## 📈 Performance

- **App Size**: ~15 MB (Release APK)
- **Startup Time**: <2 seconds
- **Frame Rate**: 60 FPS constant
- **Memory Usage**: <100 MB average

---

## 🔒 Security

- API keys stored in constants (should be moved to environment variables in production)
- Input validation and sanitization
- Secure local storage implementation
- No sensitive data in logs

---

## 🗺️ Roadmap

- [ ] Multi-language support (i18n)
- [ ] Firebase authentication
- [ ] Cloud sync across devices
- [ ] Push notifications
- [ ] PDF export of calculations
- [ ] Voice input for queries
- [ ] Advanced comparison tool
- [ ] Dark/Light theme toggle
- [ ] Export chat history
- [ ] Loan application tracking

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Ran Vijay Kumar**
- Email: ranvijaykumar9708@gmail.com
- GitHub: https://github.com/Ranvijaykumar9708

---

## 🙏 Acknowledgments

- [Google Gemini AI](https://ai.google.dev/) for AI capabilities
- [Flutter](https://flutter.dev/) for the amazing framework
- [fl_chart](https://pub.dev/packages/fl_chart) for beautiful charts
- Design inspiration from various fintech applications

---

## 📞 Support

If you like this project, please give it a ⭐️ on GitHub!

For support, email ranvijaykumar9708@gmail.com

---

<div align="center">
  Made with ❤️ and Flutter
  
  **[⬆ Back to Top](#-loan-assistant---ai-powered-financial-assistant)**
</div>
# Smart-Loan-assistant-ai
