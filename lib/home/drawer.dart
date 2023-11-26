import 'package:flutter/material.dart';
import 'package:rh_app/pages/categorias_depesas.dart';

Widget gavetaVertical() {
  return LayoutBuilder(
    builder: (context, constraints) => Container(
      color: Colors.white,
      width: constraints.maxWidth * .6,
      height: constraints.maxHeight,
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          ExpansionTile(
            title: const Text('Categorias'),
            leading: const Icon(Icons.category),
            children: [
              ListTile(
                title: const Text('Despesas'),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CategoriasDepesas())),
              )
            ],
          ),
        ],
      ),
    ),
  );
}
