/// Main page widget for club comparison feature.
/// This page allows users to select two football clubs and view their comparison data including honors, form, players, and fanbase info.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/models/comparison_response.dart';
import '../../domain/models/team_data.dart';
import '../blocs/comparison_bloc.dart';
import '../blocs/comparison_event.dart';
import '../blocs/comparison_state.dart';

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({super.key});

  @override
  State<ComparisonPage> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage>
    with TickerProviderStateMixin {
  TeamData? _selectedClubA;
  TeamData? _selectedClubB;
  List<TeamData> _clubs = [];
  List<TeamData> _filteredClubs = [];
  final TextEditingController _searchController = TextEditingController();

  late final AnimationController _heroController;
  late final Animation<double> _heroAnimation;
  late final AnimationController _cardsController;
  late final Animation<double> _cardsAnimation;

  @override
  void initState() {
    super.initState();
    context.read<ComparisonBloc>().add(const LoadClubsEvent());
    _searchController.addListener(_filterClubs);

    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _heroAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic),
    );

    _cardsController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardsController, curve: Curves.elasticOut),
    );

    // Start animations
    _heroController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _cardsController.forward();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _heroController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  void _filterClubs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredClubs = _clubs.where((club) {
        return club.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8F5E8), // Very light green
              Color(0xFFF1F8E9), // Light green-white
              Color(0xFFDCEDC8), // Soft green
              Color(0xFFC8E6C9), // Light green
            ],
          ),
        ),
        child: SafeArea(
          child: BlocListener<ComparisonBloc, ComparisonState>(
            listener: (context, state) {
              if (state is ClubsLoadedState) {
                setState(() {
                  _clubs = state.clubs;
                  _filteredClubs = state.clubs;
                });
              }
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Hero Section
                    FadeTransition(
                      opacity: _heroAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(_heroAnimation),
                        child: _buildHeroSection(),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Selected clubs header
                    FadeTransition(
                      opacity: _cardsAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.1),
                          end: Offset.zero,
                        ).animate(_cardsAnimation),
                        child: _buildSelectedClubsHeader(),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Search bar
                    _buildSearchBar(),

                    const SizedBox(height: 24),

                    // Club selection grid
                    _buildClubSelectionGrid(),

                    const SizedBox(height: 32),

                    // Compare button
                    _buildCompareButton(),

                    const SizedBox(height: 32),

                    // Results section (conditional)
                    BlocBuilder<ComparisonBloc, ComparisonState>(
                      builder: (context, state) {
                        if (state is ComparisonLoadingState) {
                          return Container(
                            padding: const EdgeInsets.all(40),
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF4CAF50),
                                ),
                              ),
                            ),
                          );
                        } else if (state is ComparisonLoadedState) {
                          return _buildResultUI(state.comparisonResponse);
                        } else if (state is ComparisonErrorState) {
                          return Container(
                            padding: const EdgeInsets.all(40),
                            child: Center(
                              child: Column(
                                children: [
                                  const FaIcon(
                                    FontAwesomeIcons.exclamationTriangle,
                                    color: Color(0xFF4CAF50),
                                    size: 48,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    state.errorMessage,
                                    style: const TextStyle(
                                      color: Color(0xFF2E7D32),
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: 100), // Extra space for bottom nav
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4CAF50), // Medium green
            Color(0xFF66BB6A), // Light green
            Color(0xFF81C784), // Very light green
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const FaIcon(
                  FontAwesomeIcons.balanceScale,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Club Comparison',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Analyze & Compare',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Select two football clubs to compare their statistics, performance, and achievements in detail.',
            style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedClubsHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8F5E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSelectedClubDisplay(_selectedClubA),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E8),
              shape: BoxShape.circle,
            ),
            child: const FaIcon(
              FontAwesomeIcons.equals,
              color: Color(0xFF4CAF50),
              size: 24,
            ),
          ),
          _buildSelectedClubDisplay(_selectedClubB),
        ],
      ),
    );
  }

  Widget _buildSelectedClubDisplay(TeamData? club) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: club != null
                ? const Color(0xFF4CAF50)
                : const Color(0xFFE8F5E8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8F5E8), width: 2),
            boxShadow: club != null
                ? [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                Icons.sports_soccer,
                color: club != null ? Colors.white : const Color(0xFF4CAF50),
                size: 32,
              ),
              if (club != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
                  child: Text(
                    club.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8F5E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search clubs...',
          hintStyle: TextStyle(color: const Color(0xFF4CAF50).withOpacity(0.6)),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(15.0),
            child: const FaIcon(
              FontAwesomeIcons.search,
              color: Color(0xFF4CAF50),
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
        style: const TextStyle(color: Color(0xFF2E7D32), fontSize: 16),
      ),
    );
  }

  Widget _buildClubSelectionGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Clubs',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: _filteredClubs.length,
          itemBuilder: (context, index) {
            return _buildClubGridItem(_filteredClubs[index]);
          },
        ),
      ],
    );
  }

  Widget _buildCompareButton() {
    final canCompare = _selectedClubA != null && _selectedClubB != null;
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: canCompare
            ? const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
              )
            : const LinearGradient(
                colors: [Color(0xFFE8F5E8), Color(0xFFF1F8E9)],
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: canCompare
            ? [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: canCompare
            ? () {
                final clubAId = int.parse(_selectedClubA!.id);
                final clubBId = int.parse(_selectedClubB!.id);
                context.read<ComparisonBloc>().add(
                  FetchComparisonDataEvent(clubAId: clubAId, clubBId: clubBId),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FaIcon(
              FontAwesomeIcons.chartBar,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              'Compare Clubs',
              style: TextStyle(
                fontSize: 18,
                color: canCompare ? Colors.white : const Color(0xFF4CAF50),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClubGridItem(TeamData club) {
    final isSelected = _selectedClubA == club || _selectedClubB == club;
    final isSelectedA = _selectedClubA == club;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedClubA == club) {
            _selectedClubA = null;
          } else if (_selectedClubB == club) {
            _selectedClubB = null;
          } else if (_selectedClubA == null) {
            _selectedClubA = club;
          } else if (_selectedClubB == null) {
            if (club != _selectedClubA) {
              _selectedClubB = club;
            }
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4CAF50)
                : const Color(0xFFE8F5E8),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.25)
                    : const Color(0xFFE8F5E8),
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                FontAwesomeIcons.futbol,
                color: isSelected ? Colors.white : const Color(0xFF4CAF50),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              club.name,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF2E7D32),
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultUI(ComparisonResponse response) {
    final teamA = response.comparisonData['team_a']!;
    final teamB = response.comparisonData['team_b']!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8F5E8), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildTeamHeader(teamA), _buildTeamHeader(teamB)],
            ),
            const SizedBox(height: 32),
            _buildComparisonTable(teamA, teamB),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamHeader(TeamData team) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const FaIcon(
              FontAwesomeIcons.futbol,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            team.name,
            style: const TextStyle(
              color: Color(0xFF2E7D32),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable(TeamData teamA, TeamData teamB) {
    final stats = [
      {
        'label': 'Matches Played',
        'icon': FontAwesomeIcons.calendarAlt,
        'a': teamA.matchesPlayed,
        'b': teamB.matchesPlayed,
        'color': const Color(0xFF2196F3),
      },
      {
        'label': 'Wins',
        'icon': FontAwesomeIcons.trophy,
        'a': teamA.wins,
        'b': teamB.wins,
        'color': const Color(0xFF4CAF50),
      },
      {
        'label': 'Draws',
        'icon': FontAwesomeIcons.minus,
        'a': teamA.draws,
        'b': teamB.draws,
        'color': const Color(0xFFFF9800),
      },
      {
        'label': 'Losses',
        'icon': FontAwesomeIcons.times,
        'a': teamA.losses,
        'b': teamB.losses,
        'color': const Color(0xFFF44336),
      },
      {
        'label': 'Goals For',
        'icon': FontAwesomeIcons.futbol,
        'a': teamA.goalsFor,
        'b': teamB.goalsFor,
        'color': const Color(0xFF4CAF50),
      },
      {
        'label': 'Goals Against',
        'icon': FontAwesomeIcons.shieldAlt,
        'a': teamA.goalsAgainst,
        'b': teamB.goalsAgainst,
        'color': const Color(0xFFF44336),
      },
    ];

    return Column(
      children: stats.map((stat) {
        final label = stat['label'] as String;
        final icon = stat['icon'] as IconData;
        final valueA = stat['a'] as int;
        final valueB = stat['b'] as int;
        final color = stat['color'] as Color;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8F5E8), width: 1),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // centers horizontally
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // centers vertically
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: FaIcon(icon, color: color, size: 16),
                    ),
                    const SizedBox(width: 8),
                    // Label
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Team A Value
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        valueA.toString(),
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Team B Value
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        valueB.toString(),
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
