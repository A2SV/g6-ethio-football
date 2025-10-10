import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/football_bloc.dart';
import '../bloc/football_event.dart';
import '../bloc/football_state.dart';
import '../widgets/navigation_widgets.dart';
import '../widgets/match_widgets.dart';
import '../widgets/table_widgets.dart';
import '../widgets/common_widgets.dart';

class LiveHubPage extends StatefulWidget {
  const LiveHubPage({super.key});

  @override
  State<LiveHubPage> createState() => _LiveHubPageState();
}

class _LiveHubPageState extends State<LiveHubPage> {
  bool _showCalendar = false;
  DateTime _selectedDate = DateTime.now();
  DateTime _currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Load initial data
    _loadInitialData();
  }

  void _loadInitialData() {
    final bloc = context.read<FootballBloc>();
    // Load standings for the default league (ETH)
    print('Fetching table data (standings) for league: ETH');
    bloc.add(LoadStandings('ETH'));
    // Load fixtures for the default league
    bloc.add(LoadFixtures('ETH'));
    // Load live scores
    bloc.add(LoadLiveScores());
    // Load live matches for the default league
    bloc.add(LoadLiveMatches('ETH'));
    // Load previous fixtures - use 2021 for historical data
    print(
      '🔍 [PREVIOUS_FIXTURES_DEBUG] Loading previous fixtures for ETH league, season 2021',
    );
    bloc.add(LoadPreviousFixtures(league: 'ETH', round: 1, season: 2021));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FootballBloc, FootballState>(
      builder: (context, state) {
        final selectedLeague = context.select(
          (FootballBloc bloc) => bloc.state is FootballLoaded
              ? (bloc.state as FootballLoaded).selectedLeague
              : 'ETH',
        );

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  context.read<FootballBloc>().add(RefreshData());
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const OnlineBanner(),
                    const SizedBox(height: 16),
                    DateNavigationBar(
                      showCalendar: _showCalendar,
                      selectedDate: _selectedDate,
                      onCalendarToggle: () {
                        setState(() {
                          _showCalendar = !_showCalendar;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    if (state is FootballLoading)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      )
                    else if (state is FootballLoaded)
                      Column(
                        children: [
                          const LiveMatchesSectionNew(),
                          const SizedBox(height: 20),
                          const LiveMatchesSection(),
                          const SizedBox(height: 20),
                          const PreviousFixturesSection(),
                          const SizedBox(height: 20),
                          const TableSection(),
                        ],
                      )
                    else if (state is FootballError)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Error: ${state.message}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<FootballBloc>().add(
                                    RefreshData(),
                                  );
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      // Initial state - show loading
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Calendar overlay at the top level
              if (_showCalendar)
                Positioned(
                  top: 80, // Position below the app bar area
                  left: 16,
                  right: 16,
                  child: Material(
                    elevation: 16,
                    borderRadius: BorderRadius.circular(16),
                    child: CalendarOverlay(
                      selectedDate: _selectedDate,
                      currentMonth: _currentMonth,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                          _showCalendar = false;
                        });
                        // Load fixtures for the selected date
                        context.read<FootballBloc>().add(
                          LoadFixturesByDate(date, selectedLeague),
                        );
                      },
                      onMonthChanged: (month) {
                        setState(() => _currentMonth = month);
                      },
                      onLeagueChanged: (league) {
                        context.read<FootballBloc>().add(ChangeLeague(league));
                        setState(() {
                          _showCalendar = false;
                        });
                      },
                      selectedLeague: selectedLeague,
                      onClose: () {
                        setState(() {
                          _showCalendar = false;
                        });
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
