import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/ponto.dart';

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

  @override
  void initState() {
    super.initState();
    dataHoraAtual = widget.pontoAtual?.data ?? DateTime.now();
    dataFormatada = DateFormat('dd/MM/yyyy').format(dataHoraAtual);
    horaFormatada = DateFormat('HH:mm').format(dataHoraAtual);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
        ],
      ),
    );
  }

  bool dadosValidados() => formKey.currentState?.validate() == true;

  Ponto get novoPonto {
    return Ponto(
      id: widget.pontoAtual?.id ?? 0,
      descricao: '',
      data: dataHoraAtual,
      horas: [horaFormatada],
    );
  }
}
