class TotalReceitasModel {
  int? idTotalReceitas;

  double totalReceitas;

  TotalReceitasModel({
    this.idTotalReceitas,
    required this.totalReceitas,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_totalReceitas': idTotalReceitas,
      'total_receitas': totalReceitas,
    };
  }

  factory TotalReceitasModel.fromMap(Map<String, dynamic> map) {
    return TotalReceitasModel(
      idTotalReceitas: map['id_totalReceitas'],
      totalReceitas: map['total_receitas'],
    );
  }
}
