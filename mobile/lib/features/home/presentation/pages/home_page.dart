import 'package:ethio_football/features/home/domain/entities/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ethio_football/features/home/presentation/bloc/home_bloc.dart'
    hide AIChatService;
import 'package:ethio_football/features/home/presentation/bloc/home_event.dart';
import 'package:ethio_football/features/home/presentation/bloc/home_state.dart';
import 'package:ethio_football/features/home/data/datasources/ai_service_datasource.dart';

// Theme constants
import 'package:ethio_football/core/Presentation/constants/colors.dart';
import 'package:ethio_football/core/Presentation/constants/text_styles.dart';
import 'package:ethio_football/core/Presentation/constants/dimensions.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => context.read<HomeBloc>()..add(LoadInitialMessages()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print(
      '🔍 [UI_DEBUG] HomePage initialized - AI Chat debug logging is ACTIVE',
    );
    print('🔍 [UI_DEBUG] AI Service base URL: ${AIChatService.baseUrl}');
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    print('🔍 [UI_DEBUG] Starting to send message: "$text"');

    context.read<HomeBloc>().add(SendMessage(message: text));
    _messageController.clear();

    // Scroll to bottom immediately for user message
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'AI Football Assistant',
          style: TextStyle(
            color: isDark ? Colors.white : Color(0xFF121212),
            fontWeight: FontWeight.bold,
            fontSize: kTitleFontSize(context),
          ),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kAccentColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading chat history...',
                    style: TextStyle(
                      color: kPrimaryTextColor,
                      fontSize: kClubNameFontSize(context),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Chat messages area
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF121212) : Colors.white,
                  ),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
                ),
              ),

              // Message input area
              Container(
                padding: kCardPadding,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(255, 39, 39, 39)
                      : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Ask me about football...',
                          hintStyle: TextStyle(
                            color: kSecondaryTextColor,
                            fontSize: kSearchBarText(context),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                            borderSide: BorderSide(
                              color: kAccentColor.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                            borderSide: BorderSide(color: kAccentColor),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: kPrimaryButtonColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: kCardColor),
                        onPressed: _sendMessage,
                        tooltip: 'Send message',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final kCardColor = isDark
        ? const Color.fromARGB(255, 44, 44, 44)
        : Colors.white;
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? kPrimaryButtonColor : kCardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kBorderRadius),
            topRight: Radius.circular(kBorderRadius),
            bottomLeft: message.isUser
                ? Radius.circular(kBorderRadius)
                : const Radius.circular(4),
            bottomRight: message.isUser
                ? const Radius.circular(4)
                : Radius.circular(kBorderRadius),
          ),
          boxShadow: [
            BoxShadow(
              color: kAccentColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.isUser)
              Text(
                message.text,
                style: TextStyle(
                  color: kCardColor,
                  fontSize: kClubNameFontSize(context),
                ),
              )
            else
              Markdown(
                data: message.text,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: kClubNameFontSize(context),
                  ),
                  h1: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: kTitleFontSize(context),
                    fontWeight: FontWeight.bold,
                  ),
                  h2: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: kClubNameFontSize(context) + 2,
                    fontWeight: FontWeight.bold,
                  ),
                  h3: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: kClubNameFontSize(context),
                    fontWeight: FontWeight.bold,
                  ),
                  strong: const TextStyle(fontWeight: FontWeight.bold),
                  em: const TextStyle(fontStyle: FontStyle.italic),
                  listBullet: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: kClubNameFontSize(context),
                  ),
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                color: message.isUser
                    ? kCardColor.withOpacity(0.7)
                    : kSecondaryTextColor,
                fontSize: kDescriptionFontSize(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kBorderRadius),
            topRight: Radius.circular(kBorderRadius),
            bottomLeft: const Radius.circular(4),
            bottomRight: Radius.circular(kBorderRadius),
          ),
          boxShadow: [
            BoxShadow(
              color: kAccentColor.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: kIconSize.toDouble(),
              height: kIconSize.toDouble(),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(kAccentColor),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Thinking...',
              style: TextStyle(
                color: kSecondaryTextColor,
                fontSize: kDescriptionFontSize(context),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
