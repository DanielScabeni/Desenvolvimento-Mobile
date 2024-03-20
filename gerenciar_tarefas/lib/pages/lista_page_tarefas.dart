

import 'package:flutter/material.dart';
import 'package:gerenciar_tarefas/model/tarefa.dart';
import 'package:gerenciar_tarefas/widgets/conteudo_form_dialog.dart';

class ListaTarefaPage extends StatefulWidget{

  @override
  _ListaTarefaPageState createState() => _ListaTarefaPageState();
}

class _ListaTarefaPageState extends State<ListaTarefaPage>{

  final _tarefas = <Tarefa> [];
  var _ultimoId = 1;

  static const ACAO_EDITAR = 'edit';

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _criarAppBar(context),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        child: Icon(Icons.add),
        tooltip: 'Nova Tarefa',
      ),
    );
  }

  AppBar _criarAppBar(BuildContext context){
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: Text('Tarefas'),
      centerTitle: false,
      actions: const [
        IconButton(
            onPressed: null,
            icon: Icon(Icons.filter_list)
        )
      ],
    );
  }

  Widget _criarBody(){

    if(_tarefas.isEmpty){
      return const Center(
        child: Text('Tudo certo por aqui',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.separated(
      itemBuilder: (BuildContext context, int index){
        final tarefa = _tarefas[index];
        return PopupMenuButton<String>(
            child: ListTile(
              title: Text('${tarefa.id} - ${tarefa.descricao}'),
              subtitle: Text(tarefa.prazoFormatado == ''? 'Sem prazo definido' : 'Prazo - ${tarefa.prazoFormatado}'),
            ),
            itemBuilder: (BuildContext context) => criarItensMenuPopUp(),
          onSelected: (String valorSelecionado){
              if(valorSelecionado == ACAO_EDITAR){
                _abrirForm(tarefaAtual: tarefa, indice: index);
              }
          },
        );
    }, 
      separatorBuilder: (BuildContext context, index) => const Divider(),
      itemCount: _tarefas.length,
    );
  }

  List<PopupMenuEntry<String>> criarItensMenuPopUp(){
    return [
      PopupMenuItem(
        value: ACAO_EDITAR,
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.black),
              Padding(
                  padding: EdgeInsets.only(left: 10),
                child: Text('Editar'),
              )
            ],
          )
      )
    ];
  }

  void _abrirForm({Tarefa? tarefaAtual, int? indice}){
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(tarefaAtual == null ? 'Nova tarefa' : 'Alterar Tarefa ${tarefaAtual.id}'),
          content: ConteudoFormDialog(key: key, tarefaAtual: tarefaAtual,),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
            ),
            TextButton(
                onPressed: () {
                  if (key.currentState!.dadosValidados() &&
                  key.currentState != null){
                    setState(() {
                      final novaTarefa = key.currentState!.novaTarefa;
                      if(indice == null){
                        novaTarefa.id = ++ _ultimoId;
                        _tarefas.add(novaTarefa);
                      }else{
                        _tarefas[indice] = novaTarefa;
                      }
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Salvar'),
            )
          ],
        );
      }
    );
  }
}