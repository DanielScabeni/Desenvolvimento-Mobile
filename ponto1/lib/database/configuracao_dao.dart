import 'package:sqflite/sqflite.dart';
import 'package:ponto1/database/data_base_provider.dart';
import 'package:ponto1/model/configuracao.dart';

class ConfiguracaoDao {
  final dbProvider = DatabaseProvider.instance;

  Future<int> salvar(Configuracao configuracao) async {
    final db = await dbProvider.database;
    return await db.insert('configuracoes', configuracao.toMap());
  }

  Future<int> atualizar(Configuracao configuracao) async {
    final db = await dbProvider.database;
    return await db.update(
      'configuracoes',
      configuracao.toMap(),
      where: 'id = ?',
      whereArgs: [configuracao.id],
    );
  }

  Future<Configuracao?> obterConfiguracao() async {
    final db = await dbProvider.database;
    final result = await db.query('configuracoes', limit: 1);
    if (result.isNotEmpty) {
      return Configuracao.fromMap(result.first);
    }
    return null;
  }
}
