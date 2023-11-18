import 'package:rh_app/database/database.dart';
import 'package:rh_app/database/despesas/despesas_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DespesaDatabase extends BancoDeDados {
  Future<void> insertDespesa(DespesaModel despesaModel) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    // 'conflictAlgorithm' para usar caso a mesma questao seja inserida duas vezes.
    // Neste caso, substitua quaisquer dados anteriores.
    await db.insert(
      'despesas',
      despesaModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateDespesa(DespesaModel despesaModel) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    await db.update(
      'despesas',
      despesaModel.toMap(),
      where: "id_despesa = ?",
      whereArgs: [despesaModel.idDespesa],
    );
  }

  Future<void> deleteDespesa(int id) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    await db.delete(
      'despesas',
      where: "id_despesas = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    await db.execute('DELETE FROM despesas');
  }

  Future<List<DespesaModel>> recuperarDadosDespesas() async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    final List<Map<String, dynamic>> maps = await db.query('despesas');

    // Converte o List<Map<String, dynamic> em um List<QuestaoModel>.
    return List.generate(
      maps.length,
      (i) {
        return DespesaModel(
          idDespesa: maps[i]['id_despesa'],
          valorDespesa: maps[i]['valor_despesa'],
          dataDespesa: maps[i]['data_despesa'],
        );
      },
    );
  }

  Future<List<DespesaModel>> gerarListaDespesasPeloID(idDespesa) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    final List<Map<String, dynamic>> maps = await db
        .query('despesas', where: 'id_despesa = ?', whereArgs: [idDespesa]);

    // Converte o List<Map<String, dynamic> em um List<QuestaoModel>.
    return List.generate(
      maps.length,
      (i) {
        return DespesaModel(
          idDespesa: maps[i]['id_despesas'],
          valorDespesa: maps[i]['valor_despesa'],
          dataDespesa: maps[i]['data_despesa'],
        );
      },
    );
  }
}
