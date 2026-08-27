import 'package:treino_arquitetura/app/pages/exemplo/models/exemplo_model.dart';
import 'package:treino_arquitetura/utils/result_state.dart';

abstract class IExemploServices {
  Future<ResultState<List<ExemploModel>>> index();
  Future<ResultState<ExemploModel>> show(int id);
  Future<ResultState<ExemploModel>> store(ExemploModel data);
  Future<ResultState<ExemploModel>> update(ExemploModel data);
  Future<ResultState<void>> destroy(int id);
}
