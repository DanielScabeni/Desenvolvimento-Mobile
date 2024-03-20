
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  @override
  Widget build (BuildContext context){
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
    );
  }

  AppBar _criarAppBar(){
    return AppBar(
      centerTitle: false,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: const Text('Atividade Interface'),
      actions: [
        IconButton(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.sync)
        )
      ],
    );
  }

  Widget _criarBody(){
    return ListView(
      children: [
        for (int i = 0; i < (Random().nextInt(30) + 5); i++)
          Row(
            children: [
              for (int j = 0; j < (Random().nextInt(6) +3); j++)
                Expanded(
                    child: CustomCard(label: 'Linha ${i+1} | Coluna ${j+1}',)
                )
            ],
          )
      ],
    );
  }
}

class CustomCard extends StatelessWidget{
  final String label;

  const CustomCard({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Card(
      color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
      child: SizedBox(
        height: 80,
        child:  Center(
          child: Text(label),
        ),
      ),
    );
  }

}