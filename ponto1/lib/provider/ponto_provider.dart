import 'package:flutter/material.dart';
import 'package:ponto1/database/ponto_dao.dart';
import 'package:ponto1/model/ponto.dart';

class PontoProvider extends ChangeNotifier {
  final PontoDao _pontoDao = PontoDao();
  List<Ponto> _pontos = [];
  int _ultimoId = 0;

  List<Ponto> get pontos => _pontos;

  PontoProvider() {
    _carregarPontos();
  }

  Future<void> _carregarPontos() async {
    _pontos = await _pontoDao.listar();
    _ultimoId = _pontos.isNotEmpty ? _pontos.last.id : 0;
    notifyListeners();
  }

  Future<void> adicionarPonto(Ponto ponto) async {
    await _pontoDao.salvar(ponto);
    await _carregarPontos();
  }

  Future<void> removerPonto(int id) async {
    await _pontoDao.remover(id);
    await _carregarPontos();
  }

  int get ultimoId => _ultimoId;
  set ultimoId(int value) {
    _ultimoId = value;
    notifyListeners();
  }

  Future<void> salvarPontos() async {
    for (var ponto in _pontos) {
      await _pontoDao.salvar(ponto);
    }
    notifyListeners();
  }
}
