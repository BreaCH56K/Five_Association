class HistoricoModel {
  int? idHistorico;
  double? valor;
  String data;
  String tipo;
  String? categoria;

  HistoricoModel({
    this.idHistorico,
    required this.valor,
    required this.data,
    required this.tipo,
    required this.categoria,
  });

  Map<String, dynamic> toMap() {
    return {
      'valor': valor,
      'data': data,
      'tipo': tipo,
      'categoria': categoria,
    };
  }

  factory HistoricoModel.fromMap(Map<String, dynamic> map) {
    return HistoricoModel(
      idHistorico: map['id_historico'],
      valor: map['valor'],
      data: map['data'],
      tipo: map['tipo'],
      categoria: map['categoria'],
    );
  }
}
