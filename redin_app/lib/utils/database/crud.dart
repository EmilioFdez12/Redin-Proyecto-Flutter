import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Clase que gestiona las operaciones de base de datos (CRUD).
/// Esta clase utiliza SQLite para almacenar y recuperar el saldo del usuario.
class Crud {
  static final Crud _instance = Crud._internal();
  static Database? _database;

  /// Constructor factory para devolver la instancia única de la clase.
  factory Crud() {
    return _instance;
  }

  /// Constructor interno para la instancia única.
  Crud._internal();

  /// Getter para obtener la base de datos.
  /// Si la base de datos no está inicializada, la inicializa.
  Future<Database> get database async {
    if (_database != null) return _database!;
     // Inicializamos la base de datos si no lo está
    _database = await _initDatabase();
    return _database!;
  }

  /// Inicializa la base de datos y la crea si no existe.
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'redin.db');

    // Abre la base de datos y la crea si no existe
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Método que se ejecuta al crear la base de datos por primera vez.
  /// Crea la tabla `balance` e inserta un saldo inicial.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE balance(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount INTEGER NOT NULL
      )
    '''); // Crea la tabla `balance`

    // Inserta un saldo inicial de 100000 monedas
    await db.insert('balance', {'amount': 100000});
  }

  /// Obtiene el saldo actual desde la base de datos.
  /// 
  /// Devuelve el saldo como un entero. Si no hay datos, devuelve 0.
  Future<int> getBalance() async {
    final db = await database;
    final result = await db.query('balance', limit: 1);
    return result.isNotEmpty ? result.first['amount'] as int : 0;
  }

  /// Actualiza el saldo en la base de datos.
  /// 
  /// [newBalance]: El nuevo saldo a guardar.
  Future<void> updateBalance(int newBalance) async {
    final db = await database; 
    await db.update(
      'balance',
      {'amount': newBalance}, 
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}