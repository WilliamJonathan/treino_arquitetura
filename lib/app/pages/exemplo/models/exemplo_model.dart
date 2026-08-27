class ExemploModel {
  final int id;
  final String titulo;
  final String descricao;

  ExemploModel({
    required this.id,
    required this.titulo,
    required this.descricao,
  });

  factory ExemploModel.fromJson(Map<String, dynamic> json) {
    return ExemploModel(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
    };
  }

  ExemploModel copyWith({
    int? id,
    String? titulo,
    String? descricao,
  }) {
    return ExemploModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
    );
  }
}
