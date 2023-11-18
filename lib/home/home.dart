import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rh_app/database/despesas/despesas_database.dart';
import 'package:rh_app/database/despesas/despesas_model.dart';
import 'package:rh_app/database/despesas/total_despesas_database.dart';
import 'package:rh_app/database/despesas/total_despesas_model.dart';
import 'package:rh_app/database/historico/historico_database.dart';
import 'package:rh_app/database/historico/historico_model.dart';
import 'package:rh_app/database/receitas/receitas_database.dart';
import 'package:rh_app/database/receitas/receitas_model.dart';
import 'package:rh_app/database/receitas/total_receitas_database.dart';
import 'package:rh_app/database/receitas/total_receitas_model.dart';
import 'package:rh_app/pages/historico.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _despesasController = TextEditingController();
  final TextEditingController _receitasController = TextEditingController();
  double valorBalanco = 0;
  double valorReceita = 0;
  double valorDespesa = 0;

  void valorDespesas() async {
    TotalDespesasDatabase totalDespesasDatabase = TotalDespesasDatabase();

    List<TotalDespesasModel> list =
        await totalDespesasDatabase.recuperarTotalDespesas();

    for (var element in list) {
      setState(() {
        valorDespesa = element.totalDespesas;
        calculaBalanco();
      });
    }
  }

  void valorReceitas() async {
    TotalReceitasDatabase totalReceitasDatabase = TotalReceitasDatabase();

    List<TotalReceitasModel> list =
        await totalReceitasDatabase.recuperarTotalReceitas();
    for (var element in list) {
      setState(() {
        valorReceita = element.totalReceitas;
        calculaBalanco();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    valorDespesas();
    valorReceitas();
  }

  void _addReceita() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              Container(
            // Conteúdo da gaveta inferior
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Center(
                  child: Text(
                    'Adicionar Receita',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                const SizedBox(height: 20.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          controller: _receitasController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'),
                            ),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Este campo não pode ser vazio!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            floatingLabelStyle:
                                const TextStyle(color: Colors.red),
                            labelText: 'Valor',
                            prefixText: 'R\$ ',
                            hintText: '0.00',
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.amberAccent),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.green,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      salvarReceitasNoBanco();
                    }
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addDespesa() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              Container(
            // Conteúdo da gaveta inferior
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Center(
                  child: Text(
                    'Adicionar Despesa',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                const SizedBox(height: 20.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextFormField(
                          controller: _despesasController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}'),
                            ),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Este campo não pode ser vazio!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            floatingLabelStyle:
                                const TextStyle(color: Colors.red),
                            labelText: 'Valor',
                            prefixText: 'R\$ ',
                            hintText: '0.00',
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.amberAccent),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.green,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pop();
                      salvarDespesaNoBanco();
                    }
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> salvarDespesaNoBanco() async {
    String dataAtual = DateFormat('dd/MM/yyyy – hh:mm').format(DateTime.now());

    DespesaModel despesaModel = DespesaModel(
      valorDespesa: double.tryParse(_despesasController.text),
      dataDespesa: dataAtual,
    );

    HistoricoModel historicoModel = HistoricoModel(
      valor: double.tryParse(_despesasController.text),
      data: dataAtual,
      tipo: "DESPESA",
    );

    DespesaDatabase despesaDatabase = DespesaDatabase();
    despesaDatabase.insertDespesa(despesaModel);

    HistoricoDatabase historicoDatabase = HistoricoDatabase();
    historicoDatabase.insertHistorico(historicoModel);

    //Atualizar valor da despesa na tabela que armazena o total de despesas já gastos!
    TotalDespesasDatabase totalDespesasDatabase = TotalDespesasDatabase();

    double aux;

    aux = await totalDespesasDatabase.recuperarTotalDespesasDoBanco();

    double totalAtual = aux + double.tryParse(_despesasController.text)!;
    TotalDespesasModel totalDespesasModel1 =
        TotalDespesasModel(idTotalDespesas: 1, totalDespesas: totalAtual);

    totalDespesasDatabase.updateTotalDespesas(totalDespesasModel1);
    totalDespesasDatabase.recuperarTotalDespesasDoBanco();
    valorDespesas();
  }

  Future<void> salvarReceitasNoBanco() async {
    String dataAtual = DateFormat('dd/MM/yyyy - hh:mm').format(DateTime.now());

    ReceitaModel receitaModel = ReceitaModel(
      valorReceita: double.tryParse(_receitasController.text),
      dataReceita: dataAtual,
    );

    HistoricoModel historicoModel = HistoricoModel(
      valor: double.tryParse(_receitasController.text),
      data: dataAtual,
      tipo: "RECEITA",
    );

    ReceitaDatabase receitaDatabase = ReceitaDatabase();
    receitaDatabase.insertReceita(receitaModel);

    HistoricoDatabase historicoDatabase = HistoricoDatabase();
    historicoDatabase.insertHistorico(historicoModel);

    //Atualizar valor da receita na tabela que armazena o total de receitas já gastos!
    TotalReceitasDatabase totalReceitasDatabase = TotalReceitasDatabase();
    double aux;
    aux = await totalReceitasDatabase.recuperarTotalReceitasDoBanco();

    double totalAtual = aux + double.tryParse(_receitasController.text)!;
    TotalReceitasModel totalReceitasModel =
        TotalReceitasModel(idTotalReceitas: 1, totalReceitas: totalAtual);

    totalReceitasDatabase.updateTotalReceitas(totalReceitasModel);
    totalReceitasDatabase.recuperarTotalReceitasDoBanco();

    valorReceitas();
  }

  //Função que retorna o diretorio em que o arquivo do banco de dados foi salvo.
  /*Future<String> getDatabasePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }*/

  Future<void> listaDados() async {
    DespesaDatabase despesaDatabase = DespesaDatabase();
    List<DespesaModel> despesas =
        await despesaDatabase.recuperarDadosDespesas();
    print("============================================");
    for (var despesa in despesas) {
      print("ID da Despesa: ${despesa.idDespesa}");
      print("Valor da Despesa: ${despesa.valorDespesa}");
      print("Data da Despesa: ${despesa.dataDespesa}");
    }
    print("==========================================");

    ReceitaDatabase receitaDatabase = ReceitaDatabase();
    List<ReceitaModel> receitas =
        await receitaDatabase.recuperarDadosReceitas();
    for (var element in receitas) {
      print("ID da Receita: ${element.idReceita}");
      print("Valor da Receita: ${element.valorReceita}");
      print("Data da Receita: ${element.dataReceita}");
    }
    print("==========================================");

    HistoricoDatabase historicoDatabase = HistoricoDatabase();
    List<HistoricoModel> historico =
        await historicoDatabase.recuperarDadosHistorico();
    for (var element in historico) {
      print("ID da Transação: ${element.idHistorico}");
      print("Valor da Transação: ${element.valor}");
      print("Data da Transação: ${element.data}");
      print("Tipo de Transação: ${element.tipo}");
    }
    print("==========================================");

    //Chamada da função para localizar onde o arquivo do banco de dados foi salvo.
    /*getDatabasePath().then((path) {
      print('Caminho do banco de dados: $path');
    });*/

    TotalDespesasDatabase totalDespesasDatabase = TotalDespesasDatabase();
    List<TotalDespesasModel> totalDespesas =
        await totalDespesasDatabase.recuperarTotalDespesas();
    for (var element in totalDespesas) {
      print("ID na tabela totalDepesas: ${element.idTotalDespesas}");
      print("Valor total das despesas: ${element.totalDespesas}");
    }

    TotalReceitasDatabase totalReceitasDatabase = TotalReceitasDatabase();
    List<TotalReceitasModel> totalReceitas =
        await totalReceitasDatabase.recuperarTotalReceitas();
    for (var element in totalReceitas) {
      print("ID na tabela totalReceitas: ${element.idTotalReceitas}");
      print("Valor total das receitas: ${element.totalReceitas}");
    }
  }

  void calculaBalanco() {
    valorBalanco = (valorReceita - valorDespesa);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: <Color>[
                Color(0xff1f005c),
                Color(0xff5b0060),
                Color(0xff870160),
                Color(0xffac255e),
                Color(0xffca485c),
                Color(0xffe16b5c),
                Color(0xfff39060),
                Color(0xffffb56b),
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: constraints.maxHeight * .05,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 10.0, // soften the shadow
                          spreadRadius: 0.5, //exte
                        )
                      ],
                      color: Colors.white,
                    ),
                    width: constraints.maxWidth * .9,
                    height: constraints.maxHeight * .25,
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "R\$ ${valorBalanco.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: valorBalanco < 0
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Receitas: R\$ ${valorReceita.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Despesas: R\$ ${valorDespesa.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      listaDados();
                    },
                    icon: const Icon(Icons.print),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white, // Defina a cor de fundo desejada
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.green,
                size: 30,
              ),
              onPressed: () {
                _addReceita();
                _receitasController.text = '';
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.remove,
                color: Colors.red,
                size: 30,
              ),
              onPressed: () {
                _addDespesa();
                _despesasController.text = '';
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.history,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Historico()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
