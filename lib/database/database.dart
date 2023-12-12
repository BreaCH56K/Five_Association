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
      join(await getDatabasesPath(), 'five28.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, versao) async {
    await db.execute(_despesas);
    await db.execute(_receitas);
    await db.execute(_historico);
    await db.execute(_categoriasDepesas);
    await db.execute(_categoriasReceitas);
  }

  String get _despesas => '''
      CREATE TABLE despesas (
        id_despesa INTEGER PRIMARY KEY AUTOINCREMENT,
        valor_despesa REAL,
        data_despesa TEXT,
        categoria TEXT
      );
  ''';

  String get _receitas => '''
      CREATE TABLE receitas (
        id_receita INTEGER PRIMARY KEY AUTOINCREMENT,
        valor_receita REAL,
        data_receita TEXT,
        categoria TEXT
      );
  ''';

  String get _historico => '''
      CREATE TABLE historico (
        id_historico INTEGER PRIMARY KEY AUTOINCREMENT,
        valor REAL,
        data TEXT,
        tipo TEXT,
        categoria TEXT
      );
  ''';

  String get _categoriasDepesas => '''
        CREATE TABLE categoriaDespesas (
          id_categoriaDespesas INTEGER PRIMARY KEY AUTOINCREMENT,
          categoriaDespesas TEXT
        );
  ''';

  String get _categoriasReceitas => '''
        CREATE TABLE categoriaReceitas (
          id_categoriaReceitas INTEGER PRIMARY KEY AUTOINCREMENT,
          categoriaReceitas TEXT
        );
  ''';
}
