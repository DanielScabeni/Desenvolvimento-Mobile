import 'package:flutter/material.dart';
import 'package:ponto1/database/configuracao_dao.dart';
import 'package:ponto1/model/configuracao.dart';
import 'package:intl/intl.dart';

class ConfiguracoesPage extends StatefulWidget {
  @override
  _ConfiguracoesPageState createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  final _formKey = GlobalKey<FormState>();
  final _horaInicio1Controller = TextEditingController();
  final _horaFim1Controller = TextEditingController();
  final _horaInicio2Controller = TextEditingController();
  final _horaFim2Controller = TextEditingController();
  final ConfiguracaoDao _configuracaoDao = ConfiguracaoDao();

  String _duracaoTurno1 = '';
  String _duracaoTurno2 = '';
  String _intervalo = '';

  @override
  void initState() {
    super.initState();
    _carregarConfiguracoes();
  }

  Future<void> _carregarConfiguracoes() async {
    final configuracao = await _configuracaoDao.obterConfiguracao();
    if (configuracao != null) {
      setState(() {
        _horaInicio1Controller.text = configuracao.horaInicio1;
        _horaFim1Controller.text = configuracao.horaFim1;
        _horaInicio2Controller.text = configuracao.horaInicio2;
        _horaFim2Controller.text = configuracao.horaFim2;

        _calcularDuracoes();
      });
    }
  }

  Future<void> _salvarConfiguracoes() async {
    final configuracao = Configuracao(
      horaInicio1: _horaInicio1Controller.text,
      horaFim1: _horaFim1Controller.text,
      horaInicio2: _horaInicio2Controller.text,
      horaFim2: _horaFim2Controller.text,
    );
    await _configuracaoDao.salvar(configuracao);
  }

  Future<void> _selecionarHora(BuildContext context, TextEditingController controller) async {
    TimeOfDay initialTime;

    if (controller.text.isNotEmpty) {
      final parsedTime = DateFormat('HH:mm').parse(controller.text);
      initialTime = TimeOfDay(hour: parsedTime.hour, minute: parsedTime.minute);
    } else {
      initialTime = TimeOfDay.now();
    }

    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (selectedTime != null) {
      setState(() {
        final now = DateTime.now();
        final formattedTime = DateFormat('HH:mm').format(DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute));
        controller.text = formattedTime;
        _calcularDuracoes();
      });
    }
  }

  void _calcularDuracoes() {
    setState(() {
      _duracaoTurno1 = _calcularDiferenca(_horaInicio1Controller.text, _horaFim1Controller.text);
      _duracaoTurno2 = _calcularDiferenca(_horaInicio2Controller.text, _horaFim2Controller.text);
      _intervalo = _calcularDiferenca(_horaFim1Controller.text, _horaInicio2Controller.text);
    });
  }

  String _calcularDiferenca(String inicio, String fim) {
    if (inicio.isEmpty || fim.isEmpty) return '';
    try {
      final inicioTime = DateFormat('HH:mm').parse(inicio);
      final fimTime = DateFormat('HH:mm').parse(fim);
      final diferenca = fimTime.difference(inicioTime);

      final horas = diferenca.inHours;
      final minutos = diferenca.inMinutes % 60;

      return '${horas.toString().padLeft(2, '0')}h ${minutos.toString().padLeft(2, '0')}m';
    } catch (e) {
      return '';
    }
  }

  void _definirPadrao() {
    setState(() {
      _horaInicio1Controller.text = '07:42';
      _horaFim1Controller.text = '12:00';
      _horaInicio2Controller.text = '13:30';
      _horaFim2Controller.text = '18:00';
      _calcularDuracoes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Turno esperado',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildTimeField('Início 1º turno', _horaInicio1Controller, context),
              if (_duracaoTurno1.isNotEmpty)
                Text(
                  'Turno de: $_duracaoTurno1',
                  style: TextStyle(color: Colors.white),
                ),
              _buildTimeField('Fim 1º turno', _horaFim1Controller, context),
              SizedBox(height: 10),
              if (_intervalo.isNotEmpty)
                Text(
                  'Intervalo de: $_intervalo',
                  style: TextStyle(color: Colors.white),
                ),
              _buildTimeField('Início 2º turno', _horaInicio2Controller, context),
              if (_duracaoTurno2.isNotEmpty)
                Text(
                  'Turno de: $_duracaoTurno2',
                  style: TextStyle(color: Colors.white),
                ),
              _buildTimeField('Fim 2º turno', _horaFim2Controller, context),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _salvarConfiguracoes();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Configurações salvas')),
                      );
                    }
                  },
                  child: Text('Salvar'),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _definirPadrao,
                  child: Text('Adicionar padrão'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeField(String label, TextEditingController controller, BuildContext context) {
    return GestureDetector(
      onTap: () => _selecionarHora(context, controller),
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
          style: TextStyle(color: Colors.white),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira um horário';
            }
            if (!_isValidTime(value)) {
              return 'Formato de horário inválido';
            }
            return null;
          },
        ),
      ),
    );
  }

  bool _isValidTime(String value) {
    try {
      DateFormat('HH:mm').parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }
}
