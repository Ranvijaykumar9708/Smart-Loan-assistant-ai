import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/home_view_model.dart';
import 'view_models/theme_view_model.dart';
import 'navigation/app_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => ThemeViewModel()),
      ],
      child: const LoanAssistantApp(),
    ),
  );
}

class LoanAssistantApp extends StatelessWidget {
  const LoanAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeViewModel>(
      builder: (context, themeVm, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Loan Assistant',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Poppins',
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Poppins',
            brightness: Brightness.dark,
          ),
          themeMode: themeVm.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: AppRouter.splash,
          onGenerateRoute: AppRouter.generateRoute,
        );
      },
    );
  }
}
