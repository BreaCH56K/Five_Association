import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:tech_finances/database/categorias/cat_despesas/categoria_despesas_database.dart';
import 'package:tech_finances/database/categorias/cat_despesas/categoria_despesas_model.dart';
import 'package:tech_finances/database/categorias/cat_receitas/categoria_receitas_database.dart';
import 'package:tech_finances/database/categorias/cat_receitas/categoria_receitas_model.dart';
import 'package:tech_finances/database/despesas/despesas_database.dart';
import 'package:tech_finances/database/despesas/despesas_model.dart';
import 'package:tech_finances/database/historico/historico_database.dart';
import 'package:tech_finances/database/historico/historico_model.dart';
import 'package:tech_finances/database/receitas/receitas_database.dart';
import 'package:tech_finances/database/receitas/receitas_model.dart';
import 'package:tech_finances/home/drawer.dart';
import 'package:tech_finances/home/grafico1.dart';
import 'package:tech_finances/pages/historico.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  int? mesSelecionado;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  Set<int> meses = {};
  Set<String> mesesString = {};
  List<int> mesesList = [];
  List<String> mesesListString = [];
  List<String> listMesesNomes = [
    '',
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];
  bool isButton1Active = true;
  List<String> listCatDespesas = [];
  List<String> listCatReceitas = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _despesasController = TextEditingController();
  final TextEditingController _dataDespesaControllerTest =
      TextEditingController();
  final TextEditingController _horaDespesaControllerTest =
      TextEditingController();
  final TextEditingController _receitasController = TextEditingController();
  final TextEditingController _dataReceitaControllerTest =
      TextEditingController();
  final TextEditingController _horaReceitaControllerTest =
      TextEditingController();
  double valorBalanco = 0;
  double valorReceita = 0;
  double valorDespesa = 0;
  String? dropdownValueDespesas;
  String? dropdownValueReceitas;
  int selectedIndex = -1;
  final ScrollController _scrollController = ScrollController();
  Map<String, double> dataMapPie1 = {
    "Despesas": 0,
    "Receitas": 0,
  };
  Map<String, double> dataMapPie2Receitas = {'': 0};
  Map<String, double> dataMapPie2Despesas = {'': 0};
  Map<String, List<HistoricoModel>> dadosPorMesHome = {};

  List<Color> colorListPie1 = [
    Colors.red, // Cor para a categoria "Despesas"
    Colors.green,
    Colors.blue,
    Colors.white,
    Colors.black,
    Colors.yellow,
    Colors.orange, // Cor para a categoria "Receitas"
  ];
  Set<String> categoriasGrafico = {};
  List<String> categoriasGraficoList = [];
  Key chartKeyPie1 = UniqueKey();

  void recuperarCatDespesas() async {
    listCatDespesas.clear();
    listCatDespesas.add("Selecione uma Categoria");
    CatDespesaDatabase catDespesaDatabase = CatDespesaDatabase();

    List<CategoriasDespesasModel> list =
        await catDespesaDatabase.recuperarDadosCatDespesas();

    for (var element in list) {
      listCatDespesas.add(element.categoriasDespesas!);
    }
    dropdownValueDespesas = listCatDespesas[0];
  }

  void recuperarCatReceitas() async {
    listCatReceitas.clear();
    listCatReceitas.add("Selecione uma Categoria");
    CatReceitaDatabase catReceitaDatabase = CatReceitaDatabase();

    List<CategoriasReceitasModel> list =
        await catReceitaDatabase.recuperarDadosCatReceitas();

    for (var element in list) {
      listCatReceitas.add(element.categoriaReceitas!);
    }
    dropdownValueReceitas = listCatReceitas[0];
  }

  void valorDespesas(int mes) async {
    valorDespesa = 0;
    HistoricoDatabase historicoDatabase = HistoricoDatabase();
    List<HistoricoModel> list =
        await historicoDatabase.recuperarDadosHistorico();

    DateFormat formato = DateFormat('dd/MM/yyyy');
    for (var element in list) {
      String data = element.data.split(' ')[0];
      DateTime dataConvertida = formato.parse(data.trim(), true);
      if (dataConvertida.month == mes && element.tipo == 'DESPESA') {
        setState(() {
          valorDespesa += element.valor!;
          calculaBalanco();
        });
      }
    }
  }

  void valorReceitas(int mes) async {
    valorReceita = 0;
    HistoricoDatabase historicoDatabase = HistoricoDatabase();
    List<HistoricoModel> list =
        await historicoDatabase.recuperarDadosHistorico();

    DateFormat formato = DateFormat('dd/MM/yyyy');
    for (var element in list) {
      String data = element.data.split(' ')[0];
      DateTime dataConvertida = formato.parse(data.trim(), true);
      if (dataConvertida.month == mes && element.tipo == 'RECEITA') {
        setState(() {
          valorReceita += element.valor!;
          calculaBalanco();
        });
      }
    }
  }

  Future<void> gerarListaMeses() async {
    meses.clear();
    mesesString.clear();
    mesesList.clear();
    mesesListString.clear();
    HistoricoDatabase historicoDatabase = HistoricoDatabase();
    List<HistoricoModel> list =
        await historicoDatabase.recuperarDadosHistorico();

    for (var element in list) {
      DateFormat formato = DateFormat('dd/MM/yyyy');
      String data = element.data.split(' ')[0];
      DateTime dataConvertida = formato.parse(data.trim(), true);
      String ano = dataConvertida.year.toString();
      meses.add(dataConvertida.month);
      String verificaCaracteresMes = dataConvertida.month.toString();
      if (verificaCaracteresMes.length < 2) {
        mesesString.add('0${dataConvertida.month}/${ano.substring(2)}');
      } else {
        mesesString.add('${dataConvertida.month}/${ano.substring(2)}');
      }
    }

    mesesList = meses.toList();
    mesesListString = mesesString.toList();
    selectedIndex = mesesList.length - 1;
    dadosPorMesHome = criarMapaPorMes(list);

    setState(() {});
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

      // Verificar se já existe uma lista de transações para este mês
      if (!mapaPorMes.containsKey(mesAno)) {
        mapaPorMes[mesAno] = [
          transacao
        ]; // Se não existir, crie uma nova lista com a transação atual
      } else {
        // Se já existir, verifique se a transação atual já está na lista para evitar duplicatas
        if (!mapaPorMes[mesAno]!.contains(transacao)) {
          mapaPorMes[mesAno]!.add(
              transacao); // Se não estiver, adicione à lista de transações do mês
        }
      }
    }

    return mapaPorMes;
  }

  void gerarGraficoCategoriasReceitas(int mes) async {
    categoriasGrafico.clear();
    HistoricoDatabase historicoDatabase = HistoricoDatabase();
    List<HistoricoModel> list =
        await historicoDatabase.recuperarDadosHistorico();
    DateFormat formato = DateFormat('dd/MM/yyyy');

    // Limpar o mapa antes de começar a acumular os valores
    dataMapPie2Receitas.clear();

    for (var element in list) {
      String data = element.data.split(' ')[0];
      DateTime dataConvertida = formato.parse(data.trim(), true);
      if (dataConvertida.month == mes && element.tipo == 'RECEITA') {
        categoriasGrafico.add(element.categoria!);
        if (categoriasGrafico.isEmpty) {
          dataMapPie2Receitas[''] = 0;
        } else {
          dataMapPie2Receitas[element.categoria!] =
              (dataMapPie2Receitas[element.categoria!] ?? 0) + element.valor!;
        }
        // Se o elemento da categoria já existir no mapa, some o valor; caso contrário, inicialize com o valor atual
      }
    }
  }

  void gerarGraficoCategoriasDespesas(int mes) async {
    categoriasGrafico.clear();
    HistoricoDatabase historicoDatabase = HistoricoDatabase();
    List<HistoricoModel> list =
        await historicoDatabase.recuperarDadosHistorico();
    DateFormat formato = DateFormat('dd/MM/yyyy');

    // Limpar o mapa antes de começar a acumular os valores
    dataMapPie2Despesas.clear();

    for (var element in list) {
      String data = element.data.split(' ')[0];
      DateTime dataConvertida = formato.parse(data.trim(), true);
      if (dataConvertida.month == mes && element.tipo == 'DESPESA') {
        categoriasGrafico.add(element.categoria!);
        if (categoriasGrafico.isEmpty) {
          dataMapPie2Despesas[''] = 0;
        } else {
          dataMapPie2Despesas[element.categoria!] =
              (dataMapPie2Despesas[element.categoria!] ?? 0) + element.valor!;
        }
      }
    }
  }

  Future<void> salvarDespesaNoBanco() async {
    //String dataAtual = DateFormat('dd/MM/yyyy – HH:mm').format(DateTime.now());
    String dataAtual =
        '${_dataDespesaControllerTest.text} - ${_horaDespesaControllerTest.text}';
    if (dropdownValueDespesas == "Selecione uma Categoria") {
      dropdownValueDespesas = "Não Informada";
    }
    DespesaModel despesaModel = DespesaModel(
      valorDespesa: double.tryParse(_despesasController.text),
      dataDespesa: dataAtual,
      categoria: dropdownValueDespesas,
    );

    HistoricoModel historicoModel = HistoricoModel(
      valor: double.tryParse(_despesasController.text),
      data: dataAtual,
      tipo: "DESPESA",
      categoria: dropdownValueDespesas,
    );

    DespesaDatabase despesaDatabase = DespesaDatabase();
    despesaDatabase.insertDespesa(despesaModel);

    HistoricoDatabase historicoDatabase = HistoricoDatabase();
    historicoDatabase.insertHistorico(historicoModel);
  }

  Future<void> salvarReceitasNoBanco() async {
    //String dataAtual = DateFormat('dd/MM/yyyy - HH:mm').format(DateTime.now());
    String dataAtual =
        '${_dataReceitaControllerTest.text} - ${_horaReceitaControllerTest.text}';
    if (dropdownValueReceitas == "Selecione uma Categoria") {
      dropdownValueReceitas = "Não informada";
    }
    ReceitaModel receitaModel = ReceitaModel(
      valorReceita: double.tryParse(_receitasController.text),
      dataReceita: dataAtual,
      categoria: dropdownValueReceitas,
    );

    HistoricoModel historicoModel = HistoricoModel(
      valor: double.tryParse(_receitasController.text),
      data: dataAtual,
      tipo: "RECEITA",
      categoria: dropdownValueReceitas,
    );

    ReceitaDatabase receitaDatabase = ReceitaDatabase();
    receitaDatabase.insertReceita(receitaModel);

    HistoricoDatabase historicoDatabase = HistoricoDatabase();
    historicoDatabase.insertHistorico(historicoModel);
  }

  void calculaBalanco() {
    valorBalanco = (valorReceita - valorDespesa);
    dataMapPie1['Despesas'] = valorDespesa;
    dataMapPie1['Receitas'] = valorReceita;
    setState(() {});
  }

  void _scrollToSelectedIndex() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && selectedIndex >= 0) {
        final double maxHeight = _scrollController.position.maxScrollExtent;
        final double itemExtent =
            _scrollController.position.viewportDimension / mesesList.length;
        final double scrollTo = selectedIndex * itemExtent > maxHeight
            ? maxHeight
            : selectedIndex * itemExtent;
        _scrollController.animateTo(
          scrollTo,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });
  }

  void inicializar() async {
    await gerarListaMeses();
    recuperarCatDespesas();
    recuperarCatReceitas();
    if (mesesList.isNotEmpty) {
      valorDespesas(mesesList.last);
      valorReceitas(mesesList.last);
      gerarGraficoCategoriasReceitas(mesesList.last);
      gerarGraficoCategoriasDespesas(mesesList.last);
    }

    _scrollToSelectedIndex();
    chartKeyPie1 = UniqueKey();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    inicializar();
  }

  void _addReceita() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: TextFormField(
                                          controller: _receitasController,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
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
                                            floatingLabelStyle: const TextStyle(
                                                color: Colors.red),
                                            labelText: 'Valor',
                                            prefixText: 'R\$ ',
                                            hintText: '0.00',
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10.0),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.amberAccent),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blueGrey),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blue),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                DropdownMenu(
                                  initialSelection: listCatReceitas.first,
                                  onSelected: (String? value) {
                                    setState(() {
                                      dropdownValueReceitas = value;
                                    });
                                  },
                                  dropdownMenuEntries: listCatReceitas
                                      .map<DropdownMenuEntry<String>>(
                                          (String value) {
                                    return DropdownMenuEntry<String>(
                                        value: value, label: value);
                                  }).toList(),
                                ),
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  controller: _dataReceitaControllerTest,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Este campo não pode ser vazio!';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    floatingLabelStyle:
                                        const TextStyle(color: Colors.red),
                                    labelText: 'Data',
                                    hintText: 'DD/MM/AAAA',
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.amberAccent),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  controller: _horaReceitaControllerTest,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Este campo não pode ser vazio!';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    floatingLabelStyle:
                                        const TextStyle(color: Colors.red),
                                    labelText: 'Hora',
                                    hintText: 'HH:MM',
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.amberAccent),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.green,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.of(context).pop();
                                      salvarReceitasNoBanco();
                                      inicializar();
                                    }
                                  },
                                  child: const Text('Adicionar'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
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
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: TextFormField(
                                          controller: _despesasController,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
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
                                            floatingLabelStyle: const TextStyle(
                                                color: Colors.red),
                                            labelText: 'Valor',
                                            prefixText: 'R\$ ',
                                            hintText: '0.00',
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10.0),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.amberAccent),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blueGrey),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.blue),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                DropdownMenu(
                                  initialSelection: listCatDespesas.first,
                                  onSelected: (String? value) {
                                    setState(() {
                                      dropdownValueDespesas = value;
                                    });
                                  },
                                  dropdownMenuEntries: listCatDespesas
                                      .map<DropdownMenuEntry<String>>(
                                          (String value) {
                                    return DropdownMenuEntry<String>(
                                        value: value, label: value);
                                  }).toList(),
                                ),
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  controller: _dataDespesaControllerTest,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Este campo não pode ser vazio!';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    floatingLabelStyle:
                                        const TextStyle(color: Colors.red),
                                    labelText: 'Data',
                                    hintText: 'DD/MM/AAAA',
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.amberAccent),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  controller: _horaDespesaControllerTest,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Este campo não pode ser vazio!';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    floatingLabelStyle:
                                        const TextStyle(color: Colors.red),
                                    labelText: 'Hora',
                                    hintText: 'HH:MM',
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.amberAccent),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.green,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.of(context).pop();
                                      salvarDespesaNoBanco();
                                      inicializar();
                                    }
                                  },
                                  child: const Text('Adicionar'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: gavetaVertical(),
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
                    height: constraints.maxHeight * .44,
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * .1,
                            width: constraints.maxWidth * .7,
                            child: meses.isNotEmpty
                                ? ListView.builder(
                                    controller: _scrollController,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: mesesList.length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                gerarGraficoCategoriasReceitas(
                                                    mesesList[index]);
                                                gerarGraficoCategoriasDespesas(
                                                    mesesList[index]);
                                                setState(() {
                                                  selectedIndex = index;
                                                  chartKeyPie1 = UniqueKey();
                                                });
                                                valorDespesas(mesesList[index]);
                                                valorReceitas(mesesList[index]);
                                                calculaBalanco();
                                                setState(() {});
                                              },
                                              child: InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(10),
                                                    ),
                                                    color:
                                                        index == selectedIndex
                                                            ? Colors.blueGrey
                                                            : Colors.white,
                                                  ),
                                                  width: constraints.maxWidth *
                                                      0.2,
                                                  height:
                                                      constraints.maxHeight *
                                                          0.1,
                                                  child: Center(
                                                    child: Text(
                                                      '${listMesesNomes[mesesList[index]]}/${mesesListString[index].substring(3)}',
                                                      style: index ==
                                                              selectedIndex
                                                          ? const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              color:
                                                                  Colors.white)
                                                          : const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          mesesList[index] != mesesList.last
                                              ? Container(
                                                  width: 3,
                                                  height: 50,
                                                  color: Colors.blueAccent,
                                                )
                                              : const SizedBox(
                                                  width: 0,
                                                  height: 0,
                                                ),
                                        ],
                                      );
                                    },
                                  )
                                : const Center(
                                    child:
                                        Text('Adicione Receitas ou Despesas.'),
                                  ),
                          ),
                          const Divider(color: Colors.black),
                          SizedBox(
                            height: constraints.maxHeight * .02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "R\$ ${valorBalanco.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontSize: 26,
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
                                          fontSize: 14,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Despesas: R\$ ${valorDespesa.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 30,
                                height: 50,
                              ),
                              PieChart(
                                key: chartKeyPie1,
                                dataMap: dataMapPie1,
                                colorList: colorListPie1,
                                animationDuration:
                                    const Duration(milliseconds: 800),
                                chartRadius: constraints.maxWidth * .25,
                                initialAngleInDegree: 0,
                                chartType: ChartType.ring,
                                ringStrokeWidth: 15,
                                legendOptions: const LegendOptions(
                                  showLegends: false,
                                ),
                                chartValuesOptions: const ChartValuesOptions(
                                  showChartValueBackground: true,
                                  showChartValues: false,
                                  showChartValuesInPercentage: false,
                                  showChartValuesOutside: false,
                                  decimalPlaces: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.white,
                    width: constraints.maxWidth * .95,
                    height: constraints.maxHeight * .5,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isButton1Active = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isButton1Active
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                child: const Text('Receitas'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isButton1Active = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: !isButton1Active
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                child: const Text('Despesas'),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: PieChart(
                            dataMap: isButton1Active
                                ? dataMapPie2Receitas
                                : dataMapPie2Despesas,
                            animationDuration:
                                const Duration(milliseconds: 800),
                            chartRadius:
                                MediaQuery.of(context).size.width * .25,
                            initialAngleInDegree: 0,
                            ringStrokeWidth: 15,
                            legendOptions: const LegendOptions(
                              showLegends: true,
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                              showChartValueBackground: true,
                              showChartValues: false,
                              showChartValuesInPercentage: false,
                              showChartValuesOutside: false,
                              decimalPlaces: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: constraints.maxWidth * .95,
                    height: constraints.maxHeight * .8,
                    child: Grafico1(
                      dadosPorMes: dadosPorMesHome,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                Icons.attach_money,
                color: Colors.green,
                size: 30,
              ),
              onPressed: () {
                _addReceita();
                recuperarCatReceitas();
                _receitasController.text = '';
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.money_off,
                color: Colors.red,
                size: 30,
              ),
              onPressed: () {
                recuperarCatDespesas();
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
                gerarListaMeses();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Historico(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
            ),
          ],
        ),
      ),
    );
  }
}
