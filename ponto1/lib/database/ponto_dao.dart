import 'package:flutter/material.dart';
import 'package:ponto1/database/data_base_provider.dart';
import 'package:ponto1/model/ponto.dart';

class PontoDao with ChangeNotifier {
  final dbProvider = DatabaseProvider.instance;
  List<Ponto> _pontos = [];

  List<Ponto> get pontos => _pontos;

  PontoDao() {
    _carregarPontos();
  }

  Future<void> _carregarPontos() async {
    final db = await dbProvider.database;
    final resultado = await db.query(
      'pontos',
      columns: ['id', 'data', 'dia_de_trabalho', 'hora'],
      orderBy: 'id',
    );
    _pontos = resultado.map((m) => Ponto.fromMap(m)).toList();
    notifyListeners();
  }

  Future<bool> salvar(Ponto ponto) async {
    final db = await dbProvider.database;
    final valores = ponto.toMap();
    if (ponto.id == 0) { //nao esta chegando no insert pq o primeiro ponto ja vem com valor 1, ai nao cai nessa condicao, talvez fazer o ponto vir como nulo para o autoincrement do banco colocar o id, ou fazer ele vem como 0 sla
      ponto.id = await db.insert('pontos', valores);
      print('Ponto inserido: ${ponto.toMap()}');
    } else {
      await db.update(
        'pontos',
        valores,
        where: 'id = ?',
        whereArgs: [ponto.id],
      );
      print('Ponto atualizado: ${ponto.toMap()}');
    }
    await _carregarPontos();
    return true;
  }

  Future<bool> remover(int id) async {
    final db = await dbProvider.database;
    final removerRegistro = await db.delete(
      'pontos',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Ponto removido: id=$id');
    await _carregarPontos();
    return removerRegistro > 0;
  }

  Future<List<Ponto>> listar() async {
    await _carregarPontos();
    return _pontos;
  }
}
