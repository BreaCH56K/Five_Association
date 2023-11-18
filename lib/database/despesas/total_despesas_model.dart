class TotalDespesasModel {
  int? idTotalDespesas;

  double totalDespesas;

  TotalDespesasModel({
    this.idTotalDespesas,
    required this.totalDespesas,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_totalDespesas': idTotalDespesas,
      'total_despesas': totalDespesas,
    };
  }

  factory TotalDespesasModel.fromMap(Map<String, dynamic> map) {
    return TotalDespesasModel(
      idTotalDespesas: map['id_totalDespesas'],
      totalDespesas: map['total_despesas'],
    );
  }
}
