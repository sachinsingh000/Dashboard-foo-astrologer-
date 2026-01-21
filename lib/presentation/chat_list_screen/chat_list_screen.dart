import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/app_export.dart';
import '../../services/chat_service.dart';
import '../../widgets/custom_app_bar.dart';
import 'widgets/chat_list_item_widget.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _loading = true;

  List<dynamic> activeChats = [];
  List<dynamic> pastChats = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadChatSessions();
  }

  Future<void> _loadChatSessions() async {
    final result = await ChatService.fetchChatSessions();

    setState(() {
      activeChats = result["active"] ?? [];
      pastChats = result["past"] ?? [];
      _loading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar.standard(title: "Chats"),
      body: Column(
        children: [
          // Tabs
          Container(
            color: theme.colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              indicatorColor: theme.colorScheme.primary,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
              tabs: const [
                Tab(text: "Active"),
                Tab(text: "Past"),
              ],
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
              controller: _tabController,
              children: [
                _buildChatList(activeChats),
                _buildChatList(pastChats),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(List<dynamic> chats) {
    if (chats.isEmpty) {
      return Center(
        child: Text(
          "No chats found",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(3.w),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        return ChatListItemWidget(
          data: chats[index],
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.chatInterface,
              arguments: {
                "roomId": chats[index]["roomId"],
                "sessionId": chats[index]["_id"],
                "client": chats[index]["user"]
              },
            );
          },
        );
      },
    );
  }
}
