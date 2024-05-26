import 'dart:convert';
import 'package:intl/intl.dart';

class Ponto {
  static const campo_id = '_id';
  static const campo_descricao = 'descricao';
  static const campo_data = 'data';
  static const campo_horas = 'horas';

  int id;
  String descricao;
  DateTime? data;
  List<String> horas;

  Ponto({required this.id, required this.descricao, this.data, required this.horas});

  String get dataFormatada {
    if (data == null) {
      return '';
    }
    return DateFormat('dd/MM/yyyy').format(data!);
  }

  String get horasFormatadas {
    if (horas.isEmpty) {
      return '--:--  --:--  --:--  --:--';
    }
    return horas.join('  ') + '  ' + '--:--  ' * (4 - horas.length);
  }

  Map<String, dynamic> toMap() {
    return {
      campo_id: id,
      campo_descricao: descricao,
      campo_data: data?.toIso8601String(),
      campo_horas: horas,
    };
  }

  factory Ponto.fromMap(Map<String, dynamic> map) {
    return Ponto(
      id: map[campo_id],
      descricao: map[campo_descricao],
      data: map[campo_data] != null ? DateTime.parse(map[campo_data]) : null,
      horas: List<String>.from(map[campo_horas]),
    );
  }

  String toJson() => json.encode(toMap());

  factory Ponto.fromJson(String source) => Ponto.fromMap(json.decode(source));
}
