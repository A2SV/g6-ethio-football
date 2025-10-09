import 'package:bloc/bloc.dart';
import 'package:ethio_football/core/utils/database_helper.dart';
import '../../domain/usecases.dart';
import '../../domain/entities.dart';
import 'football_event.dart';
import 'football_state.dart';

class FootballBloc extends Bloc<FootballEvent, FootballState> {
  final GetStandings getStandings;
  final GetFixtures getFixtures;
  final GetLiveScores getLiveScores;
  final GetPreviousFixtures getPreviousFixtures;
  final GetLiveMatches getLiveMatches;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  FootballBloc({
    required this.getStandings,
    required this.getFixtures,
    required this.getLiveScores,
    required this.getPreviousFixtures,
    required this.getLiveMatches,
  }) : super(FootballInitial()) {
    on<LoadStandings>(_onLoadStandings);
    on<LoadFixtures>(_onLoadFixtures);
    on<LoadLiveScores>(_onLoadLiveScores);
    on<LoadPreviousFixtures>(_onLoadPreviousFixtures);
    on<LoadLiveMatches>(_onLoadLiveMatches);
    on<ChangeLeague>(_onChangeLeague);
    on<RefreshData>(_onRefreshData);
    on<LoadFixturesByDate>(_onLoadFixturesByDate);

    // Initialize mock data if database is empty
    _initializeMockDataIfNeeded();
  }

  Future<void> _initializeMockDataIfNeeded() async {
    try {
      // Check if we have any previous fixtures in the database
      final existingFixtures = await _dbHelper.getPreviousFixtures(limit: 1);
      if (existingFixtures.isEmpty) {
        print(
          '🔍 [BLOC_DEBUG] No existing fixtures found, initializing mock data...',
        );

        // Insert mock data for both leagues
        final ethMockFixtures = _getMockPreviousFixtures('ETH');
        final eplMockFixtures = _getMockPreviousFixtures('EPL');

        final allMockFixtures = [...ethMockFixtures, ...eplMockFixtures];

        final mockFixturesData = allMockFixtures
            .map(
              (fixture) => {
                'fixture_id': fixture.fixtureId,
                'date': fixture.date.toIso8601String(),
                'venue': fixture.venue,
                'league': fixture.league,
                'round': fixture.round,
                'home_team_name': fixture.homeTeam.name,
                'home_team_logo': fixture.homeTeam.logo,
                'away_team_name': fixture.awayTeam.name,
                'away_team_logo': fixture.awayTeam.logo,
                'home_goals': fixture.goals.home,
                'away_goals': fixture.goals.away,
                'halftime_home': fixture.score.halftime.home,
                'halftime_away': fixture.score.halftime.away,
                'fulltime_home': fixture.score.fulltime.home,
                'fulltime_away': fixture.score.fulltime.away,
                'extratime_home': fixture.score.extratime?.home,
                'extratime_away': fixture.score.extratime?.away,
                'penalty_home': fixture.score.penalty?.home,
                'penalty_away': fixture.score.penalty?.away,
                'status_long': fixture.status.long,
                'status_short': fixture.status.short,
                'status_elapsed': fixture.status.elapsed,
                'status_extra': fixture.status.extra,
              },
            )
            .toList();

        await _dbHelper.insertPreviousFixtures(mockFixturesData);
        print(
          '🔍 [BLOC_DEBUG] Successfully initialized ${mockFixturesData.length} mock fixtures',
        );
      }
    } catch (e) {
      print('🔍 [BLOC_DEBUG] Error initializing mock data: $e');
    }
  }

  Future<void> _onLoadStandings(
    LoadStandings event,
    Emitter<FootballState> emit,
  ) async {
    try {
      emit(FootballLoading());
      final result = await getStandings.call(event.league);
      final standings = result['standings'] as List<Standing>;
      final season = result['season'] as int?;
      emit(
        FootballLoaded(
          standings: standings,
          fixtures: [],
          liveScores: [],
          selectedLeague: event.league,
          season: season,
        ),
      );
    } catch (e) {
      // Provide mock data when API fails
      final mockStandings = _getMockStandings(event.league);
      emit(
        FootballLoaded(
          standings: mockStandings,
          fixtures: [],
          liveScores: [],
          selectedLeague: event.league,
          season: DateTime.now().year, // Fallback season
        ),
      );
    }
  }

  Future<void> _onLoadFixtures(
    LoadFixtures event,
    Emitter<FootballState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is FootballLoaded) {
        emit(FootballLoading());
      }
      final fixtures = await getFixtures.call(league: event.league);
      if (currentState is FootballLoaded) {
        emit(currentState.copyWith(fixtures: fixtures));
      } else {
        emit(
          FootballLoaded(
            standings: [],
            fixtures: fixtures,
            liveScores: [],
            selectedLeague: event.league,
          ),
        );
      }
    } catch (e) {
      // Provide mock data when API fails
      final mockFixtures = _getMockFixtures(event.league);
      final currentState = state;
      if (currentState is FootballLoaded) {
        emit(currentState.copyWith(fixtures: mockFixtures));
      } else {
        emit(
          FootballLoaded(
            standings: [],
            fixtures: mockFixtures,
            liveScores: [],
            selectedLeague: event.league,
          ),
        );
      }
    }
  }

  Future<void> _onLoadLiveScores(
    LoadLiveScores event,
    Emitter<FootballState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is FootballLoaded) {
        emit(FootballLoading());
      }
      final liveScores = await getLiveScores.call();
      if (currentState is FootballLoaded) {
        emit(currentState.copyWith(liveScores: liveScores));
      } else {
        emit(
          FootballLoaded(
            standings: [],
            fixtures: [],
            liveScores: liveScores,
            selectedLeague: 'ETH',
          ),
        );
      }
    } catch (e) {
      // Provide mock data when API fails
      final mockLiveScores = _getMockLiveScores();
      final currentState = state;
      if (currentState is FootballLoaded) {
        emit(currentState.copyWith(liveScores: mockLiveScores));
      } else {
        emit(
          FootballLoaded(
            standings: [],
            fixtures: [],
            liveScores: mockLiveScores,
            selectedLeague: 'ETH',
          ),
        );
      }
    }
  }

  Future<void> _onChangeLeague(
    ChangeLeague event,
    Emitter<FootballState> emit,
  ) async {
    final currentState = state;
    if (currentState is FootballLoaded) {
      emit(currentState.copyWith(selectedLeague: event.league));
      // Reload data for the new league
      add(LoadStandings(event.league));
      add(LoadFixtures(event.league));
      add(LoadLiveMatches(event.league));
      // Load previous fixtures for the new league - use 2021 for historical data
      print(
        '🔍 [PREVIOUS_FIXTURES_DEBUG] Loading previous fixtures for ${event.league} league, season 2021',
      );
      add(LoadPreviousFixtures(league: event.league, round: 1, season: 2021));
    }
  }

  Future<void> _onRefreshData(
    RefreshData event,
    Emitter<FootballState> emit,
  ) async {
    final currentState = state;
    if (currentState is FootballLoaded) {
      add(LoadStandings(currentState.selectedLeague));
      add(LoadFixtures(currentState.selectedLeague));
      add(LoadLiveScores());
      // Load previous fixtures with 2021 for historical data
      print(
        '🔍 [PREVIOUS_FIXTURES_DEBUG] Refreshing previous fixtures for ${currentState.selectedLeague} league, season 2021',
      );
      add(
        LoadPreviousFixtures(
          league: currentState.selectedLeague,
          round: 1,
          season: 2021,
        ),
      );
      add(LoadLiveMatches(currentState.selectedLeague));
    }
  }

  Future<void> _onLoadPreviousFixtures(
    LoadPreviousFixtures event,
    Emitter<FootballState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is FootballLoaded) {
        emit(FootballLoading());
      }
      final previousFixtures = await getPreviousFixtures.call(
        league: event.league,
        round: event.round,
        season: event.season,
      );
      if (currentState is FootballLoaded) {
        emit(currentState.copyWith(previousFixtures: previousFixtures));
      } else {
        emit(
          FootballLoaded(
            standings: [],
            fixtures: [],
            liveScores: [],
            previousFixtures: previousFixtures,
            liveMatches: [],
            selectedLeague: event.league,
          ),
        );
      }
    } catch (e) {
      // Log error and provide mock data if API fails
      print(
        '🔍 [PREVIOUS_FIXTURES_DEBUG] Failed to load previous fixtures: $e',
      );
      print('🔍 [PREVIOUS_FIXTURES_DEBUG] Using mock data as fallback');

      // Insert mock data into database for future use
      final mockFixtures = _getMockPreviousFixtures(event.league);
      print(
        '🔍 [PREVIOUS_FIXTURES_DEBUG] Generated ${mockFixtures.length} mock fixtures for ${event.league}',
      );

      try {
        final mockFixturesData = mockFixtures
            .map(
              (fixture) => {
                'fixture_id': fixture.fixtureId,
                'date': fixture.date.toIso8601String(),
                'venue': fixture.venue,
                'league': fixture.league,
                'round': fixture.round,
                'home_team_name': fixture.homeTeam.name,
                'home_team_logo': fixture.homeTeam.logo,
                'away_team_name': fixture.awayTeam.name,
                'away_team_logo': fixture.awayTeam.logo,
                'home_goals': fixture.goals.home,
                'away_goals': fixture.goals.away,
                'halftime_home': fixture.score.halftime.home,
                'halftime_away': fixture.score.halftime.away,
                'fulltime_home': fixture.score.fulltime.home,
                'fulltime_away': fixture.score.fulltime.away,
                'extratime_home': fixture.score.extratime?.home,
                'extratime_away': fixture.score.extratime?.away,
                'penalty_home': fixture.score.penalty?.home,
                'penalty_away': fixture.score.penalty?.away,
                'status_long': fixture.status.long,
                'status_short': fixture.status.short,
                'status_elapsed': fixture.status.elapsed,
                'status_extra': fixture.status.extra,
              },
            )
            .toList();

        await _dbHelper.insertPreviousFixtures(mockFixturesData);
        print(
          '🔍 [PREVIOUS_FIXTURES_DEBUG] Successfully cached ${mockFixturesData.length} mock fixtures',
        );
      } catch (dbError) {
        print(
          '🔍 [PREVIOUS_FIXTURES_DEBUG] Failed to cache mock fixtures: $dbError',
        );
      }

      final currentState = state;
      if (currentState is FootballLoaded) {
        print(
          '🔍 [PREVIOUS_FIXTURES_DEBUG] Updating state with ${mockFixtures.length} mock fixtures',
        );
        emit(currentState.copyWith(previousFixtures: mockFixtures));
      } else {
        print(
          '🔍 [PREVIOUS_FIXTURES_DEBUG] Creating new state with ${mockFixtures.length} mock fixtures',
        );
        emit(
          FootballLoaded(
            standings: [],
            fixtures: [],
            liveScores: [],
            previousFixtures: mockFixtures,
            liveMatches: [],
            selectedLeague: event.league,
          ),
        );
      }
    }
  }

  Future<void> _onLoadLiveMatches(
    LoadLiveMatches event,
    Emitter<FootballState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is FootballLoaded) {
        emit(FootballLoading());
      }
      final liveMatches = await getLiveMatches.call(event.league);
      if (currentState is FootballLoaded) {
        emit(currentState.copyWith(liveMatches: liveMatches));
      } else {
        emit(
          FootballLoaded(
            standings: [],
            fixtures: [],
            liveScores: [],
            previousFixtures: [],
            liveMatches: liveMatches,
            selectedLeague: event.league,
          ),
        );
      }
    } catch (e) {
      // Log error and return empty list if API fails
      print('Failed to load live matches: $e');
      final currentState = state;
      if (currentState is FootballLoaded) {
        emit(currentState.copyWith(liveMatches: []));
      }
    }
  }

  Future<void> _onLoadFixturesByDate(
    LoadFixturesByDate event,
    Emitter<FootballState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is FootballLoaded) {
        emit(FootballLoading());
      }

      // Fetch fixtures for the specific date
      final fixtures = await getFixtures.call(
        league: event.league,
        from: event.date,
        to: event.date,
      );

      if (currentState is FootballLoaded) {
        emit(
          currentState.copyWith(fixtures: fixtures, selectedDate: event.date),
        );
      } else {
        emit(
          FootballLoaded(
            standings: [],
            fixtures: fixtures,
            liveScores: [],
            previousFixtures: [],
            liveMatches: [],
            selectedLeague: event.league,
            selectedDate: event.date,
          ),
        );
      }
    } catch (e) {
      print('Failed to load fixtures for date: $e');
      final currentState = state;
      if (currentState is FootballLoaded) {
        emit(currentState.copyWith(fixtures: []));
      }
    }
  }

  List<Fixture> _getMockFixtures(String league) {
    final now = DateTime.now();
    if (league == 'ETH') {
      return [
        Fixture(
          id: '1',
          homeTeam: 'St. George',
          awayTeam: 'Ethio Bunna',
          league: 'ETH',
          kickoff: now.add(const Duration(hours: 2)),
          status: 'SCHEDULED',
          score: null,
        ),
        Fixture(
          id: '2',
          homeTeam: 'Awassa City',
          awayTeam: 'Adama Kenema',
          league: 'ETH',
          kickoff: now.add(const Duration(hours: 4)),
          status: 'SCHEDULED',
          score: null,
        ),
        Fixture(
          id: '3',
          homeTeam: 'Bahir Dar Kenema',
          awayTeam: 'Mekelle 70 Enderta',
          league: 'ETH',
          kickoff: now.add(const Duration(hours: 6)),
          status: 'SCHEDULED',
          score: null,
        ),
        Fixture(
          id: '4',
          homeTeam: 'Dire Dawa City',
          awayTeam: 'Hadiya Hossana',
          league: 'ETH',
          kickoff: now.add(const Duration(hours: 8)),
          status: 'SCHEDULED',
          score: null,
        ),
        Fixture(
          id: '5',
          homeTeam: 'Jimma Aba Jifar',
          awayTeam: 'Welayta Dicha',
          league: 'ETH',
          kickoff: now.add(const Duration(hours: 10)),
          status: 'SCHEDULED',
          score: null,
        ),
        Fixture(
          id: '6',
          homeTeam: 'Ethio Electric',
          awayTeam: 'Fasil Kenema',
          league: 'ETH',
          kickoff: now.add(const Duration(days: 1, hours: 2)),
          status: 'SCHEDULED',
          score: null,
        ),
        Fixture(
          id: '7',
          homeTeam: 'Shire Endaselassie',
          awayTeam: 'Arba Minch City',
          league: 'ETH',
          kickoff: now.add(const Duration(days: 1, hours: 4)),
          status: 'SCHEDULED',
          score: null,
        ),
      ];
    } else {
      return [
        Fixture(
          id: '8',
          homeTeam: 'Manchester City',
          awayTeam: 'Arsenal',
          league: 'EPL',
          kickoff: now.add(const Duration(hours: 2)),
          status: 'SCHEDULED',
          score: null,
        ),
        Fixture(
          id: '9',
          homeTeam: 'Chelsea',
          awayTeam: 'Liverpool',
          league: 'EPL',
          kickoff: now.add(const Duration(hours: 4)),
          status: 'SCHEDULED',
          score: null,
        ),
        Fixture(
          id: '10',
          homeTeam: 'Manchester United',
          awayTeam: 'Tottenham',
          league: 'EPL',
          kickoff: now.add(const Duration(hours: 6)),
          status: 'SCHEDULED',
          score: null,
        ),
        Fixture(
          id: '11',
          homeTeam: 'Newcastle',
          awayTeam: 'West Ham',
          league: 'EPL',
          kickoff: now.add(const Duration(hours: 8)),
          status: 'SCHEDULED',
          score: null,
        ),
        Fixture(
          id: '12',
          homeTeam: 'Brighton',
          awayTeam: 'Aston Villa',
          league: 'EPL',
          kickoff: now.add(const Duration(hours: 10)),
          status: 'SCHEDULED',
          score: null,
        ),
        Fixture(
          id: '13',
          homeTeam: 'Crystal Palace',
          awayTeam: 'Fulham',
          league: 'EPL',
          kickoff: now.add(const Duration(days: 1, hours: 2)),
          status: 'SCHEDULED',
          score: null,
        ),
        Fixture(
          id: '14',
          homeTeam: 'Wolverhampton',
          awayTeam: 'Southampton',
          league: 'EPL',
          kickoff: now.add(const Duration(days: 1, hours: 4)),
          status: 'SCHEDULED',
          score: null,
        ),
        Fixture(
          id: '15',
          homeTeam: 'Brentford',
          awayTeam: 'Everton',
          league: 'EPL',
          kickoff: now.add(const Duration(days: 1, hours: 6)),
          status: 'SCHEDULED',
          score: null,
        ),
      ];
    }
  }

  List<Standing> _getMockStandings(String league) {
    if (league == 'ETH') {
      return [
        Standing(
          position: 1,
          team: 'St. George',
          teamLogo: '',
          points: 45,
          matchPlayed: 22,
          wins: 14,
          lose: 3,
          draw: 5,
          gd: 18,
        ),
        Standing(
          position: 2,
          team: 'Ethio Bunna',
          teamLogo: '',
          points: 42,
          matchPlayed: 22,
          wins: 13,
          lose: 4,
          draw: 5,
          gd: 15,
        ),
        Standing(
          position: 3,
          team: 'Awassa City',
          teamLogo: '',
          points: 38,
          matchPlayed: 22,
          wins: 11,
          lose: 4,
          draw: 7,
          gd: 12,
        ),
        Standing(
          position: 4,
          team: 'Adama Kenema',
          teamLogo: '',
          points: 35,
          matchPlayed: 22,
          wins: 10,
          lose: 5,
          draw: 7,
          gd: 8,
        ),
        Standing(
          position: 5,
          team: 'Bahir Dar Kenema',
          teamLogo: '',
          points: 33,
          matchPlayed: 22,
          wins: 9,
          lose: 5,
          draw: 8,
          gd: 6,
        ),
        Standing(
          position: 6,
          team: 'Dire Dawa City',
          teamLogo: '',
          points: 31,
          matchPlayed: 22,
          wins: 8,
          lose: 5,
          draw: 9,
          gd: 4,
        ),
        Standing(
          position: 7,
          team: 'Hadiya Hossana',
          teamLogo: '',
          points: 29,
          matchPlayed: 22,
          wins: 7,
          lose: 6,
          draw: 9,
          gd: 2,
        ),
        Standing(
          position: 8,
          team: 'Jimma Aba Jifar',
          teamLogo: '',
          points: 27,
          matchPlayed: 22,
          wins: 6,
          lose: 6,
          draw: 10,
          gd: 0,
        ),
        Standing(
          position: 9,
          team: 'Mekelle 70 Enderta',
          teamLogo: '',
          points: 25,
          matchPlayed: 22,
          wins: 5,
          lose: 7,
          draw: 10,
          gd: -2,
        ),
        Standing(
          position: 10,
          team: 'Welayta Dicha',
          teamLogo: '',
          points: 23,
          matchPlayed: 22,
          wins: 4,
          lose: 8,
          draw: 10,
          gd: -4,
        ),
      ];
    } else {
      return [
        Standing(
          position: 1,
          team: 'Manchester City',
          teamLogo: '',
          points: 54,
          matchPlayed: 22,
          wins: 17,
          lose: 1,
          draw: 4,
          gd: 32,
        ),
        Standing(
          position: 2,
          team: 'Arsenal',
          teamLogo: '',
          points: 52,
          matchPlayed: 22,
          wins: 16,
          lose: 2,
          draw: 4,
          gd: 28,
        ),
        Standing(
          position: 3,
          team: 'Chelsea',
          teamLogo: '',
          points: 50,
          matchPlayed: 22,
          wins: 15,
          lose: 2,
          draw: 5,
          gd: 26,
        ),
        Standing(
          position: 4,
          team: 'Liverpool',
          teamLogo: '',
          points: 48,
          matchPlayed: 22,
          wins: 14,
          lose: 2,
          draw: 6,
          gd: 24,
        ),
        Standing(
          position: 5,
          team: 'Tottenham',
          teamLogo: '',
          points: 44,
          matchPlayed: 22,
          wins: 13,
          lose: 4,
          draw: 5,
          gd: 20,
        ),
        Standing(
          position: 6,
          team: 'Manchester United',
          teamLogo: '',
          points: 42,
          matchPlayed: 22,
          wins: 12,
          lose: 4,
          draw: 6,
          gd: 18,
        ),
        Standing(
          position: 7,
          team: 'Newcastle',
          teamLogo: '',
          points: 40,
          matchPlayed: 22,
          wins: 11,
          lose: 4,
          draw: 7,
          gd: 16,
        ),
        Standing(
          position: 8,
          team: 'West Ham',
          teamLogo: '',
          points: 38,
          matchPlayed: 22,
          wins: 10,
          lose: 5,
          draw: 7,
          gd: 14,
        ),
        Standing(
          position: 9,
          team: 'Brighton',
          teamLogo: '',
          points: 36,
          matchPlayed: 22,
          wins: 9,
          lose: 5,
          draw: 8,
          gd: 12,
        ),
        Standing(
          position: 10,
          team: 'Aston Villa',
          teamLogo: '',
          points: 34,
          matchPlayed: 22,
          wins: 8,
          lose: 6,
          draw: 8,
          gd: 10,
        ),
        Standing(
          position: 11,
          team: 'Crystal Palace',
          teamLogo: '',
          points: 32,
          matchPlayed: 22,
          wins: 7,
          lose: 6,
          draw: 9,
          gd: 8,
        ),
        Standing(
          position: 12,
          team: 'Fulham',
          teamLogo: '',
          points: 30,
          matchPlayed: 22,
          wins: 6,
          lose: 7,
          draw: 9,
          gd: 6,
        ),
        Standing(
          position: 13,
          team: 'Wolverhampton',
          teamLogo: '',
          points: 28,
          matchPlayed: 22,
          wins: 5,
          lose: 8,
          draw: 9,
          gd: 4,
        ),
        Standing(
          position: 14,
          team: 'Southampton',
          teamLogo: '',
          points: 26,
          matchPlayed: 22,
          wins: 4,
          lose: 9,
          draw: 9,
          gd: 2,
        ),
        Standing(
          position: 15,
          team: 'Brentford',
          teamLogo: '',
          points: 24,
          matchPlayed: 22,
          wins: 3,
          lose: 10,
          draw: 9,
          gd: 0,
        ),
      ];
    }
  }

  List<LiveScore> _getMockLiveScores() {
    final now = DateTime.now();
    return [
      LiveScore(
        id: '1',
        homeTeam: 'St. George',
        awayTeam: 'Ethio Bunna',
        league: 'ETH',
        kickoff: now.subtract(const Duration(minutes: 30)),
        status: 'LIVE',
        score: '2-1',
      ),
      LiveScore(
        id: '2',
        homeTeam: 'Awassa City',
        awayTeam: 'Adama Kenema',
        league: 'ETH',
        kickoff: now.subtract(const Duration(minutes: 15)),
        status: 'LIVE',
        score: '1-1',
      ),
      LiveScore(
        id: '3',
        homeTeam: 'Chelsea',
        awayTeam: 'Liverpool',
        league: 'EPL',
        kickoff: now.subtract(const Duration(minutes: 45)),
        status: 'LIVE',
        score: '1-0',
      ),
      LiveScore(
        id: '4',
        homeTeam: 'Manchester City',
        awayTeam: 'Arsenal',
        league: 'EPL',
        kickoff: now.subtract(const Duration(minutes: 60)),
        status: 'LIVE',
        score: '3-2',
      ),
      LiveScore(
        id: '5',
        homeTeam: 'Manchester United',
        awayTeam: 'Tottenham',
        league: 'EPL',
        kickoff: now.subtract(const Duration(minutes: 75)),
        status: 'LIVE',
        score: '0-1',
      ),
    ];
  }

  List<PreviousFixture> _getMockPreviousFixtures(String league) {
    final now = DateTime.now();
    if (league == 'ETH') {
      return [
        PreviousFixture(
          fixtureId: 1,
          date: now.subtract(const Duration(days: 7)),
          venue: 'Addis Ababa Stadium',
          league: 'ETH',
          round: 'Round 22',
          homeTeam: Team(name: 'St. George', logo: ''),
          awayTeam: Team(name: 'Ethio Bunna', logo: ''),
          goals: Goals(home: 2, away: 1),
          score: Score(
            halftime: ScoreDetail(home: 1, away: 0),
            fulltime: ScoreDetail(home: 2, away: 1),
          ),
          status: MatchStatus(
            long: 'Match Finished',
            short: 'FT',
            elapsed: 90,
            extra: 0,
          ),
        ),
        PreviousFixture(
          fixtureId: 2,
          date: now.subtract(const Duration(days: 14)),
          venue: 'Awassa Stadium',
          league: 'ETH',
          round: 'Round 21',
          homeTeam: Team(name: 'Awassa City', logo: ''),
          awayTeam: Team(name: 'Adama Kenema', logo: ''),
          goals: Goals(home: 1, away: 1),
          score: Score(
            halftime: ScoreDetail(home: 0, away: 1),
            fulltime: ScoreDetail(home: 1, away: 1),
          ),
          status: MatchStatus(
            long: 'Match Finished',
            short: 'FT',
            elapsed: 90,
            extra: 0,
          ),
        ),
        PreviousFixture(
          fixtureId: 3,
          date: now.subtract(const Duration(days: 21)),
          venue: 'Bahir Dar Stadium',
          league: 'ETH',
          round: 'Round 20',
          homeTeam: Team(name: 'Bahir Dar Kenema', logo: ''),
          awayTeam: Team(name: 'Mekelle 70 Enderta', logo: ''),
          goals: Goals(home: 3, away: 0),
          score: Score(
            halftime: ScoreDetail(home: 2, away: 0),
            fulltime: ScoreDetail(home: 3, away: 0),
          ),
          status: MatchStatus(
            long: 'Match Finished',
            short: 'FT',
            elapsed: 90,
            extra: 0,
          ),
        ),
        PreviousFixture(
          fixtureId: 4,
          date: now.subtract(const Duration(days: 28)),
          venue: 'Dire Dawa Stadium',
          league: 'ETH',
          round: 'Round 19',
          homeTeam: Team(name: 'Dire Dawa City', logo: ''),
          awayTeam: Team(name: 'Hadiya Hossana', logo: ''),
          goals: Goals(home: 0, away: 2),
          score: Score(
            halftime: ScoreDetail(home: 0, away: 1),
            fulltime: ScoreDetail(home: 0, away: 2),
          ),
          status: MatchStatus(
            long: 'Match Finished',
            short: 'FT',
            elapsed: 90,
            extra: 0,
          ),
        ),
        PreviousFixture(
          fixtureId: 5,
          date: now.subtract(const Duration(days: 35)),
          venue: 'Jimma Stadium',
          league: 'ETH',
          round: 'Round 18',
          homeTeam: Team(name: 'Jimma Aba Jifar', logo: ''),
          awayTeam: Team(name: 'Welayta Dicha', logo: ''),
          goals: Goals(home: 2, away: 0),
          score: Score(
            halftime: ScoreDetail(home: 1, away: 0),
            fulltime: ScoreDetail(home: 2, away: 0),
          ),
          status: MatchStatus(
            long: 'Match Finished',
            short: 'FT',
            elapsed: 90,
            extra: 0,
          ),
        ),
        PreviousFixture(
          fixtureId: 6,
          date: now.subtract(const Duration(days: 42)),
          venue: 'Addis Ababa Stadium',
          league: 'ETH',
          round: 'Round 17',
          homeTeam: Team(name: 'Ethio Electric', logo: ''),
          awayTeam: Team(name: 'Fasil Kenema', logo: ''),
          goals: Goals(home: 1, away: 1),
          score: Score(
            halftime: ScoreDetail(home: 0, away: 0),
            fulltime: ScoreDetail(home: 1, away: 1),
          ),
          status: MatchStatus(
            long: 'Match Finished',
            short: 'FT',
            elapsed: 90,
            extra: 0,
          ),
        ),
      ];
    } else {
      return [
        PreviousFixture(
          fixtureId: 7,
          date: now.subtract(const Duration(days: 7)),
          venue: 'Old Trafford',
          league: 'EPL',
          round: 'Round 22',
          homeTeam: Team(name: 'Manchester United', logo: ''),
          awayTeam: Team(name: 'Chelsea', logo: ''),
          goals: Goals(home: 1, away: 2),
          score: Score(
            halftime: ScoreDetail(home: 0, away: 1),
            fulltime: ScoreDetail(home: 1, away: 2),
          ),
          status: MatchStatus(
            long: 'Match Finished',
            short: 'FT',
            elapsed: 90,
            extra: 0,
          ),
        ),
        PreviousFixture(
          fixtureId: 8,
          date: now.subtract(const Duration(days: 14)),
          venue: 'Anfield',
          league: 'EPL',
          round: 'Round 21',
          homeTeam: Team(name: 'Liverpool', logo: ''),
          awayTeam: Team(name: 'Arsenal', logo: ''),
          goals: Goals(home: 3, away: 1),
          score: Score(
            halftime: ScoreDetail(home: 2, away: 0),
            fulltime: ScoreDetail(home: 3, away: 1),
          ),
          status: MatchStatus(
            long: 'Match Finished',
            short: 'FT',
            elapsed: 90,
            extra: 0,
          ),
        ),
        PreviousFixture(
          fixtureId: 9,
          date: now.subtract(const Duration(days: 21)),
          venue: 'Etihad Stadium',
          league: 'EPL',
          round: 'Round 20',
          homeTeam: Team(name: 'Manchester City', logo: ''),
          awayTeam: Team(name: 'Tottenham', logo: ''),
          goals: Goals(home: 4, away: 1),
          score: Score(
            halftime: ScoreDetail(home: 2, away: 0),
            fulltime: ScoreDetail(home: 4, away: 1),
          ),
          status: MatchStatus(
            long: 'Match Finished',
            short: 'FT',
            elapsed: 90,
            extra: 0,
          ),
        ),
        PreviousFixture(
          fixtureId: 10,
          date: now.subtract(const Duration(days: 28)),
          venue: 'St. James\' Park',
          league: 'EPL',
          round: 'Round 19',
          homeTeam: Team(name: 'Newcastle', logo: ''),
          awayTeam: Team(name: 'West Ham', logo: ''),
          goals: Goals(home: 2, away: 2),
          score: Score(
            halftime: ScoreDetail(home: 1, away: 1),
            fulltime: ScoreDetail(home: 2, away: 2),
          ),
          status: MatchStatus(
            long: 'Match Finished',
            short: 'FT',
            elapsed: 90,
            extra: 0,
          ),
        ),
        PreviousFixture(
          fixtureId: 11,
          date: now.subtract(const Duration(days: 35)),
          venue: 'Amex Stadium',
          league: 'EPL',
          round: 'Round 18',
          homeTeam: Team(name: 'Brighton', logo: ''),
          awayTeam: Team(name: 'Aston Villa', logo: ''),
          goals: Goals(home: 1, away: 0),
          score: Score(
            halftime: ScoreDetail(home: 0, away: 0),
            fulltime: ScoreDetail(home: 1, away: 0),
          ),
          status: MatchStatus(
            long: 'Match Finished',
            short: 'FT',
            elapsed: 90,
            extra: 0,
          ),
        ),
        PreviousFixture(
          fixtureId: 12,
          date: now.subtract(const Duration(days: 42)),
          venue: 'Selhurst Park',
          league: 'EPL',
          round: 'Round 17',
          homeTeam: Team(name: 'Crystal Palace', logo: ''),
          awayTeam: Team(name: 'Fulham', logo: ''),
          goals: Goals(home: 0, away: 0),
          score: Score(
            halftime: ScoreDetail(home: 0, away: 0),
            fulltime: ScoreDetail(home: 0, away: 0),
          ),
          status: MatchStatus(
            long: 'Match Finished',
            short: 'FT',
            elapsed: 90,
            extra: 0,
          ),
        ),
      ];
    }
  }
}
