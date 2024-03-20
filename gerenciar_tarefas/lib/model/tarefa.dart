
import 'package:intl/intl.dart';

class Tarefa{
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
}