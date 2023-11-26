import 'package:flutter/material.dart';

class CategoriasDepesas extends StatefulWidget {
  const CategoriasDepesas({super.key});

  @override
  State<CategoriasDepesas> createState() => _CategoriasDepesasState();
}

class _CategoriasDepesasState extends State<CategoriasDepesas> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            'Categorias de Depesas',
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
            children: [
              Form(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  width: constraints.maxWidth * .7,
                  height: constraints.maxHeight * .08,
                  child: const Center(
                    child: Text(
                      'Adicionar',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
              ListView.builder(
                itemBuilder: (context, index) => Container(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
