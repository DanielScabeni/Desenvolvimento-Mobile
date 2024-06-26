class Configuracao {
  final int id;
  final String horaInicio1;
  final String horaFim1;
  final String horaInicio2;
  final String horaFim2;
  final int maxMarcacoes;

  Configuracao({
    required this.id,
    required this.horaInicio1,
    required this.horaFim1,
    required this.horaInicio2,
    required this.horaFim2,
    this.maxMarcacoes = 4,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hora_inicio1': horaInicio1,
      'hora_fim1': horaFim1,
      'hora_inicio2': horaInicio2,
      'hora_fim2': horaFim2,
      'max_marcacoes': maxMarcacoes,
    };
  }

  static Configuracao fromMap(Map<String, dynamic> map) {
    return Configuracao(
      id: map['id'],
      horaInicio1: map['hora_inicio1'],
      horaFim1: map['hora_fim1'],
      horaInicio2: map['hora_inicio2'],
      horaFim2: map['hora_fim2'],
      maxMarcacoes: map['max_marcacoes'],
    );
  }
}
