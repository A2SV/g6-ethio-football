import 'package:ethio_football/core/Presentation/widgets/search_bar.dart';
import 'package:ethio_football/features/my_clubs/presentation/widgets/club_card.dart';
import 'package:ethio_football/features/my_clubs/presentation/widgets/league_preference_tab.dart';

import '../../../../core/Presentation/constants/colors.dart';
import '../../../../core/Presentation/constants/dimensions.dart';
import '../../../../core/Presentation/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/club.dart';
import '../bloc/my_clubs_bloc.dart';
import '../bloc/my_clubs_event.dart';
import '../bloc/my_clubs_state.dart';

class MyClubsPage extends StatefulWidget {
  const MyClubsPage({Key? key}) : super(key: key);

  @override
  State<MyClubsPage> createState() => _MyClubsPageState();
}

class _MyClubsPageState extends State<MyClubsPage> {
  final TextEditingController _searchController = TextEditingController();
  League? _selectedLeague;

  @override
  void initState() {
    super.initState();
    // Load all clubs initially
    context.read<MyClubsBloc>().add(LoadAllClubs());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? kDarkBackgroundColor : kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_ios_new, color: kPrimaryTextColor),
        centerTitle: true,
        title: Text(
          "CHOOSE CLUBS",
          style: TextStyle(
            color: kPrimaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: kTitleFontSize(context),
          ),
        ),
      ),
      body: BlocBuilder<MyClubsBloc, MyClubsState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // 🔹 Search + League Tabs
              SliverToBoxAdapter(
                child: Container(
                  padding: kTop,
                  decoration: BoxDecoration(
                    color: isDark ? kDarkBackgroundColor : kBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: kAccentColor.withOpacity(0.12),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CustomSearchBar(
                        searchController: _searchController,
                        hintText: "Search Clubs",
                        onChanged: (query) {
                          if (query.isNotEmpty) {
                            context.read<MyClubsBloc>().add(
                              SearchClubsEvent(query),
                            );
                          } else {
                            context.read<MyClubsBloc>().add(LoadAllClubs());
                          }
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          LeaguePreferenceTab(
                            label: 'Ethiopian Premier League',
                            isSelected: _selectedLeague == League.ETH,
                            onTap: () {
                              setState(() {
                                _selectedLeague = League.ETH;
                              });
                              context.read<MyClubsBloc>().add(
                                FilterClubsEvent(League.ETH),
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          LeaguePreferenceTab(
                            label: 'English Premier League',
                            isSelected: _selectedLeague == League.EPL,
                            onTap: () {
                              setState(() {
                                _selectedLeague = League.EPL;
                              });
                              context.read<MyClubsBloc>().add(
                                FilterClubsEvent(League.EPL),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 🔹 Clubs List
              if (state is MyClubsLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is MyClubsLoaded)
                state.clubs.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(child: Text('No clubs found.')),
                      )
                    : SliverPadding(
                        padding: kScreenPadding,
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: kCardMargin,
                                mainAxisSpacing: kCardMargin,
                                childAspectRatio: 0.7,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final club = state.clubs[index];
                            return ClubCard(club: club);
                          }, childCount: state.clubs.length),
                        ),
                      )
              else if (state is MyClubsError)
                SliverFillRemaining(
                  child: Center(child: Text('Error: ${state.message}')),
                )
              else
                const SliverToBoxAdapter(child: SizedBox.shrink()),
            ],
          );
        },
      ),
    );
  }
}
