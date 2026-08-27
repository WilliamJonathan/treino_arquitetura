import 'package:flutter/material.dart';
import 'package:treino_arquitetura/app/pages/consultar_cep/interfaces/i_consultar_cep_services.dart';
import 'package:treino_arquitetura/app/pages/consultar_cep/services/consultar_cep_services.dart';
import 'package:treino_arquitetura/utils/generic_states.dart';

class ConsultarCepPageStore extends ChangeNotifier {
  final IConsultarCepServices _consultarCepServices = ConsultarCepServices.instance;

  GenericStates _state = EmptyGenericState();
  GenericStates get state => _state;
  set state(GenericStates value) {
    _state = value;
    notifyListeners();
  }

  Future<void> buscarPorCep(String cep) async {
    state = LoadingGenericState();
    final result = await _consultarCepServices.buscarPorCep(cep);
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

  void limpar() {
    state = EmptyGenericState();
  }
}
