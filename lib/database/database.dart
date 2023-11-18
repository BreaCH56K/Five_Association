import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BancoDeDados {
  BancoDeDados();

  BancoDeDados._();

  static final BancoDeDados instance = BancoDeDados._();

  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'five18.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, versao) async {
    await db.execute(_despesas);
    await db.execute(_receitas);
    await db.execute(_historico);
    await db.execute(_totalDespesas);
    await db.execute(_totalReceitas);
    await db.execute(_insertTotalDespesas);
    await db.execute(_insertTotalReceitas);
  }

  String get _despesas => '''
      CREATE TABLE despesas (
        id_despesa INTEGER PRIMARY KEY AUTOINCREMENT,
        valor_despesa REAL,
        data_despesa TEXT
      );
  ''';

  String get _receitas => '''
      CREATE TABLE receitas (
        id_receita INTEGER PRIMARY KEY AUTOINCREMENT,
        valor_receita REAL,
        data_receita TEXT
      );
  ''';

  String get _historico => '''
      CREATE TABLE historico (
        id_historico INTEGER PRIMARY KEY AUTOINCREMENT,
        valor REAL,
        data TEXT,
        tipo TEXT
      );
  ''';

  String get _totalDespesas => '''
      CREATE TABLE totalDespesas (
        id_totalDespesas INTEGER PRIMARY KEY AUTOINCREMENT,
        total_despesas REAL
      );
  ''';

  String get _totalReceitas => '''
      CREATE TABLE totalReceitas (
        id_totalReceitas INTEGER PRIMARY KEY AUTOINCREMENT,
        total_receitas REAL     
      );
  ''';

  String get _insertTotalDespesas => '''
      INSERT INTO totalDespesas (id_totalDespesas, total_despesas) VALUES (1, 0);
''';

  String get _insertTotalReceitas => '''
        INSERT INTO totalReceitas (id_totalReceitas, total_receitas) VALUES (1, 0);
  ''';
}
