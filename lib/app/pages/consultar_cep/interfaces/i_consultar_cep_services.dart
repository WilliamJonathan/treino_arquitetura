import 'package:treino_arquitetura/app/pages/consultar_cep/models/endereco_model.dart';
import 'package:treino_arquitetura/utils/result_state.dart';

abstract class IConsultarCepServices {
  /// Busca endereço pelo CEP na API ViaCEP.
  ///
  /// Endpoint de referência:
  /// `https://viacep.com.br/ws/{cep}/json/`
  Future<ResultState<EnderecoModel>> buscarPorCep(String cep);
}
