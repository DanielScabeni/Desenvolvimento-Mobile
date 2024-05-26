import 'package:flutter/material.dart';
import 'package:ponto1/model/ponto.dart';

class ListaDePontosPage extends StatelessWidget {
  final List<Ponto> pontos;

  ListaDePontosPage({required this.pontos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pontos'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView.builder(
        itemCount: pontos.length,
        itemBuilder: (context, index) {
          final ponto = pontos[index];
          return ListTile(
            title: Row(
              children: [
                Text(ponto.dataFormatada, style: const TextStyle(color: Colors.white)),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    ponto.horasFormatadas,
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
