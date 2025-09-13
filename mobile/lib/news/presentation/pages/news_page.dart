import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http; // Import http for client
import '../../../../bottom_navigation_bar.dart'; // Adjust path if needed

import '../../domain/entities/news_update_entity.dart';
import '../../domain/usecases/get_news_updates.dart';
import '../../data/datasources/news_remote_datasource.dart';
import '../../data/repositories/news_update_repository_impl.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int _selectedIndex = 3; // News tab is typically the 4th item (index 3)
  NewsCategory _currentCategory = NewsCategory.all;

  @override
  void initState() {
    super.initState();
    // Dispatch an event to fetch news when the page initializes
    context.read<NewsBloc>().add(FetchNewsUpdates(category: _currentCategory));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Handle navigation to other pages if needed
      // print("Tapped on index: $index");
    });
  }

  String _getCategoryTitle(NewsCategory category) {
    switch (category) {
      case NewsCategory.all:
        return 'All News Updates';
      case NewsCategory.pastMatches:
        return 'Past Matches';
      case NewsCategory.standings:
        return 'League Standings';
      case NewsCategory.futureMatches:
        return 'Upcoming Matches';
      case NewsCategory.liveScores:
        return 'Live Scores';
    }
  }

  // Widget to display a single news item (simple text)
  Widget _buildNewsUpdateItem(NewsUpdateEntity newsUpdate) {
    String timeInfo = '';
    if (newsUpdate.publishedAt != null) {
      final Duration difference = DateTime.now().difference(newsUpdate.publishedAt!);
      if (difference.inDays > 0) {
        timeInfo = ' - ${difference.inDays} Days Ago';
      } else if (difference.inHours > 0) {
        timeInfo = ' - ${difference.inHours} Hours Ago';
      } else {
        timeInfo = ' - ${difference.inMinutes} Minutes Ago';
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              newsUpdate.content,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            if (timeInfo.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '${newsUpdate.type}$timeInfo',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
            if (timeInfo.isEmpty) ...[
              const SizedBox(height: 8),
              Text(
                newsUpdate.type,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'Search Updates',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
        ],
        // Removed TabBar as there's only one main 'Latest' view now
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsInitial || state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) {
            if (state.newsUpdates.isEmpty) {
              return const Center(child: Text('No updates available for this category.'));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    _getCategoryTitle(state.currentCategory),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.newsUpdates.length,
                    itemBuilder: (context, index) {
                      final newsUpdate = state.newsUpdates[index];
                      return _buildNewsUpdateItem(newsUpdate);
                    },
                  ),
                ),
              ],
            );
          } else if (state is NewsError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Something went wrong!'));
        },
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Select Update Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildFilterListTile(context, NewsCategory.all, 'All Updates'),
              _buildFilterListTile(context, NewsCategory.pastMatches, 'Past Matches'),
              _buildFilterListTile(context, NewsCategory.standings, 'League Standings'),
              _buildFilterListTile(context, NewsCategory.futureMatches, 'Upcoming Matches'),
              _buildFilterListTile(context, NewsCategory.liveScores, 'Live Scores'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterListTile(BuildContext context, NewsCategory category, String title) {
    return ListTile(
      leading: _currentCategory == category ? const Icon(Icons.check, color: Color(0xFF1E392A)) : null,
      title: Text(title),
      onTap: () {
        setState(() {
          _currentCategory = category;
          context.read<NewsBloc>().add(FetchNewsUpdates(category: _currentCategory));
        });
        Navigator.pop(context);
      },
    );
  }
}