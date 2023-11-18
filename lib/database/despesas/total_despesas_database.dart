import 'package:rh_app/database/database.dart';
import 'package:rh_app/database/despesas/total_despesas_model.dart';
import 'package:sqflite/sqflite.dart';

class TotalDespesasDatabase extends BancoDeDados {
  Future<void> insertTotalDespesa(TotalDespesasModel totalDespesaModel) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;
    // Insere a questao na tabela correta. Você também pode especificar o
    // 'conflictAlgorithm' para usar caso a mesma questao seja inserida duas vezes.
    // Neste caso, substitua quaisquer dados anteriores.
    await db.insert(
      'totalDespesas',
      totalDespesaModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTotalDespesas(
      TotalDespesasModel totalDespesasModel) async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    // Atualiza a Questao fornecida.
    await db.update(
      'totalDespesas',
      totalDespesasModel.toMap(),
      // Certifique-se de que o PROVA tenha um id correspondente.
      where: "id_totalDespesas = ?",
      // Passa o id do PROVA como whereArg para evitar injeção de SQL.
      whereArgs: [totalDespesasModel.idTotalDespesas],
    );
  }

  // Um ​​método que recupera todos os dados PROVA da tabela PROVA.
  Future<List<TotalDespesasModel>> recuperarTotalDespesas() async {
    //Pega a refêrencia do banco de dados.
    Database db = await BancoDeDados.instance.database;

    // Consulta a tabela para todos os PROVA
    final List<Map<String, dynamic>> maps = await db.query('totalDespesas');

    // Converte o List<Map<String, dynamic> em um List<QuestaoModel>.
    return List.generate(
      maps.length,
      (i) {
        return TotalDespesasModel(
          idTotalDespesas: maps[i]['id_totalDespesas'],
          totalDespesas: maps[i]['total_despesas'],
        );
      },
    );
  }

  Future<double> recuperarTotalDespesasDoBanco() async {
    Database db = await BancoDeDados.instance.database;

    // Realize uma consulta SQL para obter o valor diretamente do banco de dados.
    final List<Map<String, dynamic>> result = await db.query('totalDespesas');
    for (var element in result) {
      print(element);
    }
    if (result.isNotEmpty) {
      // Acesse o valor 'totalDespesas' da primeira linha e converta para double.
      return result[0]['total_despesas'];
    } else {
      // Se não houver dados na tabela, retorne 0.0 ou outro valor padrão, dependendo da sua lógica.
      return 0.0;
    }
  }
}
