import 'dart:convert';

class Ponto {
  int id;
  String descricao;
  DateTime? data;
  DateTime? diaDeTrabalho;
  List<String> horas;

  Ponto({
    required this.id,
    required this.descricao,
    required this.data,
    required this.diaDeTrabalho,
    required this.horas,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
      'data': data?.toIso8601String(),
      'diaDeTrabalho': diaDeTrabalho?.toIso8601String(),
      'horas': horas,
    };
  }

  factory Ponto.fromMap(Map<String, dynamic> map) {
    return Ponto(
      id: map['id'],
      descricao: map['descricao'],
      data: map['data'] != null ? DateTime.parse(map['data']) : null,
      diaDeTrabalho: map['diaDeTrabalho'] != null ? DateTime.parse(map['diaDeTrabalho']) : null,
      horas: List<String>.from(map['horas']),
    );
  }

  String get horasFormatadas {
    final buffer = StringBuffer();
    for (var hora in horas) {
      if (buffer.isNotEmpty) buffer.write(' ');
      buffer.write(hora);
    }
    return buffer.toString();
  }
}
