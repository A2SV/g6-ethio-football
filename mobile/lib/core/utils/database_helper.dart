import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

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

  /// Get all clubs from the database
  Future<List<Map<String, dynamic>>> getClubs() async {
    final db = await database;
    return await db.query('clubs');
  }

  /// Insert standings data
  Future<void> insertStandings(
    String league,
    List<Map<String, dynamic>> standings,
  ) async {
    final db = await database;
    final batch = db.batch();
    for (final standing in standings) {
      final data = Map<String, dynamic>.from(standing);
      data['league'] = league;
      batch.insert(
        'standings',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  /// Get standings data
  Future<List<Map<String, dynamic>>> getStandings(String league) async {
    final db = await database;
    return await db.query(
      'standings',
      where: 'league = ?',
      whereArgs: [league],
    );
  }

  /// Insert fixtures data
  Future<void> insertFixtures(List<Map<String, dynamic>> fixtures) async {
    final db = await database;
    final batch = db.batch();
    for (final fixture in fixtures) {
      batch.insert(
        'fixtures',
        fixture,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  /// Get fixtures data
  Future<List<Map<String, dynamic>>> getFixtures({
    String? league,
    int? limit,
  }) async {
    final db = await database;
    String? where;
    List<String>? whereArgs;
    if (league != null) {
      where = 'league = ?';
      whereArgs = [league];
    }
    return await db.query(
      'fixtures',
      where: where,
      whereArgs: whereArgs,
      limit: limit,
    );
  }

  /// Insert live scores data
  Future<void> insertLiveScores(List<Map<String, dynamic>> liveScores) async {
    final db = await database;
    final batch = db.batch();
    for (final score in liveScores) {
      batch.insert(
        'live_scores',
        score,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  /// Get live scores data
  Future<List<Map<String, dynamic>>> getLiveScores() async {
    final db = await database;
    return await db.query('live_scores');
  }

  /// Insert previous fixtures data
  Future<void> insertPreviousFixtures(
    List<Map<String, dynamic>> fixtures,
  ) async {
    final db = await database;
    final batch = db.batch();
    for (final fixture in fixtures) {
      batch.insert(
        'previous_fixtures',
        fixture,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  /// Get previous fixtures data
  Future<List<Map<String, dynamic>>> getPreviousFixtures({
    String? league,
    int? limit,
  }) async {
    final db = await database;
    String? where;
    List<String>? whereArgs;
    if (league != null) {
      where = 'league = ?';
      whereArgs = [league];
    }
    return await db.query(
      'previous_fixtures',
      where: where,
      whereArgs: whereArgs,
      limit: limit,
    );
  }

  /// Clear chat messages
  Future<void> clearChatMessages() async {
    final db = await database;
    await db.delete('chat_messages');
  }
}
