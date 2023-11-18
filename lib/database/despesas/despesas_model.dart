class DespesaModel {
  int? idDespesa;
  double? valorDespesa;
  String dataDespesa;

  DespesaModel({
    this.idDespesa,
    required this.valorDespesa,
    required this.dataDespesa,
  });

  Map<String, dynamic> toMap() {
    return {
      'valor_despesa': valorDespesa,
      'data_despesa': dataDespesa,
    };
  }

  factory DespesaModel.fromMap(Map<String, dynamic> map) {
    return DespesaModel(
      idDespesa: map['id_despesa'],
      valorDespesa: map['valor_despesa'],
      dataDespesa: map['data_despesa'],
    );
  }
}
