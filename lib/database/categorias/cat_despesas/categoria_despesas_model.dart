class CategoriasDepesasModel {
  int? id_categoriaDepesas;
  String? CategoriasDepesas;

  CategoriasDepesasModel({
    this.id_categoriaDepesas,
    this.CategoriasDepesas,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_categoriaDespesas': id_categoriaDepesas,
      'categoriaDespesas': CategoriasDepesas,
    };
  }

  factory CategoriasDepesasModel.fromMap(Map<String, dynamic> map) {
    return CategoriasDepesasModel(
      id_categoriaDepesas: map['id_categoriaDespesas'],
      CategoriasDepesas: map['categoriaDespesas'],
    );
  }
}
