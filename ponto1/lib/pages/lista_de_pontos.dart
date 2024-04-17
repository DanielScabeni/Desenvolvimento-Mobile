import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ponto1/model/ponto.dart';

class ListaDePontosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pontos = _buscarPontosDoMes();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pontos'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView.builder(
        itemCount: pontos.length,
        itemBuilder: (context, index) {
          final ponto = pontos[index];
          return ListTile(
            title: Text(ponto.dataFormatada),
            subtitle: Text(ponto.horasFormatadas),
          );
        },
      ),
    );
  }

  List<Ponto> _buscarPontosDoMes() {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    List<Ponto> pontos = [];
    for (int i = 0; i <= lastDayOfMonth.difference(firstDayOfMonth).inDays; i++) {
      DateTime currentDate = firstDayOfMonth.add(Duration(days: i));
      String formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
      // A lógica para verificar se há registro para a `currentDate` deve ser implementada
      // Se houver um registro, você deve criar um objeto `Ponto` com as horas corretas
      // Se não houver registro, use '--:--' para as horas
      String horasFormatadas = '--:--'; // Substitua isso pela lógica de obtenção das horas registradas

      pontos.add(Ponto(id: i, descricao: formattedDate, data: currentDate, horasFormatadas: horasFormatadas));
    }

    return pontos;
  }
}
