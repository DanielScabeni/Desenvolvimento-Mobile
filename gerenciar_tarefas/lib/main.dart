import 'package:flutter/material.dart';
import 'package:gerenciar_tarefas/pages/lista_page_tarefas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // this widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black87),
        primaryColor: Colors.orangeAccent,
        useMaterial3: true,
      ),
      home: ListaTarefaPage()

    );
  }
}

