import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ponto1/model/ponto.dart';
import 'package:ponto1/pages/lista_de_pontos.dart';
import 'package:ponto1/widgets/conteudo_form_dialog.dart';
import 'package:ponto1/pages/configuracoes_page.dart';
import 'package:ponto1/provider/ponto_provider.dart';
import 'package:ponto1/database/configuracao_dao.dart';
import 'package:ponto1/model/configuracao.dart';

class ListaPontoPage extends StatefulWidget {
  @override
  _ListaPontoPageState createState() => _ListaPontoPageState();
}

class _ListaPontoPageState extends State<ListaPontoPage> {
  int _selectedIndex = 0;
  DateTime _dataSelecionada = DateTime.now();

  String _horaInicio1 = '';
  String _horaFim1 = '';
  String _horaInicio2 = '';
  String _horaFim2 = '';
  Duration _duracaoTurno1 = Duration.zero;
  Duration _duracaoTurno2 = Duration.zero;
  Duration _intervalo = Duration.zero;
  Position? _localizacaoAtual; // Adicionado para armazenar a localização atual

  @override
  void initState() {
    super.initState();
    _carregarConfiguracoes();
    _carregarPontos();
    _obterLocalizacaoAtual(); // Adicionado para obter a localização atual ao iniciar
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _navegarParaListaDePontos();
      } else if (index == 2) {
        _navegarParaConfiguracoes();
      }
    });
  }

  void _navegarParaListaDePontos() {
    final pontos = Provider.of<PontoProvider>(context, listen: false).pontos;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ListaDePontosPage(pontos: pontos),
    ));
  }

  void _navegarParaConfiguracoes() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ConfiguracoesPage(),
    ));
  }

  Future<void> _carregarPontos() async {
    await Provider.of<PontoProvider>(context, listen: false).carregarPontos();
  }

  Future<void> _carregarConfiguracoes() async {
    final configuracaoDao = ConfiguracaoDao();
    final configuracao = await configuracaoDao.obterConfiguracao();
    setState(() {
      _horaInicio1 = configuracao?.horaInicio1 ?? '08:00';
      _horaFim1 = configuracao?.horaFim1 ?? '12:00';
      _horaInicio2 = configuracao?.horaInicio2 ?? '13:00';
      _horaFim2 = configuracao?.horaFim2 ?? '17:00';
      _duracaoTurno1 = _calcularDuracao(_horaInicio1, _horaFim1);
      _duracaoTurno2 = _calcularDuracao(_horaInicio2, _horaFim2);
      _intervalo = _calcularDuracao(_horaFim1, _horaInicio2);
    });
  }

  Future<void> _obterLocalizacaoAtual() async {
    bool servicoHabilitado = await _servicoHabilitado();
    if (!servicoHabilitado) {
      return;
    }

    bool permissoesPermitidas = await _permissoesPermitidas();
    if (!permissoesPermitidas) {
      return;
    }

    _localizacaoAtual = await Geolocator.getCurrentPosition();
  }

  Future<bool> _permissoesPermitidas() async {
    LocationPermission permissao = await Geolocator.checkPermission();

    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        _mostrarMensagem('Não será possível usar o recurso por falta de permissão');
        return false;
      }
    }
    if (permissao == LocationPermission.deniedForever) {
      await _mostrarDialogMensagem('Para utilizar esse recurso, você deverá acessar as configurações do app e permitir a utilização do serviço de localização');
      Geolocator.openAppSettings();
      return false;
    }
    return true;
  }

  Future<bool> _servicoHabilitado() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();

    if (!servicoHabilitado) {
      await _mostrarDialogMensagem('Para utilizar esse serviço, você deverá habilitar o serviço de localização do dispositivo.');
      Geolocator.openLocationSettings();
      return false;
    }
    return true;
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mensagem),
    ));
  }

  Future<void> _mostrarDialogMensagem(String mensagem) async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text('Atenção'),
              content: Text(mensagem),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'))
              ],
            ));
  }

  List<Ponto> _filtrarPontosDoDia(List<Ponto> pontos, DateTime data) {
    return pontos.where((ponto) {
      return ponto.diaDeTrabalho!.year == data.year &&
          ponto.diaDeTrabalho!.month == data.month &&
          ponto.diaDeTrabalho!.day == data.day;
    }).toList();
  }

  void _alterarDataSelecionada(int dias) {
    setState(() {
      _dataSelecionada = _dataSelecionada.add(Duration(days: dias));
    });
  }

  Duration _calcularDuracaoTurno(List<Ponto> pontos) {
    if (pontos.length < 2) return Duration.zero;
    return pontos.last.data!.difference(pontos.first.data!);
  }

  String _formatarDuracao(Duration duracao) {
    final horas = duracao.inHours;
    final minutos = duracao.inMinutes % 60;
    return '${horas.toString().padLeft(2, '0')}h ${minutos.toString().padLeft(2, '0')}m';
  }

  String _calcularSaldoTurno(Duration duracaoTurno, Duration duracaoEsperada) {
    final saldo = duracaoTurno - duracaoEsperada;
    final prefix = saldo.isNegative ? '-' : '+';
    final saldoFormatado = _formatarDuracao(saldo.abs());
    return '$prefix$saldoFormatado';
  }

  @override
  Widget build(BuildContext context) {
    final pontosProvider = Provider.of<PontoProvider>(context);
    final pontosDoDia = _filtrarPontosDoDia(pontosProvider.pontos, _dataSelecionada);
    final duracaoTurno1 = pontosDoDia.length >= 2 ? pontosDoDia[1].data!.difference(pontosDoDia[0].data!) : Duration.zero;
    final saldoTurno1 = _calcularSaldoTurno(duracaoTurno1, _duracaoTurno1);
    final duracaoTurno2 = pontosDoDia.length >= 4 ? pontosDoDia[3].data!.difference(pontosDoDia[2].data!) : Duration.zero;
    final duracaoTotal = duracaoTurno1 + duracaoTurno2;
    final saldoTotal = _calcularSaldoTurno(duracaoTotal, _duracaoTurno1 + _duracaoTurno2);

    return Scaffold(
      appBar: _criarAppBar(context),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Lista',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Dia',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: _abrirForm,
        tooltip: 'Novo Ponto',
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _carregarPontos();
          await _carregarConfiguracoes();
          setState(() {});
        },
        child: Column(
          children: [
            _criarCabecalho(),
            _criarResumo(duracaoTotal, saldoTotal),
            Expanded(child: _criarBody(pontosDoDia, duracaoTurno1)),
          ],
        ),
      ),
    );
  }

  AppBar _criarAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      title: const Text('Ponto'),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: _abrirForm,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _criarCabecalho() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left, color: Colors.white),
            onPressed: () => _alterarDataSelecionada(-1),
          ),
          Text(
            DateFormat('EEE, dd MMM yyyy').format(_dataSelecionada),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right, color: Colors.white),
            onPressed: () => _alterarDataSelecionada(1),
          ),
        ],
      ),
    );
  }

  Widget _criarResumo(Duration duracaoTurno, String saldoTurno) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text('Trab. no dia', style: TextStyle(color: Colors.white)),
              Text(_formatarDuracao(duracaoTurno), style: TextStyle(color: Colors.white)),
            ],
          ),
          Column(
            children: [
              Text('Saldo do dia', style: TextStyle(color: Colors.white)),
              Text(saldoTurno, style: TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _criarBody(List<Ponto> pontosDoDia, Duration duracaoTurno1) {
    if (pontosDoDia.isEmpty) {
      return _criarPrevisoes([]);
    }
    List<Widget> widgets = [];

    for (int i = 0; i < pontosDoDia.length; i++) {
      final ponto = pontosDoDia[i];
      final isEntrada = i % 2 == 0;

      widgets.add(_criarMarcacao(ponto, isEntrada));

      if (i == 0 && pontosDoDia.length > 1) {
        widgets.add(_criarInfo('Turno 1 de ${_formatarDuracao(pontosDoDia[1].data!.difference(pontosDoDia[0].data!))}'));
      } else if (i == 1 && pontosDoDia.length > 2) {
        widgets.add(_criarInfo('Intervalo de ${_formatarDuracao(pontosDoDia[2].data!.difference(pontosDoDia[1].data!))}'));
      } else if (i == 2 && pontosDoDia.length > 3) {
        widgets.add(_criarInfo('Turno 2 de ${_formatarDuracao(pontosDoDia[3].data!.difference(pontosDoDia[2].data!))}'));
      }
    }

    if (pontosDoDia.length == 4) {
      final tempoTrabalhado = pontosDoDia[1].data!.difference(pontosDoDia[0].data!) +
          pontosDoDia[3].data!.difference(pontosDoDia[2].data!);
      widgets.add(_criarInfo('Tempo total trabalhado: ${_formatarDuracao(tempoTrabalhado)}'));
    } else {
      if (pontosDoDia.length == 1) {
        widgets.add(_criarInfo('Turno 1 de ${_formatarDuracao(_duracaoTurno1)}'));
        widgets.add(_criarPrevisaoItem(pontosDoDia[0].data!.add(_duracaoTurno1), 'Previsão de saída', Icons.logout, Colors.red));
        widgets.add(_criarInfo('Intervalo de ${_formatarDuracao(_intervalo)}'));
        widgets.add(_criarPrevisaoItem(pontosDoDia[0].data!.add(_duracaoTurno1).add(_intervalo), 'Previsão de retorno do intervalo', Icons.login, Colors.green));
        widgets.add(_criarInfo('Turno 2 de ${_formatarDuracao(_duracaoTurno2)}'));
        widgets.add(_criarPrevisaoItem(pontosDoDia[0].data!.add(_duracaoTurno1).add(_intervalo).add(_duracaoTurno2), 'Previsão de saída (do dia seguinte)', Icons.logout, Colors.red));
        widgets.add(_criarInfo('Previsão total de trabalho: ${_formatarDuracao(_duracaoTurno1 + _duracaoTurno2)}'));
      } else if (pontosDoDia.length == 2) {
        final saldoTurno2 = _duracaoTurno1 - duracaoTurno1;
        final duracaoTurno2Ajustada = _duracaoTurno2 + saldoTurno2;
        widgets.add(_criarInfo('Intervalo de ${_formatarDuracao(_intervalo)}'));
        widgets.add(_criarPrevisaoItem(pontosDoDia[1].data!.add(_intervalo), 'Previsão de retorno do intervalo', Icons.login, Colors.green));
        widgets.add(_criarInfo('Turno 2 de ${_formatarDuracao(duracaoTurno2Ajustada)}'));
        widgets.add(_criarPrevisaoItem(pontosDoDia[1].data!.add(_intervalo).add(duracaoTurno2Ajustada), 'Previsão de saída (do dia seguinte)', Icons.logout, Colors.red));
        widgets.add(_criarInfo('Previsão total de trabalho: ${_formatarDuracao(_duracaoTurno1 + _duracaoTurno2)}'));
        widgets.add(_criarInfo('Total trabalhado: ${_formatarDuracao(duracaoTurno1)}'));
      } else if (pontosDoDia.length == 3) {
        final saldoTurno2 = _duracaoTurno1 - duracaoTurno1;
        final duracaoTurno2Ajustada = _duracaoTurno2 + saldoTurno2;
        widgets.add(_criarInfo('Turno 2 de ${_formatarDuracao(duracaoTurno2Ajustada)}'));
        widgets.add(_criarPrevisaoItem(pontosDoDia[2].data!.add(duracaoTurno2Ajustada), 'Previsão de saída (do dia seguinte)', Icons.logout, Colors.red));
        widgets.add(_criarInfo('Previsão total de trabalho: ${_formatarDuracao(_duracaoTurno1 + _duracaoTurno2)}'));
        widgets.add(_criarInfo('Total trabalhado: ${_formatarDuracao(duracaoTurno1)}'));
      } else {
        widgets.add(_criarPrevisoes(pontosDoDia));
      }
    }
    return ListView(children: widgets);
  }

  Widget _criarMarcacao(Ponto ponto, bool isEntrada) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
      if (value == 'ver') {
        _mostrarPonto(ponto);
      } else if (value == 'editar') {
          _abrirForm(pontoAtual: ponto, indice: Provider.of<PontoProvider>(context, listen: false).pontos.indexOf(ponto));
        } else if (value == 'excluir') {
          _excluirPonto(Provider.of<PontoProvider>(context, listen: false).pontos.indexOf(ponto));
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
      const PopupMenuItem<String>(
        value: 'ver',
        child: ListTile(
          leading: Icon(Icons.visibility),
          title: Text('Ver'),
        ),
      ),
        const PopupMenuItem<String>(
          value: 'editar',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Editar'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'excluir',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Excluir'),
          ),
        ),
      ],
      child: ListTile(
        leading: Icon(
          isEntrada ? Icons.login : Icons.logout,
          color: isEntrada ? Colors.green : Colors.red,
        ),
        title: Text(
          DateFormat('HH:mm').format(ponto.data!),
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          isEntrada ? 'Entrada' : 'Saída',
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

void _mostrarPonto(Ponto ponto) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Detalhes do Ponto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data: ${DateFormat('dd/MM/yyyy').format(ponto.data!)}'),
            Text('Hora: ${DateFormat('HH:mm').format(ponto.data!)}'),
            Text('Latitude: ${ponto.latitude ?? 'N/A'}'),
            Text('Longitude: ${ponto.longitude ?? 'N/A'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Fechar'),
          ),
        ],
      );
    },
  );
}

  Widget _criarInfo(String texto) {
    return ListTile(
      title: Text(
        texto,
        style: TextStyle(color: Colors.white70),
      ),
    );
  }

  Widget _criarPrevisoes(List<Ponto> pontosDoDia) {
    final agora = DateTime.now();
    DateTime horaInicio1;
    DateTime horaFim1;
    DateTime horaInicio2;
    DateTime horaFim2;

    if (pontosDoDia.isNotEmpty) {
      horaInicio1 = pontosDoDia[0].data!;
      horaFim1 = pontosDoDia.length > 1 ? pontosDoDia[1].data! : horaInicio1.add(_duracaoTurno1);
      horaInicio2 = pontosDoDia.length > 2 ? pontosDoDia[2].data! : horaFim1.add(_intervalo);
      horaFim2 = pontosDoDia.length > 3 ? pontosDoDia[3].data! : horaInicio2.add(_duracaoTurno2);
    } else {
      horaInicio1 = agora;
      horaFim1 = horaInicio1.add(_duracaoTurno1);
      horaInicio2 = horaFim1.add(_intervalo);
      horaFim2 = horaInicio2.add(_duracaoTurno2);
    }

    final previsaoTurno1 = horaFim1.difference(horaInicio1);
    final previsaoIntervalo = horaInicio2.difference(horaFim1);
    final previsaoTurno2 = horaFim2.difference(horaInicio2);
    final previsaoTotal = previsaoTurno1 + previsaoTurno2;

    return Column(
      children: [
        if (pontosDoDia.length < 1)
          _criarPrevisaoItem(horaInicio1, 'Previsão de entrada', Icons.login, Colors.green),
        ListTile(
          title: Text(
            'Turno 1 de ${_formatarDuracao(previsaoTurno1)}',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        if (pontosDoDia.length < 2)
          _criarPrevisaoItem(horaFim1, 'Previsão de saída', Icons.logout, Colors.red),
        ListTile(
          title: Text(
            'Intervalo de ${_formatarDuracao(previsaoIntervalo)}',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        if (pontosDoDia.length < 3)
          _criarPrevisaoItem(horaInicio2, 'Previsão de retorno do intervalo', Icons.login, Colors.green),
        ListTile(
          title: Text(
            'Turno 2 de ${_formatarDuracao(previsaoTurno2)}',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        if (pontosDoDia.length < 4)
          _criarPrevisaoItem(horaFim2, 'Previsão de saída', Icons.logout, Colors.red),
        ListTile(
          title: Text(
            'Previsão total de trabalho: ${_formatarDuracao(previsaoTotal)}',
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _criarPrevisaoItem(DateTime hora, String descricao, IconData icone, Color cor) {
    final agora = DateTime.now();
    final isDiaSeguinte = hora.isAfter(DateTime(agora.year, agora.month, agora.day, 23, 59));

    return ListTile(
      leading: Icon(icone, color: cor.withOpacity(0.5)),
      title: Text(
        DateFormat('HH:mm').format(hora),
        style: TextStyle(color: Colors.white70),
      ),
      subtitle: Text(
        isDiaSeguinte ? '$descricao (do dia seguinte)' : descricao,
        style: TextStyle(color: Colors.white70),
      ),
    );
  }

  DateTime _parseHora(String hora, DateTime base) {
    final partes = hora.split(':');
    if (partes.length != 2) return base;
    final horas = int.tryParse(partes[0]) ?? base.hour;
    final minutos = int.tryParse(partes[1]) ?? base.minute;
    return DateTime(base.year, base.month, base.day, horas, minutos);
  }

  Duration _calcularDuracao(String inicio, String fim) {
    final inicioTime = _parseHora(inicio, DateTime.now());
    final fimTime = _parseHora(fim, DateTime.now());
    return fimTime.difference(inicioTime);
  }

  void _abrirForm({Ponto? pontoAtual, int? indice}) {
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(pontoAtual == null ? 'Novo Ponto' : 'Alterar Ponto ${pontoAtual?.id}'),
          content: ConteudoFormDialog(key: key, pontoAtual: pontoAtual, podeEditar: pontoAtual != null),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (key.currentState!.dadosValidados() && key.currentState != null) {
                    final novoPonto = key.currentState!.novoPonto;
                    if (indice == null) {
                      novoPonto.id = 0; // Ensure the ID is 0 for new points
                      await Provider.of<PontoProvider>(context, listen: false).adicionarPonto(novoPonto);
                    } else {
                      novoPonto.id = Provider.of<PontoProvider>(context, listen: false).pontos[indice].id;
                      await Provider.of<PontoProvider>(context, listen: false).adicionarPonto(novoPonto);
                    }
                  Navigator.of(context).pop();
                  await _carregarPontos(); // Reload after saving
                }
              },
              child: Text('Salvar'),
            )
          ],
        );
      },
    );
  }

  void _excluirPonto(int indice) async {
    if (indice >= 0 && indice < Provider.of<PontoProvider>(context, listen: false).pontos.length) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Excluir Ponto'),
            content: const Text('Você tem certeza que deseja excluir este ponto?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  await Provider.of<PontoProvider>(context, listen: false).removerPonto(
                      Provider.of<PontoProvider>(context, listen: false).pontos[indice].id,
                    );
                  Navigator.of(context).pop();
                  await _carregarPontos(); // Reload after deleting
                },
                child: const Text('Excluir'),
              )
            ],
          );
        },
      );
    }
  }
}
