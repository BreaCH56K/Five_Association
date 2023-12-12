import 'package:flutter/material.dart';
import 'package:tech_finances/database/historico/historico_database.dart';

import 'package:tech_finances/pages/categorias_depesas.dart';
import 'package:tech_finances/pages/categorias_receitas.dart';

Widget gavetaVertical() {
  HistoricoDatabase historicoDatabase = HistoricoDatabase();
  return LayoutBuilder(
    builder: (context, constraints) => Container(
      color: Colors.white,
      width: constraints.maxWidth * .6,
      height: constraints.maxHeight,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        children: [
          SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight * .02,
          ),
          ExpansionTile(
            iconColor: Colors.orange,
            textColor: Colors.orange,
            title: const Text('Categorias'),
            leading: const Icon(Icons.category),
            children: [
              ListTile(
                title: const Text('Despesas'),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategoriasDespesas())),
              ),
              ListTile(
                title: const Text('Receitas'),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategoriasReceitas())),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              historicoDatabase.deleteAll();
            },
            child: const Text(
              'Deletar Historico',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ),
  );
}
