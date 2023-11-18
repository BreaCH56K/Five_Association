class HistoricoModel {
  int? idHistorico;
  double? valor;
  String data;
  String tipo;

  HistoricoModel({
    this.idHistorico,
    required this.valor,
    required this.data,
    required this.tipo,
  });

  Map<String, dynamic> toMap() {
    return {
      'valor': valor,
      'data': data,
      'tipo': tipo,
    };
  }

  factory HistoricoModel.fromMap(Map<String, dynamic> map) {
    return HistoricoModel(
      idHistorico: map['id_historico'],
      valor: map['valor'],
      data: map['data'],
      tipo: map['tipo'],
    );
  }
}
