import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/home_view_model.dart';
import 'navigation/app_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: const LoanAssistantApp(),
    ),
  );
}

class LoanAssistantApp extends StatelessWidget {
  const LoanAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loan Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
