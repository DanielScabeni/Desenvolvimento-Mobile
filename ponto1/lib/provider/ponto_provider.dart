import 'package:flutter/material.dart';
import 'package:ponto1/database/ponto_dao.dart';
import 'package:ponto1/model/ponto.dart';

class PontoProvider extends ChangeNotifier {
  final PontoDao _pontoDao = PontoDao();
  List<Ponto> _pontos = [];
  int _ultimoId = 0;

  List<Ponto> get pontos => _pontos;

  int get ultimoId => _ultimoId;

  set ultimoId(int value) {
    _ultimoId = value;
  }

  PontoProvider() {
    carregarPontos();
  }

  Future<void> carregarPontos() async {
    _pontos = await _pontoDao.listar();
    if (_pontos.isNotEmpty) {
      _ultimoId = _pontos.last.id;
    } else {
      _ultimoId = 0;
    }
    notifyListeners();
  }

  Future<void> adicionarPonto(Ponto ponto) async {
    await _pontoDao.salvar(ponto);
    await carregarPontos();
  }

  Future<void> removerPonto(int id) async {
    await _pontoDao.remover(id);
    await carregarPontos();
  }

  Future<void> salvarPontos() async {
    for (var ponto in _pontos) {
      await _pontoDao.salvar(ponto);
    }
    notifyListeners();
  }
}
