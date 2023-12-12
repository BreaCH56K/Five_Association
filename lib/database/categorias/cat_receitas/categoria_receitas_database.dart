import 'package:sqflite/sqflite.dart';
import 'package:tech_finances/database/categorias/cat_receitas/categoria_receitas_model.dart';
import 'package:tech_finances/database/database.dart';

class CatReceitaDatabase extends BancoDeDados {
  Future<void> insertCatReceita(
      CategoriasReceitasModel categoriasReceitasModel) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    // 'conflictAlgorithm' para usar caso a mesma questao seja inserida duas vezes.
    // Neste caso, substitua quaisquer dados anteriores.
    await db.insert(
      'categoriaReceitas',
      categoriasReceitasModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCatReceita(
      CategoriasReceitasModel categoriasReceitasModel) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    await db.update(
      'categoriaReceitas',
      categoriasReceitasModel.toMap(),
      where: "id_categoriaReceitas = ?",
      whereArgs: [categoriasReceitasModel.idCategoriaReceitas],
    );
  }

  Future<void> deleteCatReceita(String nome) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    await db.delete(
      'categoriaReceitas',
      where: "categoriaReceitas = ?",
      whereArgs: [nome],
    );
  }

  Future<void> deleteAll() async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    await db.execute('DELETE FROM categoriaReceitas');
  }

  Future<List<CategoriasReceitasModel>> recuperarDadosCatReceitas() async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    final List<Map<String, dynamic>> maps = await db.query('categoriaReceitas');

    // Converte o List<Map<String, dynamic> em um List<QuestaoModel>.
    return List.generate(
      maps.length,
      (i) {
        return CategoriasReceitasModel(
          idCategoriaReceitas: maps[i]['id_categoriaReceitas'],
          categoriaReceitas: maps[i]['categoriaReceitas'],
        );
      },
    );
  }

  Future<List<CategoriasReceitasModel>> gerarListaCatReceitasPeloID(
      idCatReceita) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    final List<Map<String, dynamic>> maps = await db.query('categoriaReceitas',
        where: 'id_categoriaReceitas = ?', whereArgs: [idCatReceita]);

    // Converte o List<Map<String, dynamic> em um List<QuestaoModel>.
    return List.generate(
      maps.length,
      (i) {
        return CategoriasReceitasModel(
          idCategoriaReceitas: maps[i]['id_categoriaReceitas'],
          categoriaReceitas: maps[i]['categoriaReceitas'],
        );
      },
    );
  }
}
