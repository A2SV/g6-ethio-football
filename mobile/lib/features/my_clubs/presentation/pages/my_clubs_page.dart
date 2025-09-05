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
    return Scaffold(
      appBar: AppBar(title: const Text("My Clubs")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search clubs...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<MyClubsBloc>().add(LoadAllClubs());
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) {
                if (query.isNotEmpty) {
                  context.read<MyClubsBloc>().add(SearchClubsEvent(query));
                } else {
                  context.read<MyClubsBloc>().add(LoadAllClubs());
                }
              },
            ),
            const SizedBox(height: 8),
            // League filter
            DropdownButton<League>(
              value: _selectedLeague,
              hint: const Text('Filter by league'),
              items: League.values.map((league) {
                return DropdownMenuItem(
                  value: league,
                  child: Text(league.name),
                );
              }).toList(),
              onChanged: (league) {
                setState(() {
                  _selectedLeague = league;
                });
                if (league != null) {
                  context.read<MyClubsBloc>().add(FilterClubsEvent(league));
                } else {
                  context.read<MyClubsBloc>().add(LoadAllClubs());
                }
              },
            ),
            const SizedBox(height: 8),
            // Club list
            Expanded(
              child: BlocBuilder<MyClubsBloc, MyClubsState>(
                builder: (context, state) {
                  if (state is MyClubsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MyClubsLoaded) {
                    if (state.clubs.isEmpty) {
                      return const Center(child: Text('No clubs found.'));
                    }
                    return ListView.builder(
                      itemCount: state.clubs.length,
                      itemBuilder: (context, index) {
                        final club = state.clubs[index];
                        return Card(
                          child: ListTile(
                            leading: club.logoUrl != null
                                ? Image.network(club.logoUrl!)
                                : const Icon(Icons.sports_soccer),
                            title: Text(club.name),
                            subtitle: Text(
                              '${club.league.name} - ${club.description}',
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                if (club.isFollowed) {
                                  context.read<MyClubsBloc>().add(
                                    UnfollowClubEvent(club.id),
                                  );
                                } else {
                                  context.read<MyClubsBloc>().add(
                                    FollowClubEvent(club.id),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: club.isFollowed
                                    ? Colors.red
                                    : Colors.green,
                              ),
                              child: Text(
                                club.isFollowed ? 'Unfollow' : 'Follow',
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is MyClubsError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
