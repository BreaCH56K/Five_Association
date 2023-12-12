import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:tech_finances/database/database.dart';
import 'package:tech_finances/database/historico/historico_model.dart';

class HistoricoDatabase extends BancoDeDados {
  Future<void> insertHistorico(HistoricoModel historicoModel) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    // 'conflictAlgorithm' para usar caso a mesma questao seja inserida duas vezes.
    // Neste caso, substitua quaisquer dados anteriores.
    await db.insert(
      'historico',
      historicoModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateHistorico(HistoricoModel historicoModel) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    await db.update(
      'despesas',
      historicoModel.toMap(),
      where: "id_historico = ?",
      whereArgs: [historicoModel.idHistorico],
    );
  }

  Future<void> deleteHistorico(int id) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    await db.delete(
      'despesas',
      where: "id_historico = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    await db.execute('DELETE FROM historico');
  }

  Future<List<HistoricoModel>> recuperarDadosHistorico() async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    final List<Map<String, dynamic>> maps = await db.query('historico');

    // Converte o List<Map<String, dynamic> em um List<QuestaoModel>.
    return List.generate(
      maps.length,
      (i) {
        return HistoricoModel(
          idHistorico: maps[i]['id_historico'],
          valor: maps[i]['valor'],
          data: maps[i]['data'],
          tipo: maps[i]['tipo'],
          categoria: maps[i]['categoria'],
        );
      },
    );
  }

  Future<List<HistoricoModel>> gerarListaHistoricoPeloID(idDespesa) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    final List<Map<String, dynamic>> maps = await db
        .query('despesas', where: 'id_historico = ?', whereArgs: [idDespesa]);

    // Converte o List<Map<String, dynamic> em um List<QuestaoModel>.
    return List.generate(
      maps.length,
      (i) {
        return HistoricoModel(
          idHistorico: maps[i]['id_historico'],
          valor: maps[i]['valor'],
          data: maps[i]['data'],
          tipo: maps[i]['tipo'],
          categoria: maps[i]['categoria'],
        );
      },
    );
  }
}
