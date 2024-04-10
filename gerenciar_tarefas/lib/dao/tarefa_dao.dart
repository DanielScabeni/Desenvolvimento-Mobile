
import 'package:gerenciar_tarefas/database/data_base_provider.dart';
import 'package:gerenciar_tarefas/model/tarefa.dart';

class TarefaDao{
  final dbProvider = DatabaseProvider.instance;

  Future<bool> salvar (Tarefa tarefa) async{
    final db = await dbProvider.database;
    final valores = tarefa.toMap();
    if(tarefa.id == null){
      tarefa.id = await db.insert(Tarefa.nome_tabela, valores);
      return true;
    }else{
      final registrosAtualizados = await db.update(
          Tarefa.nome_tabela, valores,
          where: '${Tarefa.campo_id} = ?',
          whereArgs: [tarefa.id]
      );
      return registrosAtualizados > 0;
    }
  }

  Future<bool> remover (int id) async{
    final db = await dbProvider.database;
    final removerRegistro = await db.delete(Tarefa.nome_tabela, where: '${Tarefa.campo_id} = ?', whereArgs: [id]);

    return removerRegistro > 0;
  }

  Future<List<Tarefa>> Lista() async{
    final db = await dbProvider.database;
    final resultado = await db.query(Tarefa.nome_tabela,
    columns: [Tarefa.campo_id, Tarefa.campo_descricao, Tarefa.campo_prazo]);
    return resultado.map((m) => Tarefa.fromMap(m)).toList();
  }
}