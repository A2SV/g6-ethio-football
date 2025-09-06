import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static final DatabaseHelper instance = _instance;
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'football_app.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Standings table
    await db.execute('''
      CREATE TABLE standings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        league TEXT NOT NULL,
        position INTEGER NOT NULL,
        team TEXT NOT NULL,
        points INTEGER NOT NULL,
        matchPlayed INTEGER NOT NULL,
        wins INTEGER NOT NULL,
        lose INTEGER NOT NULL,
        draw INTEGER NOT NULL,
        gd INTEGER NOT NULL,
        lastUpdated TEXT NOT NULL,
        UNIQUE(league, position)
      )
    ''');

    // Fixtures table
    await db.execute('''
      CREATE TABLE fixtures(
        id TEXT PRIMARY KEY,
        league TEXT NOT NULL,
        homeTeam TEXT NOT NULL,
        awayTeam TEXT NOT NULL,
        kickoff TEXT NOT NULL,
        status TEXT NOT NULL,
        score TEXT,
        lastUpdated TEXT NOT NULL
      )
    ''');

    // Live scores table
    await db.execute('''
      CREATE TABLE live_scores(
        id TEXT PRIMARY KEY,
        league TEXT NOT NULL,
        homeTeam TEXT NOT NULL,
        awayTeam TEXT NOT NULL,
        kickoff TEXT NOT NULL,
        status TEXT NOT NULL,
        score TEXT NOT NULL,
        lastUpdated TEXT NOT NULL
      )
    ''');

    // User preferences table
    await db.execute('''
      CREATE TABLE user_preferences(
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    // Clubs table
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

    // Insert sample clubs
    await _insertSampleClubs(db);
  }

  Future<void> _insertSampleClubs(Database db) async {
    final sampleClubs = [
      {
        'id': '1',
        'name': 'Saint George',
        'description':
            'Ethiopian Premier League club based in Addis Ababa. Known for their passionate fanbase and historic achievements.',
        'isFollowed': 0,
        'short': 'SG',
        'league': 'ETH',
        'logoUrl': null,
      },
      {
        'id': '2',
        'name': 'Ethiopian Coffee',
        'description':
            'Popular club from Addis Ababa with a rich history in Ethiopian football.',
        'isFollowed': 0,
        'short': 'EC',
        'league': 'ETH',
        'logoUrl': null,
      },
      {
        'id': '3',
        'name': 'Awassa City',
        'description':
            'Dynamic club from Awassa representing the southern region of Ethiopia.',
        'isFollowed': 0,
        'short': 'AC',
        'league': 'ETH',
        'logoUrl': null,
      },
      {
        'id': '4',
        'name': 'Adama City',
        'description':
            'Rising club from Adama with growing reputation in Ethiopian football.',
        'isFollowed': 0,
        'short': 'ADC',
        'league': 'ETH',
        'logoUrl': null,
      },
      {
        'id': '5',
        'name': 'Bahir Dar Kenema',
        'description':
            'Historic club from Bahir Dar with multiple league titles.',
        'isFollowed': 0,
        'short': 'BDK',
        'league': 'ETH',
        'logoUrl': null,
      },
      {
        'id': '6',
        'name': 'Dire Dawa City',
        'description':
            'Eastern Ethiopia\'s premier football club with dedicated supporters.',
        'isFollowed': 0,
        'short': 'DDC',
        'league': 'ETH',
        'logoUrl': null,
      },
      {
        'id': '7',
        'name': 'Hadiya Hossana',
        'description':
            'Club representing the Hadiya zone with growing competitive spirit.',
        'isFollowed': 0,
        'short': 'HH',
        'league': 'ETH',
        'logoUrl': null,
      },
      {
        'id': '8',
        'name': 'Jimma Aba Jifar',
        'description':
            'Western Ethiopia\'s football powerhouse with rich traditions.',
        'isFollowed': 0,
        'short': 'JAJ',
        'league': 'ETH',
        'logoUrl': null,
      },
      {
        'id': '9',
        'name': 'Mekelle 70 Enderta',
        'description':
            'Northern Ethiopia\'s most successful club with numerous championships.',
        'isFollowed': 0,
        'short': 'M70E',
        'league': 'ETH',
        'logoUrl': null,
      },
      {
        'id': '10',
        'name': 'Manchester United',
        'description':
            'English Premier League giant with 20 league titles and global fanbase.',
        'isFollowed': 0,
        'short': 'MU',
        'league': 'EPL',
        'logoUrl': null,
      },
      {
        'id': '11',
        'name': 'Chelsea',
        'description':
            'London-based Premier League club with 6 Champions League titles.',
        'isFollowed': 0,
        'short': 'CHE',
        'league': 'EPL',
        'logoUrl':
            "https://upload.wikimedia.org/wikipedia/hif/0/0d/Chelsea_FC.png",
      },
      {
        'id': '12',
        'name': 'Arsenal',
        'description':
            'North London club with 13 Premier League titles and rich history.',
        'isFollowed': 0,
        'short': 'ARS',
        'league': 'EPL',
        'logoUrl': null,
      },
    ];

    for (final club in sampleClubs) {
      await db.insert('clubs', club);
    }
  }

  // ------------------ Standings operations ------------------
  Future<void> insertStandings(
    String league,
    List<Map<String, dynamic>> standings,
  ) async {
    final db = await database;
    await db.delete('standings', where: 'league = ?', whereArgs: [league]);

    for (final standing in standings) {
      await db.insert('standings', {
        'league': league,
        'position': standing['position'],
        'team': standing['team'],
        'points': standing['points'],
        'matchPlayed': standing['matchPlayed'],
        'wins': standing['wins'],
        'lose': standing['lose'],
        'draw': standing['draw'],
        'gd': standing['gd'],
        'lastUpdated': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<List<Map<String, dynamic>>> getStandings(String league) async {
    final db = await database;
    return await db.query(
      'standings',
      where: 'league = ?',
      whereArgs: [league],
      orderBy: 'position ASC',
    );
  }

  // ------------------ Fixtures operations ------------------
  Future<void> insertFixtures(List<Map<String, dynamic>> fixtures) async {
    final db = await database;
    await db.delete('fixtures');

    for (final fixture in fixtures) {
      await db.insert('fixtures', {
        'id': fixture['id'],
        'league': fixture['league'],
        'homeTeam': fixture['homeTeam'],
        'awayTeam': fixture['awayTeam'],
        'kickoff': fixture['kickoff'],
        'status': fixture['status'],
        'score': fixture['score'],
        'lastUpdated': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<List<Map<String, dynamic>>> getFixtures({String? league}) async {
    final db = await database;
    if (league != null) {
      return await db.query(
        'fixtures',
        where: 'league = ?',
        whereArgs: [league],
        orderBy: 'kickoff ASC',
      );
    }
    return await db.query('fixtures', orderBy: 'kickoff ASC');
  }

  // ------------------ Live scores operations ------------------
  Future<void> insertLiveScores(List<Map<String, dynamic>> liveScores) async {
    final db = await database;
    await db.delete('live_scores');

    for (final liveScore in liveScores) {
      await db.insert('live_scores', {
        'id': liveScore['id'],
        'league': liveScore['league'],
        'homeTeam': liveScore['homeTeam'],
        'awayTeam': liveScore['awayTeam'],
        'kickoff': liveScore['kickoff'],
        'status': liveScore['status'],
        'score': liveScore['score'],
        'lastUpdated': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<List<Map<String, dynamic>>> getLiveScores() async {
    final db = await database;
    return await db.query('live_scores', orderBy: 'kickoff ASC');
  }

  // ------------------ User preferences operations ------------------
  Future<void> setPreference(String key, String value) async {
    final db = await database;
    await db.insert('user_preferences', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getPreference(String key) async {
    final db = await database;
    final result = await db.query(
      'user_preferences',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return result.isNotEmpty ? result.first['value'] as String? : null;
  }

  // ------------------ Clubs operations ------------------
  Future<List<Map<String, dynamic>>> getClubs() async {
    final db = await database;
    return await db.query('clubs');
  }

  Future<bool> hasClubs() async {
    final db = await database;
    final result = await db.query('clubs', limit: 1);
    return result.isNotEmpty;
  }

  Future<void> ensureClubsSeeded() async {
    if (!(await hasClubs())) {
      await _insertSampleClubs(await database);
    }
  }

  Future<void> updateClubFollowStatus(String id, bool isFollowed) async {
    final db = await database;
    await db.update(
      'clubs',
      {'isFollowed': isFollowed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ------------------ Clear all data ------------------
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('standings');
    await db.delete('fixtures');
    await db.delete('live_scores');
    await db.delete('clubs');
  }

  // ------------------ Close database ------------------
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
