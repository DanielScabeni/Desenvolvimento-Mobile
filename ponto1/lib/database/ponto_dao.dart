import 'package:sqflite/sqflite.dart';
import 'package:ponto1/database/data_base_provider.dart';
import 'package:ponto1/model/ponto.dart';

class PontoDao {
  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar(Ponto ponto) async {
    final db = await dbProvider.database;
    final valores = ponto.toMap();
    if (ponto.id == 0) {
      ponto.id = await db.insert('pontos', valores);
      return true;
    } else {
      final registrosAtualizados = await db.update(
        'pontos',
        valores,
        where: 'id = ?',
        whereArgs: [ponto.id],
      );
      return registrosAtualizados > 0;
    }
  }

  Future<bool> remover(int id) async {
    final db = await dbProvider.database;
    final removerRegistro = await db.delete(
      'pontos',
      where: 'id = ?',
      whereArgs: [id],
    );
    return removerRegistro > 0;
  }

  Future<List<Ponto>> listar({
    String filtro = '',
    String campoOrdenacao = 'id',
    bool usarOrdemDecrescente = false,
  }) async {
    final db = await dbProvider.database;

    String? where;
    if (filtro.isNotEmpty) {
      where = "UPPER(data) LIKE '${filtro.toUpperCase()}%'";
    }

    var orderBy = campoOrdenacao;
    if (usarOrdemDecrescente) {
      orderBy += ' DESC';
    }

    final resultado = await db.query(
      'pontos',
      columns: ['id', 'data', 'dia_de_trabalho', 'hora'],
      where: where,
      orderBy: orderBy,
    );
    return resultado.map((m) => Ponto.fromMap(m)).toList();
  }
}
