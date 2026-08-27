import 'package:treino_arquitetura/app/pages/exemplo/interfaces/i_exemplo_services.dart';
import 'package:treino_arquitetura/app/pages/exemplo/models/exemplo_model.dart';
import 'package:treino_arquitetura/utils/result_state.dart';

/// CRUD em memória — referência para o estagiário.
///
/// Na tela de Clientes a ideia é a mesma, mas o Service usa SQLite (fake API).
class ExemploServices implements IExemploServices {
  // Padrão singleton, para evitar que sejam criadas várias instâncias do ExemploServices,
  // e para facilitar o acesso aos serviços em toda a aplicação.
  static final ExemploServices _instance = ExemploServices._internal();

  factory ExemploServices() => _instance;

  static ExemploServices get instance => _instance;

  ExemploServices._internal();

  /// Lista em memória (some ao fechar o app).
  final List<ExemploModel> _itens = [];
  int _proximoId = 1;

  @override
  Future<ResultState<List<ExemploModel>>> index() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (_itens.isEmpty) {
      return EmptyResultState();
    }

    return SuccessResultState(result: List<ExemploModel>.from(_itens));
  }

  @override
  Future<ResultState<ExemploModel>> show(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    try {
      final item = _itens.firstWhere((e) => e.id == id);
      return SuccessResultState(result: item);
    } catch (_) {
      return ErrorResultState(message: 'Item #$id não encontrado');
    }
  }

  @override
  Future<ResultState<ExemploModel>> store(ExemploModel data) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final titulo = data.titulo.trim();
    final descricao = data.descricao.trim();

    if (titulo.isEmpty || descricao.isEmpty) {
      return ErrorResultState(message: 'Título e descrição são obrigatórios');
    }

    final novo = ExemploModel(
      id: _proximoId++,
      titulo: titulo,
      descricao: descricao,
    );
    _itens.insert(0, novo);

    return SuccessResultState(result: novo);
  }

  @override
  Future<ResultState<ExemploModel>> update(ExemploModel data) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final titulo = data.titulo.trim();
    final descricao = data.descricao.trim();

    if (titulo.isEmpty || descricao.isEmpty) {
      return ErrorResultState(message: 'Título e descrição são obrigatórios');
    }

    final index = _itens.indexWhere((e) => e.id == data.id);
    if (index < 0) {
      return ErrorResultState(message: 'Item #${data.id} não encontrado');
    }

    final atualizado = ExemploModel(
      id: data.id,
      titulo: titulo,
      descricao: descricao,
    );
    _itens[index] = atualizado;

    return SuccessResultState(result: atualizado);
  }

  @override
  Future<ResultState<void>> destroy(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));

    final totalAntes = _itens.length;
    _itens.removeWhere((e) => e.id == id);

    if (_itens.length == totalAntes) {
      return ErrorResultState(message: 'Item #$id não encontrado');
    }

    return SuccessResultState(result: null);
  }
}
