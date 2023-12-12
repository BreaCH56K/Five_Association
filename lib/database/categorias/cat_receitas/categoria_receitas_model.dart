class CategoriasReceitasModel {
  int? idCategoriaReceitas;
  String? categoriaReceitas;

  CategoriasReceitasModel({
    this.idCategoriaReceitas,
    this.categoriaReceitas,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoriaReceitas': categoriaReceitas,
    };
  }

  factory CategoriasReceitasModel.fromMap(Map<String, dynamic> map) {
    return CategoriasReceitasModel(
      idCategoriaReceitas: map['id_categoriaReceitas'],
      categoriaReceitas: map['categoriaReceitas'],
    );
  }
}
