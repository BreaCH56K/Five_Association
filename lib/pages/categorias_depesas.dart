import 'package:flutter/material.dart';
import 'package:tech_finances/database/categorias/cat_despesas/categoria_despesas_database.dart';
import 'package:tech_finances/database/categorias/cat_despesas/categoria_despesas_model.dart';

class CategoriasDespesas extends StatefulWidget {
  const CategoriasDespesas({super.key});

  @override
  State<CategoriasDespesas> createState() => _CategoriasDespesasState();
}

class _CategoriasDespesasState extends State<CategoriasDespesas> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _catDespesasControler = TextEditingController();
  List<CategoriasDespesasModel> listCatDespesas = [];

  @override
  void initState() {
    super.initState();
    gerarListadoBanco();
  }

  Future<void> gerarListadoBanco() async {
    CatDespesaDatabase catDespesaDatabase = CatDespesaDatabase();
    setState(() {
      listCatDespesas.clear();
    });

    List<CategoriasDespesasModel> list =
        await catDespesaDatabase.recuperarDadosCatDespesas();

    for (var element in list) {
      setState(() {
        listCatDespesas.add(
          CategoriasDespesasModel(
            idCategoriaDespesas: element.idCategoriaDespesas,
            categoriasDespesas: element.categoriasDespesas,
          ),
        );
      });
    }
  }

  Future<void> salvarnoBanco() async {
    CatDespesaDatabase catDespesaDatabase = CatDespesaDatabase();
    CategoriasDespesasModel categoriasDepesasModel = CategoriasDespesasModel(
      categoriasDespesas: _catDespesasControler.text,
    );

    catDespesaDatabase.insertCatDespesa(categoriasDepesasModel);

    _catDespesasControler.text = '';
  }

  bool verificaSeCatExiste(String cat) {
    bool x = false;
    for (var element in listCatDespesas) {
      if (cat == element.categoriasDespesas) {
        x = true;
      }
    }
    return x;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            'Categorias de Despesas',
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
        body: Container(
          color: Colors.white,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Insira a categoria de despesa que deseja adicionar: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Este campo é obrigatório!';
                      }
                      if (verificaSeCatExiste(_catDespesasControler.text)) {
                        return 'Esta categoria já existe!';
                      }
                      return null;
                    },
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.black,
                    controller: _catDespesasControler,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    salvarnoBanco();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Center(
                          child: Text(
                            'Categoria adicionada com sucesso!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                    gerarListadoBanco();
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  width: constraints.maxWidth * .7,
                  height: constraints.maxHeight * .07,
                  child: const Center(
                    child: Text(
                      'Adicionar',
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Suas Categorias de Despesas: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: listCatDespesas.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        color: const Color.fromARGB(255, 235, 240, 243),
                        elevation: 2,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.money_off,
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    '${listCatDespesas[index].categoriasDespesas}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Color.fromARGB(255, 57, 57, 57),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    CatDespesaDatabase catDespesaDatabase =
                                        CatDespesaDatabase();
                                    catDespesaDatabase.deleteCatDespesa(
                                        '${listCatDespesas[index].categoriasDespesas}');
                                    gerarListadoBanco();
                                  },
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
