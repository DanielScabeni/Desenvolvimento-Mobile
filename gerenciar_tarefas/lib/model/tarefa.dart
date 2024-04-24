
import 'package:intl/intl.dart';

class Tarefa{
  static const nome_tabela = 'tarefas';
  static const campo_id = '_id';
  static const campo_descricao = 'descricao';
  static const campo_prazo = 'prazo';
  static const campo_finalizado = 'finalizada';

  int? id;
  String descricao;
  DateTime? prazo;
  bool finalizada;

  Tarefa({ required this.id, required this.descricao, this.prazo, this.finalizada=false});

  String get prazoFormatado{
    if (prazo == null){
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(prazo!);
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    campo_id: id,
    campo_descricao: descricao,
    campo_prazo: prazo == null ? null : DateFormat("yyyy-MM-dd").format(prazo!),
    campo_finalizado: finalizada ? 1 : 0,
  };

  factory Tarefa.fromMap(Map<String, dynamic> map) => Tarefa(
    id: map[campo_id] is int ? map[campo_id]: null,
    descricao: map[campo_descricao] is String ? map[campo_descricao] : '',
    prazo: map[campo_prazo] is String ? DateFormat('yyyy-MM-dd').parse(map[campo_prazo]) : null,
    finalizada: map[campo_finalizado] == 1,
  );

}