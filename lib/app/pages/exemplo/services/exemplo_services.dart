import 'package:treino_arquitetura/app/pages/exemplo/interfaces/i_exemplo_services.dart';
import 'package:treino_arquitetura/app/pages/exemplo/models/exemplo_model.dart';
import 'package:treino_arquitetura/utils/result_state.dart';

class ExemploServices implements IExemploServices {
  // Padrão singleton, para evitar que sejam criadas várias instâncias do ExemploServices,
  // e para facilitar o acesso aos serviços em toda a aplicação.
  static final ExemploServices _instance = ExemploServices._internal();

  factory ExemploServices() => _instance;

  static ExemploServices get instance => _instance;

  ExemploServices._internal();

  @override
  Future<ResultState<void>> destroy(int id) async {
    // TODO: implement destroy
    throw UnimplementedError();
  }

  @override
  Future<ResultState<List<ExemploModel>>> index() async {
    // TODO: implement index
    throw UnimplementedError();
  }

  @override
  Future<ResultState<ExemploModel>> show(int id) async {
    // TODO: implement show
    throw UnimplementedError();
  }

  @override
  Future<ResultState<ExemploModel>> store(Map<String, dynamic> data) async {
    // TODO: implement store
    throw UnimplementedError();
  }

  @override
  Future<ResultState<ExemploModel>> update(
    int id,
    Map<String, dynamic> data,
  ) async {
    // TODO: implement update
    throw UnimplementedError();
  }
}
