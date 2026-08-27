import 'package:flutter/material.dart';
import 'package:treino_arquitetura/app/pages/exemplo/interfaces/i_exemplo_services.dart';
import 'package:treino_arquitetura/app/pages/exemplo/models/exemplo_model.dart';
import 'package:treino_arquitetura/app/pages/exemplo/services/exemplo_services.dart';
import 'package:treino_arquitetura/utils/generic_states.dart';

/// Store de referência: lista com GenericStates + ações de CRUD.
///
/// Use este arquivo como base para implementar `ClientePageStore`.
class ExemploPageStore extends ChangeNotifier {
  final IExemploServices _exemploServices = ExemploServices.instance;

  GenericStates _state = EmptyGenericState();
  GenericStates get state => _state;
  set state(GenericStates value) {
    _state = value;
    notifyListeners();
  }

  String? _mensagemAcao;
  String? get mensagemAcao => _mensagemAcao;

  /// Lista todos os itens.
  Future<void> index() async {
    state = LoadingGenericState();
    final result = await _exemploServices.index();
    result.fold(
      onSuccess: (data) {
        state = SuccessGenericState(data: data);
      },
      onError: (message) {
        state = ErrorGenericState(message: message);
      },
      onEmpty: () {
        state = EmptyGenericState();
      },
    );
  }

  /// Cadastra um item e recarrega a lista.
  Future<bool> store(ExemploModel data) async {
    final result = await _exemploServices.store(data);
    var ok = false;
    result.fold(
      onSuccess: (_) {
        _mensagemAcao = 'Item cadastrado com sucesso';
        ok = true;
      },
      onError: (message) {
        _mensagemAcao = message;
        ok = false;
      },
      onEmpty: () {
        _mensagemAcao = 'Nenhum dado retornado';
        ok = false;
      },
    );
    notifyListeners();
    if (ok) await index();
    return ok;
  }

  /// Atualiza um item e recarrega a lista.
  Future<bool> update(ExemploModel data) async {
    final result = await _exemploServices.update(data);
    var ok = false;
    result.fold(
      onSuccess: (_) {
        _mensagemAcao = 'Item atualizado com sucesso';
        ok = true;
      },
      onError: (message) {
        _mensagemAcao = message;
        ok = false;
      },
      onEmpty: () {
        _mensagemAcao = 'Nenhum dado retornado';
        ok = false;
      },
    );
    notifyListeners();
    if (ok) await index();
    return ok;
  }

  /// Remove um item e recarrega a lista.
  Future<bool> destroy(int id) async {
    final result = await _exemploServices.destroy(id);
    var ok = false;
    result.fold(
      onSuccess: (_) {
        _mensagemAcao = 'Item excluído com sucesso';
        ok = true;
      },
      onError: (message) {
        _mensagemAcao = message;
        ok = false;
      },
      onEmpty: () {
        _mensagemAcao = 'Nenhum dado retornado';
        ok = false;
      },
    );
    notifyListeners();
    if (ok) await index();
    return ok;
  }
}
