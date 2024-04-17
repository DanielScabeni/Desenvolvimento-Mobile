
import 'package:intl/intl.dart';

class Ponto {
  static const campo_id = '_id';
  static const campo_descricao = 'descricao';
  static const campo_data = 'data';
  static const campo_hora = 'hora';

  int id;
  String descricao;
  DateTime? data;
  String horasFormatadas; // Adicione esta linha

  Ponto({required this.id, required this.descricao, this.data, required this.horasFormatadas}); // Inclua o parâmetro aqui

  String get dataFormatada {
    if (data == null) {
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(data!);
  }
}
