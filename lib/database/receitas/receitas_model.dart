class ReceitaModel {
  int? idReceita;
  double? valorReceita;
  String dataReceita;
  String? categoria;

  ReceitaModel({
    this.idReceita,
    required this.valorReceita,
    required this.dataReceita,
    this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'valor_receita': valorReceita,
      'data_receita': dataReceita,
      'categoria': categoria,
    };
  }

  factory ReceitaModel.fromMap(Map<String, dynamic> map) {
    return ReceitaModel(
      idReceita: map['id_receita'],
      valorReceita: map['valor_receita'],
      dataReceita: map['data_receita'],
      categoria: map['categoria'],
    );
  }
}
