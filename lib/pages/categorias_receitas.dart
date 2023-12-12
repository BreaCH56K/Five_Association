import 'package:flutter/material.dart';
import 'package:tech_finances/database/categorias/cat_receitas/categoria_receitas_database.dart';
import 'package:tech_finances/database/categorias/cat_receitas/categoria_receitas_model.dart';

class CategoriasReceitas extends StatefulWidget {
  const CategoriasReceitas({super.key});

  @override
  State<CategoriasReceitas> createState() => _CategoriasReceitasState();
}

class _CategoriasReceitasState extends State<CategoriasReceitas> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _catReceitasControler = TextEditingController();
  List<CategoriasReceitasModel> listCatReceitas = [];

  @override
  void initState() {
    super.initState();
    gerarListadoBanco();
  }

  Future<void> gerarListadoBanco() async {
    CatReceitaDatabase catReceitaDatabase = CatReceitaDatabase();
    setState(() {
      listCatReceitas.clear();
    });

    List<CategoriasReceitasModel> list =
        await catReceitaDatabase.recuperarDadosCatReceitas();

    for (var element in list) {
      setState(() {
        listCatReceitas.add(
          CategoriasReceitasModel(
            idCategoriaReceitas: element.idCategoriaReceitas,
            categoriaReceitas: element.categoriaReceitas,
          ),
        );
      });
    }
  }

  Future<void> salvarnoBanco() async {
    CatReceitaDatabase catReceitaDatabase = CatReceitaDatabase();
    CategoriasReceitasModel categoriasDepesasModel = CategoriasReceitasModel(
      categoriaReceitas: _catReceitasControler.text,
    );

    catReceitaDatabase.insertCatReceita(categoriasDepesasModel);

    _catReceitasControler.text = '';
  }

  bool verificaSeCatExiste(String cat) {
    bool x = false;
    for (var element in listCatReceitas) {
      if (cat == element.categoriaReceitas) {
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
            'Categorias de Receitas',
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
                'Insira a categoria de receita que deseja adicionar: ',
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
                      if (verificaSeCatExiste(_catReceitasControler.text)) {
                        return 'Esta categoria já existe!';
                      }
                      return null;
                    },
                    textAlign: TextAlign.start,
                    textAlignVertical: TextAlignVertical.center,
                    cursorColor: Colors.black,
                    controller: _catReceitasControler,
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
                'Suas Categorias de Receitas: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: listCatReceitas.length,
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
                                    Icons.monetization_on_outlined,
                                    color: Colors.grey,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    '${listCatReceitas[index].categoriaReceitas}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Color.fromARGB(255, 57, 57, 57),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    CatReceitaDatabase catReceitaDatabase =
                                        CatReceitaDatabase();
                                    catReceitaDatabase.deleteCatReceita(
                                        '${listCatReceitas[index].categoriaReceitas}');
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
