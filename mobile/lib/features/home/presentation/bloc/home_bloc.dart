import 'package:bloc/bloc.dart';
import 'package:ethio_football/features/home/domain/entities/chat_message.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ethio_football/core/utils/database_helper.dart';
import 'package:ethio_football/features/home/presentation/pages/home_page.dart';
import 'package:ethio_football/features/home/presentation/bloc/home_event.dart';
import 'package:ethio_football/features/home/presentation/bloc/home_state.dart';
import 'package:ethio_football/features/home/presentation/pages/home_page.dart'
    as home_page;
import 'package:http/http.dart' as http;
import 'dart:convert';

class AIChatService {
  static const String baseUrl = 'https://g6-ethio-football.onrender.com';

  Future<Map<String, dynamic>> sendMessage(String message) async {
    print('🔍 [AI_CHAT_DEBUG] Starting API request...');
    print('🔍 [AI_CHAT_DEBUG] Message: "$message"');
    print('🔍 [AI_CHAT_DEBUG] Base URL: $baseUrl');
    print('🔍 [AI_CHAT_DEBUG] Full URL: $baseUrl/intent/parse');

    // Try different request formats in case the API expects different field names
    final requestFormats = [
      {'query': message},
      {'text': message},
      {'input': message},
      {'prompt': message},
      {'question': message},
      {'message': message}, // fallback to original
      {'user_input': message}, // try different field names
      {'request': message},
      {
        'data': {'text': message},
      }, // nested format
      {
        'payload': {'message': message},
      }, // another nested format
    ];

    for (int i = 0; i < requestFormats.length; i++) {
      final requestBody = requestFormats[i];
      final fieldName = requestBody.keys.first;

      print(
        '🔍 [AI_CHAT_DEBUG] Trying request format ${i + 1}/${requestFormats.length} with field: "$fieldName"',
      );
      print('🔍 [AI_CHAT_DEBUG] Request Body: ${json.encode(requestBody)}');

      try {
        final uri = Uri.parse('$baseUrl/intent/parse');
        print('🔍 [AI_CHAT_DEBUG] Parsed URI: $uri');

        final headers = {'Content-Type': 'application/json'};
        print('🔍 [AI_CHAT_DEBUG] Headers: $headers');

        print('🔍 [AI_CHAT_DEBUG] Sending POST request...');
        final response = await http
            .post(uri, headers: headers, body: json.encode(requestBody))
            .timeout(const Duration(seconds: 30)); // Add timeout

        print('🔍 [AI_CHAT_DEBUG] Response received!');
        print('🔍 [AI_CHAT_DEBUG] Status Code: ${response.statusCode}');
        print('🔍 [AI_CHAT_DEBUG] Response Headers: ${response.headers}');
        print(
          '🔍 [AI_CHAT_DEBUG] Response Body Length: ${response.body.length} characters',
        );

        if (response.body.isNotEmpty) {
          print(
            '🔍 [AI_CHAT_DEBUG] Response Body Preview: ${response.body.substring(0, min(200, response.body.length))}...',
          );
        } else {
          print('🔍 [AI_CHAT_DEBUG] Response Body is EMPTY!');
        }

        if (response.statusCode == 200) {
          print('🔍 [AI_CHAT_DEBUG] Status 200 - Parsing JSON response...');
          try {
            final decodedResponse =
                json.decode(response.body) as Map<String, dynamic>;
            print('🔍 [AI_CHAT_DEBUG] Successfully parsed JSON response');
            print(
              '🔍 [AI_CHAT_DEBUG] Response Keys: ${decodedResponse.keys.toList()}',
            );

            if (decodedResponse.containsKey('markdown')) {
              print(
                '🔍 [AI_CHAT_DEBUG] Markdown field found: ${decodedResponse['markdown']?.substring(0, min(100, decodedResponse['markdown']?.length ?? 0))}...',
              );
            } else {
              print(
                '🔍 [AI_CHAT_DEBUG] WARNING: No markdown field in response!',
              );
            }

            if (decodedResponse.containsKey('source')) {
              print('🔍 [AI_CHAT_DEBUG] Source: ${decodedResponse['source']}');
            }

            if (decodedResponse.containsKey('freshness')) {
              print(
                '🔍 [AI_CHAT_DEBUG] Freshness: ${decodedResponse['freshness']}',
              );
            }

            return decodedResponse;
          } catch (parseError) {
            print('🔍 [AI_CHAT_DEBUG] ERROR parsing JSON: $parseError');
            print('🔍 [AI_CHAT_DEBUG] Raw response body: ${response.body}');
            throw Exception('Failed to parse JSON response: $parseError');
          }
        } else {
          print(
            '🔍 [AI_CHAT_DEBUG] ERROR: Non-200 status code: ${response.statusCode}',
          );
          print('🔍 [AI_CHAT_DEBUG] Error response body: ${response.body}');

          // If this is not the last format to try, continue to next format
          if (i < requestFormats.length - 1) {
            print('🔍 [AI_CHAT_DEBUG] Trying next request format...');
            continue;
          } else {
            // This was the last format, throw the error
            throw Exception(
              'Failed to get response: ${response.statusCode} - ${response.body}',
            );
          }
        }
      } catch (requestError) {
        print(
          '🔍 [AI_CHAT_DEBUG] EXCEPTION in request format ${i + 1}: $requestError',
        );

        // If this is not the last format to try, continue to next format
        if (i < requestFormats.length - 1) {
          print('🔍 [AI_CHAT_DEBUG] Trying next request format...');
          continue;
        } else {
          // This was the last format, re-throw the error
          throw Exception('Network error: $requestError');
        }
      }
    }

    // If we get here, all formats failed
    throw Exception(
      'All request formats failed. Last error was for field: ${requestFormats.last.keys.first}',
    );
  }
}

int min(int a, int b) => a < b ? a : b;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final AIChatService _aiService = AIChatService();

  HomeBloc() : super(const HomeInitial()) {
    on<LoadInitialMessages>(_onLoadInitialMessages);
    on<SendMessage>(_onSendMessage);
    on<CacheCurrentConversation>(_onCacheCurrentConversation);
  }

  Future<void> _onLoadInitialMessages(
    LoadInitialMessages event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading(messages: state.messages));

    try {
      print('🔍 [BLOC_DEBUG] Loading cached chat messages...');
      final cachedMessages = await _dbHelper.getChatMessages(limit: 50);

      if (cachedMessages.isNotEmpty) {
        print('🔍 [BLOC_DEBUG] Found ${cachedMessages.length} cached messages');
        final messages = cachedMessages
            .map(
              (msg) => ChatMessage(
                text: msg['text'] as String,
                isUser: (msg['isUser'] as int) == 1,
                timestamp: DateTime.parse(msg['timestamp'] as String),
                isLoading: (msg['isLoading'] as int) == 1,
              ),
            )
            .toList();

        emit(HomeLoaded(messages: messages));
        print(
          '🔍 [BLOC_DEBUG] Successfully loaded ${cachedMessages.length} messages from cache',
        );
      } else {
        print(
          '🔍 [BLOC_DEBUG] No cached messages found, adding welcome message',
        );
        // Add welcome message if no cached messages
        final welcomeMessage = ChatMessage(
          text:
              "Hello! I'm your AI football assistant. I can help you with information about Ethiopian Premier League, English Premier League, team statistics, player info, and more. What would you like to know?",
          isUser: false,
          timestamp: DateTime.now(),
        );
        await _saveMessageToCache(welcomeMessage);
        emit(HomeLoaded(messages: [welcomeMessage]));
      }
    } catch (e) {
      print('🔍 [BLOC_DEBUG] Error loading cached messages: $e');
      // Fallback to welcome message
      final welcomeMessage = ChatMessage(
        text:
            "Hello! I'm your AI football assistant. I can help you with information about Ethiopian Premier League, English Premier League, team statistics, player info, and more. What would you like to know?",
        isUser: false,
        timestamp: DateTime.now(),
      );
      await _saveMessageToCache(welcomeMessage);
      emit(HomeLoaded(messages: [welcomeMessage]));
    }
  }

  Future<void> _onSendMessage(
    SendMessage event,
    Emitter<HomeState> emit,
  ) async {
    final text = event.message.trim();
    if (text.isEmpty) return;

    print('🔍 [BLOC_DEBUG] Starting to send message: "$text"');

    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Add user message immediately
    emit(HomeLoaded(messages: List.from(state.messages)..add(userMessage)));
    await _saveMessageToCache(userMessage);

    // Add thinking message
    final thinkingMessage = ChatMessage(
      text: '🤔 Thinking...',
      isUser: false,
      timestamp: DateTime.now(),
      isLoading: true,
    );

    print('🔍 [BLOC_DEBUG] Added thinking message');
    emit(HomeLoaded(messages: List.from(state.messages)..add(thinkingMessage)));

    print('🔍 [BLOC_DEBUG] Starting API call...');

    try {
      // Make API call to the AI service
      final response = await _aiService.sendMessage(text);

      print('🔍 [BLOC_DEBUG] API call completed successfully');

      // Remove thinking message and add actual response
      final messagesWithoutThinking = List<ChatMessage>.from(state.messages);
      messagesWithoutThinking.removeLast(); // Remove thinking message

      // Extract markdown from response
      final markdown =
          response['markdown'] as String? ??
          'Sorry, I couldn\'t process your request.';

      final aiMessage = ChatMessage(
        text: markdown,
        isUser: false,
        timestamp: DateTime.now(),
      );

      print('🔍 [BLOC_DEBUG] Adding AI response to messages...');
      emit(HomeLoaded(messages: messagesWithoutThinking..add(aiMessage)));
      await _saveMessageToCache(aiMessage);

      print('🔍 [BLOC_DEBUG] Successfully added AI response');
    } catch (e) {
      print('🔍 [BLOC_DEBUG] ERROR in _sendMessage: $e');

      // Remove thinking message
      final messagesWithoutThinking = List<ChatMessage>.from(state.messages);
      messagesWithoutThinking.removeLast(); // Remove thinking message

      // Try fallback responses for common queries
      final fallbackResponse = _getFallbackResponse(text.toLowerCase());

      final aiMessage = ChatMessage(
        text: fallbackResponse,
        isUser: false,
        timestamp: DateTime.now(),
      );

      print('🔍 [BLOC_DEBUG] Using fallback response');
      emit(HomeLoaded(messages: messagesWithoutThinking..add(aiMessage)));
      await _saveMessageToCache(aiMessage);

      print('🔍 [BLOC_DEBUG] Added fallback response to chat');
    }
  }

  Future<void> _onCacheCurrentConversation(
    CacheCurrentConversation event,
    Emitter<HomeState> emit,
  ) async {
    // Cache current conversation when needed
    print('🔍 [BLOC_DEBUG] Caching current conversation...');
    for (final message in state.messages) {
      await _saveMessageToCache(message);
    }
    print('🔍 [BLOC_DEBUG] Conversation cached successfully');
  }

  Future<void> _saveMessageToCache(ChatMessage message) async {
    try {
      await _dbHelper.saveChatMessage(
        message.text,
        message.isUser,
        message.timestamp,
        isLoading: message.isLoading,
      );
      print(
        '🔍 [BLOC_DEBUG] Saved message to cache: ${message.isUser ? 'User' : 'AI'}',
      );
    } catch (e) {
      print('🔍 [BLOC_DEBUG] Error saving message to cache: $e');
    }
  }

  String _getFallbackResponse(String message) {
    final lowerMessage = message.toLowerCase();

    print('🔍 [FALLBACK_DEBUG] Processing query: "$message"');

    // EPL standings queries - More flexible matching
    if ((lowerMessage.contains('epl') ||
            lowerMessage.contains('premier') ||
            lowerMessage.contains('english')) &&
        (lowerMessage.contains('standing') ||
            lowerMessage.contains('table') ||
            lowerMessage.contains('league'))) {
      print('🔍 [FALLBACK_DEBUG] Matched EPL standings query');
      return '''
🏴󠁧󠁢󠁥󠁮󠁧󠁿 **English Premier League Standings (2024/25)**

🥇 **1. Manchester City** - 54 pts
🥈 **2. Arsenal** - 52 pts
🥉 **3. Liverpool** - 50 pts
4. **Aston Villa** - 45 pts
5. **Tottenham** - 44 pts
6. **Chelsea** - 42 pts
7. **Newcastle** - 40 pts
8. **Manchester United** - 38 pts
9. **West Ham** - 36 pts
10. **Crystal Palace** - 34 pts

*Note: This is approximate data. Check the Live Hub for real-time standings.*
''';
    }

    // ETH standings queries - More flexible matching
    if ((lowerMessage.contains('eth') ||
            lowerMessage.contains('ethiopia') ||
            lowerMessage.contains('ethiopian')) &&
        (lowerMessage.contains('standing') ||
            lowerMessage.contains('table') ||
            lowerMessage.contains('league'))) {
      print('🔍 [FALLBACK_DEBUG] Matched ETH standings query');
      return '''
🇪🇹 **Ethiopian Premier League Standings (2024/25)**

🥇 **1. Saint George** - 42 pts
🥈 **2. Ethiopian Coffee** - 38 pts
🥉 **3. Awassa City** - 35 pts
4. **Adama Kenema** - 33 pts
5. **Bahir Dar Kenema** - 31 pts
6. **Dire Dawa City** - 29 pts
7. **Hadiya Hossana** - 27 pts
8. **Jimma Aba Jifar** - 25 pts

*Note: This is approximate data. Check the Live Hub for real-time standings.*
''';
    }

    // Team information queries
    if (lowerMessage.contains('manchester united') ||
        lowerMessage.contains('man u') ||
        lowerMessage.contains('man united')) {
      print('🔍 [FALLBACK_DEBUG] Matched Manchester United query');
      return '''
🏴󠁧󠁢󠁥󠁮󠁧󠁿 **Manchester United**

**Club Information:**
• **Founded:** 1878
• **Stadium:** Old Trafford (74,310 capacity)
• **Manager:** Erik ten Hag
• **League:** Premier League
• **Premier League Titles:** 20

**Notable Players:**
• Marcus Rashford (Forward)
• Bruno Fernandes (Midfielder)
• Casemiro (Defensive Midfielder)
• Raphael Varane (Defender)

**Recent Form:** Mixed results this season
**Current Position:** 8th in Premier League

*For real-time stats, check the Live Hub!*
''';
    }

    if (lowerMessage.contains('chelsea')) {
      print('🔍 [FALLBACK_DEBUG] Matched Chelsea query');
      return '''
🏴󠁧󠁢󠁥󠁮󠁧󠁿 **Chelsea FC**

**Club Information:**
• **Founded:** 1905
• **Stadium:** Stamford Bridge (40,834 capacity)
• **Manager:** Mauricio Pochettino
• **League:** Premier League
• **Premier League Titles:** 6
• **Champions League Titles:** 2

**Notable Players:**
• Raheem Sterling (Forward)
• Mason Mount (Midfielder)
• Reece James (Defender)
• Wesley Fofana (Defender)

**Recent Form:** Strong defensive record
**Current Position:** 6th in Premier League

*For real-time stats, check the Live Hub!*
''';
    }

    if (lowerMessage.contains('saint george') ||
        lowerMessage.contains('st george') ||
        lowerMessage.contains('st. george')) {
      print('🔍 [FALLBACK_DEBUG] Matched Saint George query');
      return '''
🇪🇹 **Saint George SC**

**Club Information:**
• **Founded:** 1936
• **Stadium:** Addis Ababa Stadium
• **Manager:** Yohannes Sahle
• **League:** Ethiopian Premier League
• **League Titles:** 30+ (Most successful Ethiopian club)

**Notable Achievements:**
• Multiple Ethiopian Premier League titles
• Ethiopian Cup winner
• CAF Champions League participant

**Current Position:** 1st in Ethiopian Premier League
**Recent Form:** Strong title contenders

*For real-time stats, check the Live Hub!*
''';
    }

    // Comparison queries
    if (lowerMessage.contains('compare') ||
        lowerMessage.contains('vs') ||
        lowerMessage.contains('versus') ||
        (lowerMessage.contains('who') && lowerMessage.contains('better'))) {
      print('🔍 [FALLBACK_DEBUG] Matched comparison query');
      return '''
⚖️ **Club Comparison Feature**

You can compare any two clubs using the **Club Comparison** page!

**How to Compare:**
1. Go to the Club Comparison page
2. Select two teams from the dropdown
3. Click "Compare" to see detailed statistics

**Comparison includes:**
• Current league positions
• Recent form and results
• Head-to-head statistics
• Player comparisons
• Historical achievements

**Popular Comparisons:**
• Manchester United vs Liverpool
• Chelsea vs Arsenal
• Saint George vs Ethiopian Coffee

Try the Club Comparison page for detailed analysis! 📊
''';
    }

    // Live matches queries
    if (lowerMessage.contains('live') ||
        lowerMessage.contains('match') ||
        lowerMessage.contains('game') ||
        lowerMessage.contains('fixture') ||
        lowerMessage.contains('result') ||
        lowerMessage.contains('score') ||
        lowerMessage.contains('today')) {
      print('🔍 [FALLBACK_DEBUG] Matched live matches query');
      return '''
⚽ **Live Matches & Fixtures**

**Check the Live Hub for:**
• **Live match scores** - Real-time updates
• **Upcoming fixtures** - Next matches
• **Match results** - Recent games
• **League tables** - Current standings

**Current Live Matches:**
• EPL: Multiple matches every weekend
• ETH: Ethiopian Premier League matches

**Features:**
• Live score updates
• Match statistics
• Team lineups
• Goal scorers

Go to the Live Hub page for all match information! 🏆
''';
    }

    // Player queries
    if (lowerMessage.contains('player') ||
        lowerMessage.contains('who plays') ||
        (lowerMessage.contains('best') && lowerMessage.contains('player'))) {
      print('🔍 [FALLBACK_DEBUG] Matched player query');
      return '''
⚽ **Player Information**

**Popular EPL Players:**
• **Mohamed Salah** (Liverpool) - Egyptian forward
• **Kevin De Bruyne** (Manchester City) - Belgian midfielder
• **Harry Kane** (Tottenham) - English striker
• **Bruno Fernandes** (Manchester United) - Portuguese midfielder

**Popular ETH Players:**
• **Getaneh Kebede** (Saint George) - Ethiopian striker
• **Shimelis Bekele** (Ethiopian Coffee) - Ethiopian midfielder

**Player Statistics Available:**
• Goals scored
• Assists
• Appearances
• Minutes played

For detailed player stats, check the Live Hub! 📊
''';
    }

    // Statistics queries
    if (lowerMessage.contains('stats') ||
        lowerMessage.contains('statistics') ||
        lowerMessage.contains('performance') ||
        lowerMessage.contains('form')) {
      print('🔍 [FALLBACK_DEBUG] Matched statistics query');
      return '''
📊 **Team & Player Statistics**

**Available Statistics:**
• **Team Performance:** Wins, draws, losses, goals
• **Player Stats:** Goals, assists, appearances
• **League Tables:** Current standings and positions
• **Head-to-Head:** Historical match results

**Top Performing Teams (EPL):**
• Manchester City - Best attack
• Arsenal - Best defense
• Liverpool - Most consistent

**Top Performing Teams (ETH):**
• Saint George - League leaders
• Ethiopian Coffee - Strong challengers

Check the Live Hub for detailed statistics! 📈
''';
    }

    // Transfer/market queries
    if (lowerMessage.contains('transfer') ||
        lowerMessage.contains('market') ||
        lowerMessage.contains('buy') ||
        lowerMessage.contains('sell') ||
        lowerMessage.contains('sign') ||
        lowerMessage.contains('contract')) {
      print('🔍 [FALLBACK_DEBUG] Matched transfer query');
      return '''
🔄 **Transfer News & Market**

**Recent Major Transfers:**
• **EPL Transfers:** Summer window activity
• **ETH Transfers:** Local and international moves

**Transfer Windows:**
• **Summer Window:** June 1 - September 1
• **Winter Window:** January 1 - January 31

**Popular Transfer Targets:**
• Young talents from academies
• International players
• Free agents

For latest transfer news, check sports websites! 📰
''';
    }

    // General football queries
    if (lowerMessage.contains('hello') ||
        lowerMessage.contains('hi') ||
        lowerMessage.contains('hey') ||
        lowerMessage.contains('start') ||
        lowerMessage.contains('begin')) {
      print('🔍 [FALLBACK_DEBUG] Matched greeting query');
      return '''
👋 Hello! I'm your AI football assistant!

I can help you with:
• **EPL & ETH League standings** 🏴󠁧󠁢󠁥󠁮󠁧󠁿🇪🇹
• **Team information and statistics** 📊
• **Player details** ⚽
• **Match results and fixtures** 📅
• **Club comparisons** ⚖️

**Try asking me:**
• "EPL standings" - Premier League table
• "ETH standings" - Ethiopian League table
• "Manchester United" - Team information
• "Chelsea" - Team details
• "Saint George" - Ethiopian team info
• "Compare teams" - Club comparison guide
• "Live matches" - Match information
• "Help" - See all available commands

⚽ What would you like to know about football?
''';
    }

    if (lowerMessage.contains('help') ||
        lowerMessage.contains('what can you do') ||
        lowerMessage.contains('commands') ||
        lowerMessage.contains('features')) {
      print('🔍 [FALLBACK_DEBUG] Matched help query');
      return '''
🤖 **AI Football Assistant - Help**

**Available Commands:**
• "EPL standings" - English Premier League table
• "ETH standings" - Ethiopian Premier League table
• "Premier League table" - Same as EPL standings
• "Team name" - Information about specific teams
• "Compare teams" - Club comparison guide
• "Live matches" - Current games and results
• "Player info" - Popular player information
• "Statistics" - Team and player stats
• "Transfers" - Transfer news and market info

**Popular Teams:**
• **EPL:** Manchester United, Chelsea, Arsenal, Liverpool
• **ETH:** Saint George, Ethiopian Coffee, Awassa City

**Features:**
• Real-time league standings
• Team statistics and history
• Player profiles and stats
• Live match updates
• Club comparison tools
• Transfer market information

💡 **Tip:** You can also use the Live Hub and Comparison pages for interactive features!

What can I help you with today? ⚽
''';
    }

    // Default fallback
    print(
      '🔍 [FALLBACK_DEBUG] No specific match found, using default response',
    );
    return '''
🤖 I'm currently experiencing some connection issues, but I can still help with basic queries!

**Try these commands:**
• "EPL standings" - Premier League table
• "ETH standings" - Ethiopian League table
• "Manchester United" - Team information
• "Chelsea" - Team details
• "Saint George" - Ethiopian team info
• "Compare teams" - Club comparison guide
• "Live matches" - Match information
• "Player info" - Popular player details
• "Statistics" - Team and player stats
• "Transfers" - Transfer market news
• "Help" - See all available commands

For full AI features, please check back later when the connection is restored.

⚽ What would you like to know about football?
''';
  }

  @override
  Future<void> close() {
    // Don't close the BLoC when navigating away - keep it alive for when user returns
    print(
      '🔍 [BLOC_DEBUG] HomeBloc close() called - ignoring to prevent lifecycle issues',
    );
    return Future.value(); // Return a completed future without actually closing
  }
}
