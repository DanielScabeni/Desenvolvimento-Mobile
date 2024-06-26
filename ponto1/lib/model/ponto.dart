import 'dart:convert';

class Ponto {
  int id;
  DateTime? data;
  DateTime? diaDeTrabalho;
  List<String> hora;
  double? latitude;
  double? longitude;

  Ponto({
    this.id = 0,
    required this.data,
    required this.diaDeTrabalho,
    required this.hora,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data?.toIso8601String(),
      'dia_de_trabalho': diaDeTrabalho?.toIso8601String(),
      'hora': jsonEncode(hora),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Ponto.fromMap(Map<String, dynamic> map) {
    return Ponto(
      id: map['id'],
      data: map['data'] != null ? DateTime.parse(map['data']) : null,
      diaDeTrabalho: map['dia_de_trabalho'] != null ? DateTime.parse(map['dia_de_trabalho']) : null,
      hora: map['hora'] != null ? List<String>.from(jsonDecode(map['hora'])) : [],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  String get horasFormatadas {
    final buffer = StringBuffer();
    for (var hora in hora) {
      if (buffer.isNotEmpty) buffer.write(' ');
      buffer.write(hora);
    }
    return buffer.toString();
  }
}
