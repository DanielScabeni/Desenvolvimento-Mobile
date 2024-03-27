
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/tarefa.dart';

class ConteudoFormDialog extends StatefulWidget{
  final Tarefa? tarefaAtual;

  ConteudoFormDialog({ Key? key, this.tarefaAtual}) : super(key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog>{

  final formKey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  final prazoController = TextEditingController();
  final _prazoFormatado = DateFormat('dd/MM/yyyy');

  @override
  void initState(){
    super.initState();
    if (widget.tarefaAtual != null){
      descricaoController.text = widget.tarefaAtual!.descricao;
      prazoController.text = widget.tarefaAtual!.prazoFormatado;
    }
  }

  @override
  Widget build(BuildContext context){
    return Form(
      key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
              TextFormField(
                controller: descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (String? valor){
                  if (valor == null || valor.isEmpty){
                    return 'INFORME A DESCRIÇÃÃÃÃOOOOO!!!! aaaaaaa';
                  }
                  return null;
                },
              ),
            TextFormField(
              controller: prazoController,
              decoration: InputDecoration(
                labelText: 'Prazo',
                prefixIcon: IconButton(
                  icon: Icon(Icons.calendar_month),
                  onPressed: _mostraCalendario,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => prazoController.clear(),
                ),
              ),
              readOnly: true,
            )
          ],

        )
    );
  }
  
  void _mostraCalendario() {
    final dataFormatada = prazoController.text;
    var data = DateTime.now();

    if(dataFormatada.isNotEmpty){
      data = _prazoFormatado.parse(dataFormatada);
    }
    showDatePicker(
        context: context,
        initialDate: data,
        firstDate: data.subtract(Duration(days: 5 * 365)),
        lastDate: data.add(Duration(days: 5 * 365)),
    ).then((DateTime? dataSelecionada) {
      if (dataSelecionada != null){
        setState(() {
          prazoController.text = _prazoFormatado.format(dataSelecionada);
        });
      }
    });
  }

  bool dadosValidados() => formKey.currentState?.validate() == true;

  Tarefa get novaTarefa => Tarefa(
      id: widget.tarefaAtual?.id ?? 0,
      descricao: descricaoController.text,
      prazo: prazoController.text.isEmpty ? null :
      _prazoFormatado.parse(prazoController.text),
  );
}