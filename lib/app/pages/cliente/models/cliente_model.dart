class ClienteModel {
  final int id;
  final String nome;
  final String apelido;

  ClienteModel({
    required this.id,
    required this.nome,
    required this.apelido,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) {
    return ClienteModel(
      id: json['id'] is int ? json['id'] as int : int.parse('${json['id']}'),
      nome: '${json['nome'] ?? ''}',
      apelido: '${json['apelido'] ?? ''}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'apelido': apelido,
    };
  }

  ClienteModel copyWith({
    int? id,
    String? nome,
    String? apelido,
  }) {
    return ClienteModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      apelido: apelido ?? this.apelido,
    );
  }
}
