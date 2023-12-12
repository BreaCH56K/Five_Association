import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:tech_finances/database/database.dart';
import 'package:tech_finances/database/receitas/receitas_model.dart';

class ReceitaDatabase extends BancoDeDados {
  Future<void> insertReceita(ReceitaModel receitaModel) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    // 'conflictAlgorithm' para usar caso a mesma questao seja inserida duas vezes.
    // Neste caso, substitua quaisquer dados anteriores.
    await db.insert(
      'receitas',
      receitaModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateReceita(ReceitaModel receitaModel) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    await db.update(
      'receitas',
      receitaModel.toMap(),
      where: "id_receita = ?",
      whereArgs: [receitaModel.idReceita],
    );
  }

  Future<void> deleteReceita(int id) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    await db.delete(
      'receitas',
      where: "id_receitas = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    await db.execute('DELETE FROM receitas');
  }

  Future<List<ReceitaModel>> recuperarDadosReceitas() async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    final List<Map<String, dynamic>> maps = await db.query('receitas');

    // Converte o List<Map<String, dynamic> em um List<QuestaoModel>.
    return List.generate(
      maps.length,
      (i) {
        return ReceitaModel(
          idReceita: maps[i]['id_receita'],
          valorReceita: maps[i]['valor_receita'],
          dataReceita: maps[i]['data_receita'],
          categoria: maps[i]['categoria'],
        );
      },
    );
  }

  Future<List<ReceitaModel>> gerarListaReceitasPeloID(idReceita) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    final List<Map<String, dynamic>> maps = await db
        .query('receitas', where: 'id_receita = ?', whereArgs: [idReceita]);

    // Converte o List<Map<String, dynamic> em um List<QuestaoModel>.
    return List.generate(
      maps.length,
      (i) {
        return ReceitaModel(
          idReceita: maps[i]['id_receitas'],
          valorReceita: maps[i]['valor_receita'],
          dataReceita: maps[i]['data_receita'],
          categoria: maps[i]['categoria'],
        );
      },
    );
  }
}
