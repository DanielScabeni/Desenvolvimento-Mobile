
import 'package:intl/intl.dart';

class Ponto{
  static const campo_id = '_id';
  static const campo_descricao = 'descricao';
  static const campo_data = 'data';
  static const campo_hora = 'hora';


  int id;
  String descricao;
  DateTime? data;

  Ponto({ required this.id, required this.descricao, this.data});

  String get dataFormatada{
    if (data == null){
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(data!);
  }
}