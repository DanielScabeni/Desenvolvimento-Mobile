import 'package:flutter/material.dart';
import 'package:ponto1/pages/lista_page_ponto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ponto',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: const Color(0xFF36415F),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF36415F),
          secondary: const Color(0xFF36415F),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF36415F),
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF1F233C),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: ListaPontoPage(),
      routes: const {},
    );
  }
}
