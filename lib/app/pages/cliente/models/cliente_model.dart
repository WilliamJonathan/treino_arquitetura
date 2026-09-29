class ClienteModel {
  final int id;
  final String nome;
  final String apelido;
  final String cpf;

  ClienteModel({
    required this.id,
    required this.nome,
    required this.apelido,
    required this.cpf,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: json['id'] is int ? json['id'] as int : int.parse('${json['id']}'),
      nome: '${json['nome'] ?? ''}',
      apelido: '${json['apelido'] ?? ''}',
      cpf: '${json['cpf'] ?? ''}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'apelido': apelido,
      'cpf': cpf,
    };
  }

  ClienteModel copyWith({
    int? id,
    String? nome,
    String? apelido,
    String? cpf,
  }) {
    return ClienteModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      apelido: apelido ?? this.apelido,
      cpf: cpf ?? this.cpf,
    );
  }
}
