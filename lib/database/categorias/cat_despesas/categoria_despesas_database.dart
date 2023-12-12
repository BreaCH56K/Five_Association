// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart';
import 'package:tech_finances/database/categorias/cat_despesas/categoria_despesas_model.dart';
import 'package:tech_finances/database/database.dart';

class CatDespesaDatabase extends BancoDeDados {
  Future<void> insertCatDespesa(
      CategoriasDespesasModel categoriasDespesasModel) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    // 'conflictAlgorithm' para usar caso a mesma questao seja inserida duas vezes.
    // Neste caso, substitua quaisquer dados anteriores.
    await db.insert(
      'categoriaDespesas',
      categoriasDespesasModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCatDespesa(
      CategoriasDespesasModel categoriasDespesasModel) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    await db.update(
      'categoriaDespesas',
      categoriasDespesasModel.toMap(),
      where: "id_categoriaDespesas = ?",
      whereArgs: [categoriasDespesasModel.idCategoriaDespesas],
    );
  }

  Future<void> deleteCatDespesa(String nome) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    await db.delete(
      'categoriaDespesas',
      where: "categoriaDespesas = ?",
      whereArgs: [nome],
    );
  }

  Future<void> deleteAll() async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    await db.execute('DELETE FROM categoriaDespesas');
  }

  Future<List<CategoriasDespesasModel>> recuperarDadosCatDespesas() async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    final List<Map<String, dynamic>> maps = await db.query('categoriaDespesas');

    // Converte o List<Map<String, dynamic> em um List<QuestaoModel>.
    return List.generate(
      maps.length,
      (i) {
        return CategoriasDespesasModel(
          idCategoriaDespesas: maps[i]['id_categoriaDespesas'],
          categoriasDespesas: maps[i]['categoriaDespesas'],
        );
      },
    );
  }

  Future<List<CategoriasDespesasModel>> gerarListaCatDespesasPeloID(
      idCatDespesa) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    final List<Map<String, dynamic>> maps = await db.query('categoriaDespesas',
        where: 'id_categoriaDespesas = ?', whereArgs: [idCatDespesa]);

    // Converte o List<Map<String, dynamic> em um List<QuestaoModel>.
    return List.generate(
      maps.length,
      (i) {
        return CategoriasDespesasModel(
          idCategoriaDespesas: maps[i]['id_categoriaDespesas'],
          categoriasDespesas: maps[i]['categoriaDespesas'],
        );
      },
    );
  }
}
