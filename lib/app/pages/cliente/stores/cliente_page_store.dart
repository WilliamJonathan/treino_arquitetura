import 'package:flutter/material.dart';
import 'package:treino_arquitetura/app/pages/cliente/interfaces/i_cliente_services.dart';
import 'package:treino_arquitetura/app/pages/cliente/models/cliente_model.dart';
import 'package:treino_arquitetura/app/pages/cliente/services/cliente_services.dart';
import 'package:treino_arquitetura/utils/generic_states.dart';

/// Desafio 03 — implemente a Store consumindo [ClienteServices] (fake API pronta).
///
/// Espelhe: `exemplo_page_store.dart` e `consultar_cep_page_store.dart`.
class ClientePageStore extends ChangeNotifier {
  // ignore: unused_field - o estagiário usa este service nos TODOs abaixo
  final IClienteServices _clienteServices = ClienteServices.instance;

  GenericStates _state = EmptyGenericState();
  GenericStates get state => _state;
  set state(GenericStates value) {
    _state = value;
    notifyListeners();
  }

  String? _mensagemAcao;
  String? get mensagemAcao => _mensagemAcao;

  /// Lista todos os clientes.
  Future<void> index() async {
    // TODO(estagiário):
    // 1. state = LoadingGenericState()
    // 2. chamar _clienteServices.index()
    // 3. result.fold → SuccessGenericState / ErrorGenericState / EmptyGenericState
  }

  /// Cria um cliente. Retorne true se deu certo.
  Future<bool> store(ClienteModel data) async {
    // TODO(estagiário):
    // 1. chamar _clienteServices.store(data)
    // 2. preencher _mensagemAcao
    // 3. se sucesso, chamar await index() e retornar true
    return false;
  }

  /// Atualiza um cliente. Retorne true se deu certo.
  Future<bool> update(ClienteModel data) async {
    // TODO(estagiário): espelhe store(), usando _clienteServices.update
    return false;
  }

  /// Exclui um cliente pelo id. Retorne true se deu certo.
  Future<bool> destroy(int id) async {
    // TODO(estagiário): espelhe store(), usando _clienteServices.destroy
    return false;
  }
}
