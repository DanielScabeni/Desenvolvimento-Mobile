class Configuracao {
  int? id;
  String horaInicio1;
  String horaFim1;
  String horaInicio2;
  String horaFim2;

  Configuracao({
    this.id,
    required this.horaInicio1,
    required this.horaFim1,
    required this.horaInicio2,
    required this.horaFim2,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hora_inicio1': horaInicio1,
      'hora_fim1': horaFim1,
      'hora_inicio2': horaInicio2,
      'hora_fim2': horaFim2,
    };
  }

  factory Configuracao.fromMap(Map<String, dynamic> map) {
    return Configuracao(
      id: map['id'],
      horaInicio1: map['hora_inicio1'],
      horaFim1: map['hora_fim1'],
      horaInicio2: map['hora_inicio2'],
      horaFim2: map['hora_fim2'],
    );
  }
}
