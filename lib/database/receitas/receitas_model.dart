class ReceitaModel {
  int? idReceita;
  double? valorReceita;
  String dataReceita;

  ReceitaModel({
    this.idReceita,
    required this.valorReceita,
    required this.dataReceita,
  });

  Map<String, dynamic> toMap() {
    return {
      'valor_receita': valorReceita,
      'data_receita': dataReceita,
    };
  }

  factory ReceitaModel.fromMap(Map<String, dynamic> map) {
    return ReceitaModel(
      idReceita: map['id_receita'],
      valorReceita: map['valor_receita'],
      dataReceita: map['data_receita'],
    );
  }
}
