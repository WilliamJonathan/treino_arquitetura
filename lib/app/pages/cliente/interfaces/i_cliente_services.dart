import 'package:treino_arquitetura/app/pages/cliente/models/cliente_model.dart';
import 'package:treino_arquitetura/utils/result_state.dart';

abstract class IClienteServices {
  Future<ResultState<List<ClienteModel>>> index();
  Future<ResultState<ClienteModel>> show(int id);
  Future<ResultState<ClienteModel>> store(ClienteModel data);
  Future<ResultState<ClienteModel>> update(ClienteModel data);
  Future<ResultState<void>> destroy(int id);
}
