import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:ethio_football/core/utils/database_helper.dart';
import 'package:ethio_football/features/my_clubs/data/data_sources/my_clubs_local_data.dart';
import 'package:ethio_football/features/my_clubs/data/models/club_model.dart';
import 'package:ethio_football/features/my_clubs/domain/entities/club.dart';

void main() {
  late MyClubsLocalDataSourceImpl dataSource;

  setUpAll(() {
    // initialize ffi loader for SQLite
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    // Reset DB before each test
    final dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;
    await db.delete("clubs");

    dataSource = MyClubsLocalDataSourceImpl();

    // Insert some fake clubs
    await db.insert(
      "clubs",
      ClubModel(
        id: "1",
        name: "Manchester United",
        description: "English club",
        isFollowed: false,
        short: "MUFC",
        league: League.EPL,
        logoUrl: null,
      ).toMap(),
    );

    await db.insert(
      "clubs",
      ClubModel(
        id: "2",
        name: "St George",
        description: "Ethiopian club",
        isFollowed: true,
        short: "SG",
        league: League.ETH,
        logoUrl: null,
      ).toMap(),
    );
  });

  test("getAllClubs returns all clubs", () async {
    final result = await dataSource.getAllClubs();
    expect(result.isRight(), true);

    result.fold((_) => fail("Should not fail"), (clubs) {
      expect(clubs.length, 2);
      expect(clubs.first.name, "Manchester United");
    });
  });

  test("getAllFollowedClubs returns only followed clubs", () async {
    final result = await dataSource.getAllFollowedClubs();
    expect(result.isRight(), true);

    result.fold((_) => fail("Should not fail"), (clubs) {
      expect(clubs.length, 1);
      expect(clubs.first.name, "St George");
    });
  });

  test("followClub updates a club to followed", () async {
    await dataSource.followClub("1");
    final result = await dataSource.getAllFollowedClubs();

    result.fold((_) => fail("Should not fail"), (clubs) {
      expect(clubs.length, 2);
    });
  });

  test("unfollowClub updates a club to unfollowed", () async {
    await dataSource.unfollowClub("2");
    final result = await dataSource.getAllFollowedClubs();

    result.fold((_) => fail("Should not fail"), (clubs) {
      expect(clubs.length, 0);
    });
  });

  test("searchClub finds clubs by query", () async {
    final result = await dataSource.searchClub("man");
    expect(result.isRight(), true);

    result.fold((_) => fail("Should not fail"), (clubs) {
      expect(clubs.length, 1);
      expect(clubs.first.name, "Manchester United");
    });
  });

  test("filterClub returns clubs from given league", () async {
    final result = await dataSource.filterClub(League.ETH);
    expect(result.isRight(), true);

    result.fold((_) => fail("Should not fail"), (clubs) {
      expect(clubs.length, 1);
      expect(clubs.first.name, "St George");
    });
  });
}
