import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tech_finances/database/historico/historico_database.dart';
import 'package:tech_finances/database/historico/historico_model.dart';

class Historico extends StatefulWidget {
  const Historico({super.key});

  @override
  State<Historico> createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  List<HistoricoModel> registros = [];
  Set<String> mesAno = {};
  List<String> mesAnoList = [];
  Map<String, List<HistoricoModel>> dadosPorMes = {};

  @override
  void initState() {
    super.initState();
    gerarRegistro();
    gerarMeses();
  }

  Future<void> gerarMeses() async {
    dadosPorMes.clear();
    HistoricoDatabase historicoDatabase = HistoricoDatabase();
    List<HistoricoModel> list =
        await historicoDatabase.recuperarDadosHistorico();
    for (var element in list) {
      DateFormat formato = DateFormat('dd/MM/yyyy');
      String data = element.data.split(' ')[0];
      DateTime dataConvertida = formato.parse(data.trim(), true);
      String ano = dataConvertida.year.toString();

      String verificaCaracteresMes = dataConvertida.month.toString();
      if (verificaCaracteresMes.length < 2) {
        mesAno.add('0${dataConvertida.month}/$ano');
      } else {
        mesAno.add('${dataConvertida.month}/$ano');
      }
    }
    mesAnoList = mesAno.toList();
    Map<String, List<HistoricoModel>> mapaPorMes = criarMapaPorMes(list);
    dadosPorMes = mapaPorMes;
  }

  Map<String, List<HistoricoModel>> criarMapaPorMes(
      List<HistoricoModel> transacoes) {
    Map<String, List<HistoricoModel>> mapaPorMes = {};

    for (var transacao in transacoes) {
      DateFormat formato = DateFormat('dd/MM/yyyy');
      String data = transacao.data.split(' ')[0];
      DateTime dataConvertida = formato.parse(data.trim(), true);
      String mesAno = dataConvertida.month < 10
          ? '0${dataConvertida.month}/${dataConvertida.year}'
          : '${dataConvertida.month}/${dataConvertida.year}';

      if (!mapaPorMes.containsKey(mesAno)) {
        mapaPorMes[mesAno] = [];
      }

      mapaPorMes[mesAno]!.add(transacao);
    }

    return mapaPorMes;
  }

  Future<void> gerarRegistro() async {
    HistoricoDatabase historicoDatabase = HistoricoDatabase();
    setState(() {
      registros.clear(); // Limpe a lista antes de adicionar novos registros
    });
    List<HistoricoModel> list =
        await historicoDatabase.recuperarDadosHistorico();
    setState(() {
      for (var element in list) {
        registros.add(
          HistoricoModel(
            valor: element.valor,
            data: element.data,
            tipo: element.tipo,
            categoria: element.categoria,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Histórico',
          textAlign: TextAlign.center,
        ),

        centerTitle: true, // Essa propriedade irá centralizar o título
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          color: Colors.white,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: ListView.builder(
            itemCount: dadosPorMes.length,
            itemBuilder: (context, index) {
              final meses = dadosPorMes.keys.toList();
              final mes = meses[index];
              final transacoes = dadosPorMes[mes]!;

              return ExpansionTile(
                textColor: Colors.black,
                collapsedIconColor: Colors.black,
                iconColor: Colors.red,
                leading: const Icon(Icons.calendar_month),
                title: Text(
                  mes,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: transacoes.map((transacao) {
                  return itemHistorico(transacao);
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget itemHistorico(HistoricoModel data) {
  double? valor = data.valor;
  return LayoutBuilder(
    builder: (context, constraints) => Padding(
      padding: const EdgeInsets.symmetric(),
      child: Container(
        width: constraints.maxWidth,
        height: 90,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.grey),
          ),
        ),
        child: data.tipo == "RECEITA"
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            'images/receita.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                        Text(
                          'R\$ ${valor?.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Data: ${data.data}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Categoria: ${data.categoria}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            'images/despesa.png',
                            width: 45,
                            height: 45,
                          ),
                        ),
                        Text(
                          'R\$ ${valor?.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Data: ${data.data}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Categoria: ${data.categoria}',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    ),
  );
}
