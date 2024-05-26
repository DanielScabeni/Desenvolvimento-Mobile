import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:ponto1/model/ponto.dart';

class ListaDePontosPage extends StatefulWidget {
  final List<Ponto> pontos;

  ListaDePontosPage({Key? key, required this.pontos}) : super(key: key);

  @override
  _ListaDePontosPageState createState() => _ListaDePontosPageState();
}

class _ListaDePontosPageState extends State<ListaDePontosPage> {
  DateTime dataInicio = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime dataFim = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _selecionarDataInicio(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dataInicio,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != dataInicio) {
      setState(() {
        dataInicio = picked;
      });
    }
  }

  Future<void> _selecionarDataFim(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dataFim,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != dataFim) {
      setState(() {
        dataFim = picked;
      });
    }
  }

  List<Map<String, dynamic>> _agruparPontosPorDia(List<Ponto> pontos) {
    Map<String, List<String>> pontosAgrupados = {};

    for (var ponto in pontos) {
      String dia = DateFormat('dd/MM/yyyy - EEE').format(ponto.diaDeTrabalho!);
      String hora = DateFormat('HH:mm').format(ponto.data!);

      if (!pontosAgrupados.containsKey(dia)) {
        pontosAgrupados[dia] = List.filled(4, '--:--');
      }

      int index = pontosAgrupados[dia]!.indexOf('--:--');
      if (index != -1) {
        pontosAgrupados[dia]![index] = hora;
      }
    }

    return pontosAgrupados.entries
        .map((entry) => {
      'dia': entry.key,
      'horarios': entry.value,
    })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> pontosFiltrados = _agruparPontosPorDia(
      widget.pontos
          .where((ponto) =>
      ponto.diaDeTrabalho!
          .isAfter(dataInicio.subtract(Duration(days: 1))) &&
          ponto.diaDeTrabalho!.isBefore(dataFim.add(Duration(days: 1))))
          .toList(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Pontos', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Altere a cor da seta para branco
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDateSelector('De', dataInicio, _selecionarDataInicio),
                _buildDateSelector('Até', dataFim, _selecionarDataFim),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pontosFiltrados.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${pontosFiltrados[index]['dia']}',
                        style: TextStyle(color: Colors.white),
                      ),
                      ...pontosFiltrados[index]['horarios']
                          .map<Widget>((hora) => Text(
                        hora,
                        style: TextStyle(color: Colors.white),
                      ))
                          .toList(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(String label, DateTime date, Future<void> Function(BuildContext) onTap) {
    return Row(
      children: [
        Text('$label ', style: TextStyle(color: Colors.white)),
        SizedBox(height: 4),
        GestureDetector(
          onTap: () => onTap(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              DateFormat('dd/MM/yyyy').format(date),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
