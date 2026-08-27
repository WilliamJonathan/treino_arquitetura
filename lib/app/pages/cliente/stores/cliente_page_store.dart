import 'package:flutter/material.dart';
import 'package:treino_arquitetura/app/pages/cliente/interfaces/i_cliente_services.dart';
import 'package:treino_arquitetura/app/pages/cliente/models/cliente_model.dart';
import 'package:treino_arquitetura/app/pages/cliente/services/cliente_services.dart';
import 'package:treino_arquitetura/utils/generic_states.dart';

class ClientePageStore extends ChangeNotifier {
  final IClienteServices _clienteServices = ClienteServices.instance;

  GenericStates _state = EmptyGenericState();
  GenericStates get state => _state;
  set state(GenericStates value) {
    _state = value;
    notifyListeners();
  }

  String? _mensagemAcao;
  String? get mensagemAcao => _mensagemAcao;

  Future<void> index() async {
    state = LoadingGenericState();
    final result = await _clienteServices.index();
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

  Future<bool> store(ClienteModel data) async {
    final result = await _clienteServices.store(data);
    var ok = false;
    result.fold(
      onSuccess: (_) {
        _mensagemAcao = 'Cliente criado com sucesso';
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

  Future<bool> update(ClienteModel data) async {
    final result = await _clienteServices.update(data);
    var ok = false;
    result.fold(
      onSuccess: (_) {
        _mensagemAcao = 'Cliente atualizado com sucesso';
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

  Future<bool> destroy(int id) async {
    final result = await _clienteServices.destroy(id);
    var ok = false;
    result.fold(
      onSuccess: (_) {
        _mensagemAcao = 'Cliente excluído com sucesso';
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
