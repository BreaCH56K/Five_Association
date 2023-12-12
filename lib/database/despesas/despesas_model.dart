class DespesaModel {
  int? idDespesa;
  double? valorDespesa;
  String dataDespesa;
  String? categoria;

  DespesaModel({
    this.idDespesa,
    required this.valorDespesa,
    required this.dataDespesa,
    this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'valor_despesa': valorDespesa,
      'data_despesa': dataDespesa,
      'categoria': categoria,
    };
  }

  factory DespesaModel.fromMap(Map<String, dynamic> map) {
    return DespesaModel(
      idDespesa: map['id_despesa'],
      valorDespesa: map['valor_despesa'],
      dataDespesa: map['data_despesa'],
      categoria: map['categoria'],
    );
  }
}
