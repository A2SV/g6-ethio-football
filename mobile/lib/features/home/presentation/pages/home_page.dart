// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:intl/intl.dart'; // For date formatting
// import 'package:collection/collection.dart'; // For .lastWhereOrNull
//
// import 'package:sample_a2sv_final/bottom_navigation_bar.dart'; // Assuming this exists and is needed
// import 'package:sample_a2sv_final/chat_message.dart';
// import 'package:sample_a2sv_final/features/home/presentation/bloc/home_bloc.dart';
// import 'package:sample_a2sv_final/features/home/presentation/bloc/home_event.dart';
// import 'package:sample_a2sv_final/features/home/presentation/bloc/home_state.dart';
// //import 'package:sample_a2sv_final/features/news/presentation/pages/news_page.dart';
// import 'package:sample_a2sv_final/news/presentation/pages/news_page.dart';// Assuming NewsPage exists for navigation
//
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key}); // Use super.key for the 'key could be a super parameter' warning
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0; // Keeping this for the bottom navigation bar logic, cannot be final due to setState
//   final TextEditingController _textController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<HomeBloc>().add(LoadInitialMessages());
//   }
//
//   @override
//   void dispose() {
//     _textController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   // This is the method that was causing the "Undefined name" error if not placed correctly
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       if (index == 3) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => const NewsPage()),
//         );
//       }
//       // Add navigation logic for other tabs (Fixtures, Standings) here if needed
//       // For example:
//       // if (index == 1) {
//       //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FixturesPage()));
//       // } else if (index == 2) {
//       //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const StandingsPage()));
//       // }
//     });
//   }
//
//   void _sendMessage({String? predefinedText}) {
//     final text = predefinedText ?? _textController.text.trim();
//     if (text.isEmpty) return;
//
//     _textController.clear();
//     // Dispatch the SendMessage event to the BLoC
//     context.read<HomeBloc>().add(SendMessage(message: text));
//     _scrollToBottom();
//   }
//
//   void _handleSuggestionTap(String suggestion) {
//     _sendMessage(predefinedText: suggestion);
//   }
//
//   void _scrollToBottom() {
//     // Ensure the scroll controller is attached and has clients
//     if (_scrollController.hasClients) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ethio Football Chat'),
//         backgroundColor: Colors.green,
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: BlocConsumer<HomeBloc, HomeState>(
//               listener: (context, state) {
//                 // Listen for state changes to scroll to bottom, especially after new messages
//                 if (state is HomeLoaded || state is HomeError) {
//                   _scrollToBottom();
//                 }
//               },
//               builder: (context, state) {
//                 if (state.messages.isEmpty && state.isLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (state.messages.isEmpty && state.error != null) {
//                   return Center(
//                     child: Text('Error: ${state.error}\nTap to retry',
//                         textAlign: TextAlign.center),
//                   );
//                 }
//
//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
//                   itemCount: state.messages.length,
//                   itemBuilder: (context, index) {
//                     final message = state.messages[index];
//                     return _buildMessage(message);
//                   },
//                 );
//               },
//             ),
//           ),
//           _buildSuggestions(), // Moved suggestions above input for better UX
//           _buildMessageInput(),
//           // Assuming BottomNavigationBar is always present.
//           // If you want to use the _onItemTapped logic, this should be uncommented.
//           BottomNavigationBar(
//             items: const <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: 'Home',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.calendar_today),
//                 label: 'Fixtures',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.leaderboard),
//                 label: 'Standings',
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.article),
//                 label: 'News',
//               ),
//             ],
//             currentIndex: _selectedIndex,
//             selectedItemColor: Colors.green,
//             unselectedItemColor: Colors.grey,
//             onTap: _onItemTapped, // This is where the method is called
//             type: BottomNavigationBarType.fixed, // Ensures all labels are visible
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMessage(ChatMessage message) {
//     final bool isUser = message.sender == MessageSender.user;
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 5.0),
//         padding: const EdgeInsets.all(12.0),
//         decoration: BoxDecoration(
//           color: isUser ? Colors.green.shade100 : Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(15.0),
//         ),
//         child: Column(
//           crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             MarkdownBody(
//               data: message.text,
//               selectable: true,
//               styleSheet: MarkdownStyleSheet(
//                 p: const TextStyle(fontSize: 16.0),
//                 a: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
//               ),
//             ),
//             const SizedBox(height: 5.0),
//             Text(
//               DateFormat('hh:mm a').format(message.timestamp),
//               style: TextStyle(
//                 fontSize: 10.0,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMessageInput() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: TextField(
//               controller: _textController,
//               decoration: InputDecoration(
//                 hintText: 'Ask Ethio Football here ...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25.0),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//               ),
//               onSubmitted: (_) => _sendMessage(),
//             ),
//           ),
//           const SizedBox(width: 8.0),
//           FloatingActionButton(
//             onPressed: _sendMessage,
//             mini: true,
//             backgroundColor: Colors.green,
//             child: const Icon(Icons.send),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSuggestions() {
//     return BlocBuilder<HomeBloc, HomeState>(
//       builder: (context, state) {
//         // Find the last message that is from AI and has suggestions
//         // Using collection package's lastWhereOrNull
//         final ChatMessage? lastAiMessageWithSuggestions = state.messages
//             .lastWhereOrNull((msg) => msg.sender == MessageSender.ai && msg.suggestions != null && msg.suggestions!.isNotEmpty);
//
//         if (lastAiMessageWithSuggestions != null) {
//           return Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
//             alignment: Alignment.centerLeft,
//             child: Wrap(
//               spacing: 8.0, // Gap between adjacent chips
//               runSpacing: 4.0, // Gap between lines
//               children: lastAiMessageWithSuggestions.suggestions!
//                   .map((suggestion) => ActionChip(
//                 label: Text(suggestion),
//                 onPressed: () => _handleSuggestionTap(suggestion),
//                 backgroundColor: Colors.green.shade50,
//                 side: BorderSide(color: Colors.green.shade200),
//               ))
//                   .toList(),
//             ),
//           );
//         }
//         return const SizedBox.shrink(); // No suggestions to show
//       },
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:collection/collection.dart'; // For .lastWhereOrNull

import 'package:sample_a2sv_final/bottom_navigation_bar.dart'; // Updated import for MyBottomNavigationBar
import 'package:sample_a2sv_final/chat_message.dart';
import 'package:sample_a2sv_final/features/home/presentation/bloc/home_bloc.dart';
import 'package:sample_a2sv_final/features/home/presentation/bloc/home_event.dart';
import 'package:sample_a2sv_final/features/home/presentation/bloc/home_state.dart';
import 'package:sample_a2sv_final/news/presentation/pages/news_page.dart'; // Assuming NewsPage exists for navigation

class HomePage extends StatefulWidget {
  const HomePage({super.key}); // Use super.key for the 'key could be a super parameter' warning

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Keeping this for the bottom navigation bar logic, cannot be final due to setState
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadInitialMessages());
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NewsPage()),
        );
      }
      // Add navigation logic for other tabs (Live Hub, Compare, Settings) here if needed
    });
  }

  void _sendMessage({String? predefinedText}) {
    final text = predefinedText ?? _textController.text.trim();
    if (text.isEmpty) return;

    _textController.clear();
    // Dispatch the SendMessage event to the BLoC
    context.read<HomeBloc>().add(SendMessage(message: text));
    _scrollToBottom();
  }

  void _handleSuggestionTap(String suggestion) {
    _sendMessage(predefinedText: suggestion);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ethio Football Chat'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                if (state is HomeLoaded || state is HomeError) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state.messages.isEmpty && state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.messages.isEmpty && state.error != null) {
                  return Center(
                    child: Text('Error: ${state.error}\nTap to retry',
                        textAlign: TextAlign.center),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    return _buildMessage(message);
                  },
                );
              },
            ),
          ),
          _buildSuggestions(), // Moved suggestions above input for better UX
          _buildMessageInput(),
          // Using MyBottomNavigationBar instead of the original BottomNavigationBar
          MyBottomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemTapped: _onItemTapped,
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    final bool isUser = message.sender == MessageSender.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.green.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            MarkdownBody(
              data: message.text,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16.0),
                a: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              DateFormat('hh:mm a').format(message.timestamp),
              style: TextStyle(
                fontSize: 10.0,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Ask Ethio Football here ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8.0),
          FloatingActionButton(
            onPressed: _sendMessage,
            mini: true,
            backgroundColor: Colors.green,
            child: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final ChatMessage? lastAiMessageWithSuggestions = state.messages
            .lastWhereOrNull((msg) => msg.sender == MessageSender.ai && msg.suggestions != null && msg.suggestions!.isNotEmpty);

        if (lastAiMessageWithSuggestions != null) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: lastAiMessageWithSuggestions.suggestions!
                  .map((suggestion) => ActionChip(
                label: Text(suggestion),
                onPressed: () => _handleSuggestionTap(suggestion),
                backgroundColor: Colors.green.shade50,
                side: BorderSide(color: Colors.green.shade200),
              ))
                  .toList(),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}