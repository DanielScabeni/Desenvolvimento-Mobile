import 'package:flutter/material.dart';
import 'package:ponto1/database/data_base_provider.dart';
import 'package:ponto1/pages/lista_page_ponto.dart';
import 'package:ponto1/pages/configuracoes_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Chamada temporária para excluir o banco de dados.
  // await DatabaseProvider.instance.deleteDatabase();

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
      routes: {
        '/configuracoes': (context) => ConfiguracoesPage(),
      },
    );
  }
}
