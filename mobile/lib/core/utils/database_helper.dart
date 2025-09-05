import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("clubs.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE clubs(
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        isFollowed INTEGER,
        short TEXT,
        league TEXT,
        logoUrl TEXT
      )
    ''');
    // Insert sample clubs for testing
    await _insertSampleClubs(db);
  }

  Future<void> _insertSampleClubs(Database db) async {
    final sampleClubs = [
      {
        'id': '1',
        'name': 'Saint George',
        'description': 'Ethiopian Premier League club based in Addis Ababa.',
        'isFollowed': 0,
        'short': 'SG',
        'league': 'ETH',
        'logoUrl': null,
      },
      {
        'id': '2',
        'name': 'Ethiopian Coffee',
        'description': 'Popular club from Addis Ababa.',
        'isFollowed': 0,
        'short': 'EC',
        'league': 'ETH',
        'logoUrl': null,
      },
      {
        'id': '3',
        'name': 'Manchester United',
        'description': 'English Premier League club.',
        'isFollowed': 0,
        'short': 'MU',
        'league': 'EPL',
        'logoUrl': null,
      },
      {
        'id': '4',
        'name': 'Chelsea',
        'description': 'English Premier League club.',
        'isFollowed': 0,
        'short': 'CHE',
        'league': 'EPL',
        'logoUrl':
            "https://upload.wikimedia.org/wikipedia/hif/0/0d/Chelsea_FC.png",
      },
    ];
    for (final club in sampleClubs) {
      await db.insert('clubs', club);
    }
  }
}
