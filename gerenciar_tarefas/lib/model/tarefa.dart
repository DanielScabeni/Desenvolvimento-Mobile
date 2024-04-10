
import 'package:intl/intl.dart';

class Tarefa{
  static const nome_tabela = 'tarefas';
  static const campo_id = '_id';
  static const campo_descricao = 'descricao';
  static const campo_prazo = 'prazo';

  int id;
  String descricao;
  DateTime? prazo;

  Tarefa({ required this.id, required this.descricao, this.prazo});

  String get prazoFormatado{
    if (prazo == null){
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(prazo!);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    campo_id: id,
    campo_descricao: descricao,
    campo_prazo: prazo == null ? null : DateFormat("yyy-MM-dd").format(prazo!),
  };

  factory Tarefa.fromMap(Map<String, dynamic> map ) => Tarefa(
    id : map[campo_id] is int ? map[campo_id] : null,
    descricao : map[campo_descricao] is String ? map [campo_descricao] : '',
    prazo : map[campo_prazo] is String ? DateFormat("yyy-MM-dd").parse(map[campo_prazo]) : null,
  );
}