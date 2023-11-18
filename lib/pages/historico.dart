import 'package:flutter/material.dart';
import 'package:rh_app/database/historico/historico_database.dart';
import 'package:rh_app/database/historico/historico_model.dart';

class Historico extends StatefulWidget {
  const Historico({super.key});

  @override
  State<Historico> createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  List<HistoricoModel> registros = []; // Declare a lista de registros aqui

  @override
  void initState() {
    super.initState();
    // Chamada da função para gerar os registros no initState
    gerarRegistro();
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
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historico"),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          color: Colors.white,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: ListView.builder(
              itemCount: registros.length,
              itemBuilder: (context, index) {
                return itemHistorico(registros[index], index, context);
              }),
        ),
      ),
    );
  }
}

Widget itemHistorico(data, index, context) {
  double? valor = data.valor;
  return LayoutBuilder(
    builder: (context, constraints) => Padding(
      padding: const EdgeInsets.symmetric(),
      child: Container(
        width: constraints.maxWidth,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.grey),
          ),
        ),
        child: data.tipo == "RECEITA"
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            'images/receita.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        Text('R\$ ${valor?.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                  Text(data.data),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            'images/despesa.png',
                            width: 40,
                            height: 40,
                          ),
                        ),
                        Text('R\$ ${valor?.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                  Text(data.data),
                ],
              ),
      ),
    ),
  );
}
