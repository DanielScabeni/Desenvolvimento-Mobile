
import 'package:flutter/material.dart';
import 'package:ponto1/model/ponto.dart';
import 'package:ponto1/widgets/conteudo_form_dialog.dart';

class ListaPontoPage extends StatefulWidget{

  @override
  _ListaPontoPageState createState() => _ListaPontoPageState();
}

class _ListaPontoPageState extends State<ListaPontoPage>{

  int _selectedIndex = 0;
  final _pontos = <Ponto> [];
  var _ultimoId = 0;

  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _navegarParaListaDePontos(); // Implementar esta função
      }
    });
  }

  @override
  Widget build(BuildContext context){
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
    );
  }

  AppBar _criarAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white, // Isso define a cor do texto e ícones no AppBar para branco
      title: const Text('Ponto'),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: _abrirForm, // A ação que era realizada pelo FAB agora é atribuída a este botão
          icon: const Icon(Icons.add), // Ícone de '+'
        ),
      ],
    );
  }

  Widget _criarBody(){
    if(_pontos.isEmpty){
      return const Center(
        child: Text('Tudo certo por aqui',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView.separated(
      itemBuilder: (BuildContext context, int index){
        final ponto = _pontos[index];
        return PopupMenuButton<String>(
            child: ListTile(
              title: Text('${ponto.id} - ${ponto.descricao}'),
              subtitle: Text(ponto.dataFormatada == ''? 'Sem data definido' : 'Data - ${ponto.dataFormatada}'),
            ),
            itemBuilder: (BuildContext context) => criarItensMenuPopUp(),
          onSelected: (String valorSelecionado){
              if (valorSelecionado == ACAO_EDITAR){
                _abrirForm(pontoAtual: ponto, indice: index);
              }else{
                _excluir(index);
              }
          },
        );
    }, 
      separatorBuilder: (BuildContext context, int index) => const Divider(),
      itemCount: _pontos.length,
    );
  }


  List<PopupMenuEntry<String>> criarItensMenuPopUp(){
    return [
      const PopupMenuItem(
          value: ACAO_EDITAR,
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.blueGrey),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Editar'),
              )
            ],
          )
      ),
      const PopupMenuItem(
          value: ACAO_EXCLUIR,
          child: Row(
            children: [
              Icon(Icons.cancel_outlined, color: Colors.red),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('Excluir'),
              )
            ],
          )
      )
    ];
  }

  Future _excluir(int indice){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return  AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.warning_amber_outlined, color: Colors.orangeAccent),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Atenção', style: TextStyle(color: Colors.red),),
                )
              ],
            ),
            content: const Text('Esse registro será excluido PERMANENTEMENTE!!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar', style: TextStyle(color: Colors.green)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _pontos.removeAt(indice);
                    });
                  },
                child: Text('Excluir'),
              )
            ],
          );
        }
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _navegarParaListaDePontos(); // Implementar esta função
      }
    });
  }

  void _abrirForm({Ponto? pontoAtual, int? indice}){
    final key = GlobalKey<ConteudoFormDialogState>();
    final agora = DateTime.now();
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(pontoAtual == null ? 'Novo Ponto' : 'Alterar Ponto ${pontoAtual.id}'),
          content: ConteudoFormDialog(key: key, pontoAtual: pontoAtual),
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
                      final novoPonto = key.currentState!.novoPonto;
                      if( indice == null){
                        novoPonto.id = ++ _ultimoId;
                        _pontos.add(novoPonto);
                      }else{
                        _pontos[indice] = novoPonto;
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