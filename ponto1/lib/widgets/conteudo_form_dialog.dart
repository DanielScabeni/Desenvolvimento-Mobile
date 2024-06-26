import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ponto1/model/ponto.dart';
import 'package:geolocator/geolocator.dart';

class ConteudoFormDialog extends StatefulWidget {
  final Ponto? pontoAtual;
  final bool podeEditar;

  ConteudoFormDialog({Key? key, this.pontoAtual, this.podeEditar = false}) : super(key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog> {
  final formKey = GlobalKey<FormState>();

  late DateTime dataHoraAtual;
  late String dataFormatada;
  late String horaFormatada;
  late DateTime diaDeTrabalho;
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    dataHoraAtual = widget.pontoAtual?.data ?? DateTime.now();
    diaDeTrabalho = widget.pontoAtual?.diaDeTrabalho ?? DateTime.now();
    dataFormatada = DateFormat('dd/MM/yyyy').format(dataHoraAtual);
    horaFormatada = DateFormat('HH:mm').format(dataHoraAtual);
    latitude = widget.pontoAtual?.latitude;
    longitude = widget.pontoAtual?.longitude;

    if (widget.pontoAtual == null) {
      _obterLocalizacaoAtual();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: DateFormat('dd/MM/yyyy').format(diaDeTrabalho),
            decoration: InputDecoration(labelText: 'Dia de Trabalho'),
            readOnly: true,
            onTap: () async {
              DateTime? novaData = await showDatePicker(
                context: context,
                initialDate: diaDeTrabalho,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (novaData != null) {
                setState(() {
                  diaDeTrabalho = novaData;
                });
              }
            },
          ),
          SizedBox(height: 16),
          Text('Ponto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (widget.podeEditar)
            TextFormField(
              initialValue: dataFormatada,
              decoration: InputDecoration(labelText: 'Data'),
              readOnly: !widget.podeEditar,
              onTap: () async {
                if (widget.podeEditar) {
                  DateTime? novaData = await showDatePicker(
                    context: context,
                    initialDate: dataHoraAtual,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (novaData != null) {
                    setState(() {
                      dataHoraAtual = DateTime(
                        novaData.year,
                        novaData.month,
                        novaData.day,
                        dataHoraAtual.hour,
                        dataHoraAtual.minute,
                      );
                      dataFormatada = DateFormat('dd/MM/yyyy').format(dataHoraAtual);
                    });
                  }
                }
              },
            ),
          if (widget.podeEditar)
            TextFormField(
              initialValue: horaFormatada,
              decoration: InputDecoration(labelText: 'Hora'),
              readOnly: !widget.podeEditar,
              onTap: () async {
                if (widget.podeEditar) {
                  TimeOfDay? novaHora = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(dataHoraAtual),
                  );
                  if (novaHora != null) {
                    setState(() {
                      dataHoraAtual = DateTime(
                        dataHoraAtual.year,
                        dataHoraAtual.month,
                        dataHoraAtual.day,
                        novaHora.hour,
                        novaHora.minute,
                      );
                      horaFormatada = DateFormat('HH:mm').format(dataHoraAtual);
                    });
                  }
                }
              },
            ),
          if (!widget.podeEditar)
            Text(
              'Data: $dataFormatada',
              style: TextStyle(fontSize: 20),
            ),
          if (!widget.podeEditar)
            SizedBox(height: 8),
          if (!widget.podeEditar)
            Text(
              'Hora: $horaFormatada',
              style: TextStyle(fontSize: 20),
            ),
          SizedBox(height: 16),
          Text('Lat.: ${latitude ?? 'N/A'}'),
          Text('Long.: ${longitude ?? 'N/A'}'),
          if (widget.podeEditar)
            ElevatedButton(
              onPressed: _atualizarLocalizacao,
              child: Text('Atualizar Localização'),
            ),
        ],
      ),
    );
  }

  bool dadosValidados() => formKey.currentState?.validate() == true;

  Ponto get novoPonto {
    return Ponto(
      id: widget.pontoAtual?.id ?? 0,
      data: dataHoraAtual,
      hora: [horaFormatada],
      diaDeTrabalho: diaDeTrabalho,
      latitude: latitude,
      longitude: longitude,
    );
  }

  void _atualizarLocalizacao() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      await _mostrarDialogMensagem('Para utilizar esse serviço, você deverá '
          'habilitar o serviço de localização do dispositivo.');
      Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        _mostrarMensagem(
            'Não será possível usar o recurso por falta de permissão');
        return;
      }
    }
    if (permissao == LocationPermission.deniedForever) {
      await _mostrarDialogMensagem('Para utilizar esse recurso, você deverá acessar as configurações'
          ' do app e permitir a utilização do serviço de localização');
      Geolocator.openAppSettings();
      return;
    }

    Position posicaoAtual = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitude = posicaoAtual.latitude;
      longitude = posicaoAtual.longitude;
    });
  }

  void _obterLocalizacaoAtual() async {
    bool servicoHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicoHabilitado) {
      await _mostrarDialogMensagem('Para utilizar esse serviço, você deverá '
          'habilitar o serviço de localização do dispositivo.');
      Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        _mostrarMensagem(
            'Não será possível usar o recurso por falta de permissão');
        return;
      }
    }
    if (permissao == LocationPermission.deniedForever) {
      await _mostrarDialogMensagem('Para utilizar esse recurso, você deverá acessar as configurações'
          ' do app e permitir a utilização do serviço de localização');
      Geolocator.openAppSettings();
      return;
    }

    Position posicaoAtual = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      latitude = posicaoAtual.latitude;
      longitude = posicaoAtual.longitude;
    });
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
                child: const Text('OK')
            )
          ],
        )
    );
  }
}
