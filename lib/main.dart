import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'providers/shopping_provider.dart';
import 'screens/main_screen.dart';
import 'package:smart_pantry/providers/inventory_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => InventoryProvider()),
        ChangeNotifierProvider(create: (context) => ShoppingProvider()),
      ],
      child: const SmartPantryApp(),
    ),
  );
}

class SmartPantryApp extends StatelessWidget {
  const SmartPantryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Pantry',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}