import 'package:treino_arquitetura/app/pages/cliente/interfaces/i_cliente_services.dart';
import 'package:treino_arquitetura/app/pages/cliente/models/cliente_model.dart';
import 'package:treino_arquitetura/app/pages/cliente/services/cliente_database.dart';
import 'package:treino_arquitetura/utils/result_state.dart';

/// Fake API de clientes usando SQLite local.
///
/// Mantém o mesmo contrato da arquitetura (index/show/store/update/destroy)
/// como se fosse um backend HTTP.
class ClienteServices implements IClienteServices {
  static final ClienteServices _instance = ClienteServices._internal();

  factory ClienteServices() => _instance;

  static ClienteServices get instance => _instance;

  ClienteServices._internal();

  final ClienteDatabase _database = ClienteDatabase.instance;

  @override
  Future<ResultState<List<ClienteModel>>> index() async {
    try {
      final db = await _database.database;
      final rows = await db.query('clientes', orderBy: 'id DESC');

      if (rows.isEmpty) {
        return EmptyResultState();
      }

      final clientes = rows
          .map((row) => ClienteModel.fromJson(Map<String, dynamic>.from(row)))
          .toList();
      return SuccessResultState(result: clientes);
    } catch (e) {
      return ErrorResultState(message: 'Falha ao listar clientes: $e');
    }
  }

  @override
  Future<ResultState<ClienteModel>> show(int id) async {
    try {
      final db = await _database.database;
      final rows = await db.query(
        'clientes',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (rows.isEmpty) {
        return ErrorResultState(message: 'Cliente #$id não encontrado');
      }

      return SuccessResultState(
        result: ClienteModel.fromJson(Map<String, dynamic>.from(rows.first)),
      );
    } catch (e) {
      return ErrorResultState(message: 'Falha ao buscar cliente: $e');
    }
  }

  @override
  Future<ResultState<ClienteModel>> store(ClienteModel data) async {
    try {
      final nome = data.nome.trim();
      final apelido = data.apelido.trim();

      if (nome.isEmpty || apelido.isEmpty) {
        return ErrorResultState(message: 'Nome e apelido são obrigatórios');
      }

      final db = await _database.database;
      final id = await db.insert('clientes', {
        'nome': nome,
        'apelido': apelido,
      });

      return SuccessResultState(
        result: ClienteModel(id: id, nome: nome, apelido: apelido),
      );
    } catch (e) {
      return ErrorResultState(message: 'Falha ao criar cliente: $e');
    }
  }

  @override
  Future<ResultState<ClienteModel>> update(ClienteModel data) async {
    try {
      final nome = data.nome.trim();
      final apelido = data.apelido.trim();

      if (nome.isEmpty || apelido.isEmpty) {
        return ErrorResultState(message: 'Nome e apelido são obrigatórios');
      }

      final db = await _database.database;
      final affected = await db.update(
        'clientes',
        {'nome': nome, 'apelido': apelido},
        where: 'id = ?',
        whereArgs: [data.id],
      );

      if (affected == 0) {
        return ErrorResultState(message: 'Cliente #${data.id} não encontrado');
      }

      return SuccessResultState(
        result: ClienteModel(id: data.id, nome: nome, apelido: apelido),
      );
    } catch (e) {
      return ErrorResultState(message: 'Falha ao atualizar cliente: $e');
    }
  }

  @override
  Future<ResultState<void>> destroy(int id) async {
    try {
      final db = await _database.database;
      final affected = await db.delete(
        'clientes',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (affected == 0) {
        return ErrorResultState(message: 'Cliente #$id não encontrado');
      }

      return SuccessResultState(result: null);
    } catch (e) {
      return ErrorResultState(message: 'Falha ao excluir cliente: $e');
    }
  }
}
