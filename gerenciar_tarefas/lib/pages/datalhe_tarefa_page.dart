
import 'package:flutter/material.dart';
import 'package:gerenciar_tarefas/model/tarefa.dart';

class DetalheTarefaPage extends StatefulWidget{
  final Tarefa tarefa;

  const DetalheTarefaPage({Key? key, required this.tarefa }) : super(key: key);


  @override
  DetalheTarefaPageState createState() => DetalheTarefaPageState();

}

class DetalheTarefaPageState extends State<DetalheTarefaPage>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Detalhes da Tarefa'),
        centerTitle: false,
      ),
      body: _criarBody(),
    );
  }

  Widget _criarBody() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: [
          Row(
            children: [
              const Campo(descricao: 'Código:'),
              Valor(valor: '${widget.tarefa.id}'),
            ],
          ),
          Row(
            children: [
              const Campo(descricao: 'Descrição:'),
              Valor(valor: '${widget.tarefa.descricao}'),
            ],
          ),
          Row(
            children: [
              const Campo(descricao: 'Prazo:'),
              Valor(valor: '${widget.tarefa.prazoFormatado}'),
            ],
          ),
          Row(
            children: [
              const Campo(descricao: 'Finalizada:'),
              Valor(valor: widget.tarefa.finalizada ? 'SIM' : 'NÃO'),
            ],
          ),
        ],
      ),
    );
  }

}

class Campo extends StatelessWidget{
  final String descricao;

  const Campo({Key? key, required this.descricao}): super(key: key);

  @override
  Widget build(BuildContext context){
    return Expanded(
      flex: 1,
      child: Text(descricao,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class Valor extends StatelessWidget{
  final String valor;

  const Valor({Key? key, required this.valor}): super(key: key);

  @override
  Widget build(BuildContext context){
    return Expanded(
      flex: 4,
      child: Text(valor == '' ? 'Sem valor' : valor),
    );
  }
}