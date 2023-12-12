class CategoriasDespesasModel {
  int? idCategoriaDespesas;
  String? categoriasDespesas;

  CategoriasDespesasModel({
    this.idCategoriaDespesas,
    this.categoriasDespesas,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoriaDespesas': categoriasDespesas,
    };
  }

  factory CategoriasDespesasModel.fromMap(Map<String, dynamic> map) {
    return CategoriasDespesasModel(
      idCategoriaDespesas: map['id_categoriaDespesas'],
      categoriasDespesas: map['categoriaDespesas'],
    );
  }
}
