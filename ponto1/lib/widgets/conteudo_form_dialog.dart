
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/ponto.dart';

class ConteudoFormDialog extends StatefulWidget{
  final Ponto? pontoAtual;

  ConteudoFormDialog({ Key? key, this.pontoAtual}) : super(key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog>{

  final formKey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  final dataController = TextEditingController();

  late String dataFormatada;
  late String horaFormatada;

  @override
  void initState(){
    super.initState();

    final agora = DateTime.now();
    dataFormatada = DateFormat('dd/MM/yyyy').format(agora);
    horaFormatada = DateFormat('HH:mm:ss').format(agora);

    if (widget.pontoAtual != null){
      descricaoController.text = widget.pontoAtual!.descricao;
      dataController.text = widget.pontoAtual!.dataFormatada;
    }
  }

  @override
  Widget build(BuildContext context){
    return Form(
      key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Hora: $horaFormatada'),
            Text('Data: $dataFormatada'),
          ],
        )
    );
  }
  
  void _mostraCalendario() {
    final dataFormatada = dataController.text;
    var data = DateTime.now();


  }

  bool dadosValidados() => formKey.currentState?.validate() == true;

  Ponto get novoPonto {
    final agora = DateTime.now();
    return Ponto(
      id: widget.pontoAtual?.id ?? 0,
      descricao: descricaoController.text,
      data: agora,
    );
  }
}