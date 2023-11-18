import 'package:rh_app/database/database.dart';
import 'package:rh_app/database/receitas/total_receitas_model.dart';
import 'package:sqflite/sqflite.dart';

class TotalReceitasDatabase extends BancoDeDados {
  Future<void> insertTotalReceitas(
      TotalReceitasModel totalReceitasModel) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    // 'conflictAlgorithm' para usar caso a mesma questao seja inserida duas vezes.
    // Neste caso, substitua quaisquer dados anteriores.
    await db.insert(
      'totalReceitas',
      totalReceitasModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTotalReceitas(
      TotalReceitasModel totalReceitasModel) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    // Atualiza a Questao fornecida.
    await db.update(
      'totalReceitas',
      totalReceitasModel.toMap(),
      where: "id_totalReceitas = ?",
      // Passa o id do PROVA como whereArg para evitar injeção de SQL.
      whereArgs: [totalReceitasModel.idTotalReceitas],
    );
  }

  // Um ​​método que recupera todos os dados PROVA da tabela PROVA.
  Future<List<TotalReceitasModel>> recuperarTotalReceitas() async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    final List<Map<String, dynamic>> maps = await db.query('totalReceitas');

    // Converte o List<Map<String, dynamic> em um List<QuestaoModel>.
    return List.generate(
      maps.length,
      (i) {
        return TotalReceitasModel(
          idTotalReceitas: maps[i]['id_totalReceitas'],
          totalReceitas: maps[i]['total_receitas'],
        );
      },
    );
  }

  Future<double> recuperarTotalReceitasDoBanco() async {
    Database db = await BancoDeDados.instance.database;

    // Realize uma consulta SQL para obter o valor diretamente do banco de dados.
    final List<Map<String, dynamic>> result = await db.query('totalReceitas');
    for (var element in result) {
      print(element);
    }
    if (result.isNotEmpty) {
      // Acesse o valor 'totalReceitas' da primeira linha e converta para double.
      return result[0]['total_receitas'];
    } else {
      // Se não houver dados na tabela, retorne 0.0 ou outro valor padrão, dependendo da sua lógica.
      return 0.0;
    }
  }
}
