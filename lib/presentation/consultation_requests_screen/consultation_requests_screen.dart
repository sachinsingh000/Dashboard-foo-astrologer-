import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/chat_service.dart';
import '../chat_list_screen/widgets/connecting_popup.dart';
import './widgets/availability_toggle_widget.dart';
import './widgets/decline_reason_modal.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_tabs_widget.dart';
import './widgets/request_card_widget.dart';
import '../../services/chat_socket_service.dart';

class ConsultationRequestsScreen extends StatefulWidget {
  const ConsultationRequestsScreen({super.key});

  @override
  State<ConsultationRequestsScreen> createState() =>
      _ConsultationRequestsScreenState();
}

class _ConsultationRequestsScreenState extends State<ConsultationRequestsScreen>
    with TickerProviderStateMixin {
  int selectedFilterIndex = 0;
  bool isOnline = true;
  String currentStatus = 'online';
  bool isLoading = false;
  bool isRefreshing = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<Map<String, dynamic>> requests = [];

  // Mock data for consultation requests
  // final List<Map<String, dynamic>> mockRequests = [
  //   {
  //     "id": "req_001",
  //     "clientName": "Priya Sharma",
  //     "clientAvatar":
  //     "https://img.rocket.new/generatedImages/rocket_gen_img_1d576aab7-1763295526435.png",
  //     "clientAvatarSemanticLabel":
  //     "Professional headshot of an Indian woman with long black hair wearing a white blouse, smiling warmly at the camera",
  //     "clientLocation": "Mumbai, India",
  //     "consultationType": "chat",
  //     "duration": 30,
  //     "question":
  //     "I'm facing career confusion and need guidance about my professional path. Should I continue in my current job or take the risk of starting my own business? My birth details are 15th March 1992, 10:30 AM, Mumbai.",
  //     "specialRequirements": "Please focus on career and financial aspects",
  //     "offeredRate": "\$2.50",
  //     "timestamp": DateTime.now().subtract(const Duration(minutes: 3)),
  //     "isReturningClient": true,
  //   },
  //   {
  //     "id": "req_002",
  //     "clientName": "Michael Johnson",
  //     "clientAvatar":
  //     "https://img.rocket.new/generatedImages/rocket_gen_img_1e476ac74-1763294891443.png",
  //     "clientAvatarSemanticLabel":
  //     "Professional headshot of a Caucasian man with short brown hair and beard wearing a navy blue suit jacket",
  //     "clientLocation": "New York, USA",
  //     "consultationType": "video",
  //     "duration": 45,
  //     "question":
  //     "I'm going through a difficult phase in my relationship and marriage. We've been having constant arguments and I want to understand if this is temporary or if we should consider separation.",
  //     "specialRequirements": null,
  //     "offeredRate": "\$4.00",
  //     "timestamp": DateTime.now().subtract(const Duration(minutes: 8)),
  //     "isReturningClient": false,
  //   },
  //   {
  //     "id": "req_003",
  //     "clientName": "Sarah Chen",
  //     "clientAvatar":
  //     "https://img.rocket.new/generatedImages/rocket_gen_img_1dc908441-1763296904445.png",
  //     "clientAvatarSemanticLabel":
  //     "Professional headshot of an Asian woman with shoulder-length black hair wearing a light blue blouse, smiling confidently",
  //     "clientLocation": "Singapore",
  //     "consultationType": "audio",
  //     "duration": 20,
  //     "question":
  //     "I need guidance about my health issues and when I might recover. I've been dealing with chronic fatigue for months now and doctors can't find the root cause.",
  //     "specialRequirements": "Please include health predictions and remedies",
  //     "offeredRate": "\$3.25",
  //     "timestamp": DateTime.now().subtract(const Duration(minutes: 5)),
  //     "isReturningClient": false,
  //   },
  //   {
  //     "id": "req_004",
  //     "clientName": "David Rodriguez",
  //     "clientAvatar":
  //     "https://img.rocket.new/generatedImages/rocket_gen_img_138df7967-1763295321074.png",
  //     "clientAvatarSemanticLabel":
  //     "Professional headshot of a Hispanic man with short black hair wearing a gray suit and tie, looking directly at camera",
  //     "clientLocation": "Mexico City, Mexico",
  //     "consultationType": "report",
  //     "duration": 0,
  //     "question":
  //     "I would like a comprehensive birth chart analysis report covering all aspects of my life including career, relationships, health, and spiritual growth. Born 22nd July 1988, 6:45 PM, Mexico City.",
  //     "specialRequirements":
  //     "Detailed written report with remedies and gemstone recommendations",
  //     "offeredRate": "\$75.00",
  //     "timestamp": DateTime.now().subtract(const Duration(minutes: 12)),
  //     "isReturningClient": true,
  //   },
  // ];

  final List<Map<String, dynamic>> filterTabs = [
    {"label": "All", "icon": "inbox", "count": 4},
    {"label": "Chat", "icon": "chat", "count": 1},
    {"label": "Audio", "icon": "call", "count": 1},
    {"label": "Video", "icon": "videocam", "count": 1},
    {"label": "Reports", "icon": "description", "count": 1},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();

    _loadRequests();

    ChatSocketService.requestsStream.listen((data) {
      if (!mounted) return;
      _loadRequests(showLoader: false);
    });

    // after user accepts the call
    ChatSocketService.eventsStream.listen((event) {
      if (!mounted) return;

      if (event["event"] != "session_connected") return;

      // close ConnectingPopup
      Navigator.pop(context);

      final String type = event["type"]; // chat | audio | video

      if (type == "chat") {
        // 🟢 CHAT FLOW
        Navigator.pushReplacementNamed(
          context,
          "/chat-interface-screen",
          arguments: {
            "roomId": event["roomId"],
            "userId": event["userId"],
            "userName": event["userName"],
            "userImage": event["userImage"],
          },
        );
        return;
      }

      // 🔵 CALL FLOW (audio / video)
      Navigator.pushReplacementNamed(
        context,
        "/connecting-call-screen",
        arguments: {
          "sessionId": event["sessionId"],
          "roomId": event["roomId"],
          "type": type, // audio or video
        },
      );
    });

  }

  Future<void> _loadRequests({bool showLoader = true}) async {
    if (showLoader) {
      setState(() => isLoading = true);
    }

    try {
      final raw = await ChatService.fetchRequests();

      final parsed = raw.map<Map<String, dynamic>>((r) {
        return {
          // 🔑 REQUIRED by RequestCardWidget
          "id": r["_id"]?.toString(),
          "consultationType": r["type"],

          "clientName": r["userName"] ?? "User",
          "clientAvatar": r["userImage"]?.isNotEmpty == true
              ? r["userImage"]
              : "https://ui-avatars.com/api/?name=${r["userName"] ?? "User"}",

          "clientAvatarSemanticLabel": "Client profile image",
          "clientLocation": null,

          "duration": 10, // ⏱ fallback (backend doesn't send yet)
          "question": "User wants to start a ${r["type"]} consultation",
          "specialRequirements": null,

          "offeredRate": "₹${r["ratePerMinute"]}/min",
          "timestamp": DateTime.parse(r["createdAt"]),

          "isReturningClient": false,

          // 🔧 extra (used later)
          "sessionId": r["sessionId"],
          "roomId": r["roomId"],
          "status": r["status"],
        };
      }).toList();

      setState(() {
        requests = parsed;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ loadRequests failed: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredRequests = _getFilteredRequests();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Consultation Requests',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        actions: [
          IconButton(
            onPressed: _showNotifications,
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'notifications',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/profile-management-screen'),
            icon: CustomIconWidget(
              iconName: 'settings',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: theme.colorScheme.primary,
          child: Column(
            children: [
              AvailabilityToggleWidget(
                isOnline: isOnline,
                currentStatus: currentStatus,
                onToggle: _handleAvailabilityToggle,
              ),
              FilterTabsWidget(
                filterTabs: filterTabs,
                selectedIndex: selectedFilterIndex,
                onTabSelected: _handleFilterTabSelected,
              ),
              Expanded(
                child: isLoading
                    ? _buildLoadingState(theme)
                    : filteredRequests.isEmpty
                        ? EmptyStateWidget(
                            filterType: filterTabs[selectedFilterIndex]['label']
                                as String,
                            isOnline: isOnline,
                            onGoOnline: () => _handleAvailabilityToggle(true),
                          )
                        : _buildRequestsList(filteredRequests),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          height: 25.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildRequestsList(List<Map<String, dynamic>> requests) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];

        return Slidable(
          key: Key(request['id'] as String),
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (_) => _handleAcceptRequest(request),
                backgroundColor: AppTheme.getSuccessColor(context),
                foregroundColor: Colors.white,
                icon: Icons.check,
                label: 'Accept',
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (_) => _handleDeclineRequest(request),
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
                foregroundColor: Colors.white,
                icon: Icons.close,
                label: 'Decline',
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(16),
                ),
              ),
            ],
          ),
          child: RequestCardWidget(
            request: request,
            onAccept: () => _handleAcceptRequest(request),
            onDecline: () => _handleDeclineRequest(request),
            onTap: () => _handleRequestTap(request),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getFilteredRequests() {
    if (!isOnline) return [];

    final filterType = filterTabs[selectedFilterIndex]['label'] as String;

    if (filterType == 'All') {
      return requests;
    }

    return requests.where((request) {
      final consultationType = request['consultationType'] as String;
      switch (filterType.toLowerCase()) {
        case 'chat':
          return consultationType == 'chat';
        case 'audio':
          return consultationType == 'audio';
        case 'video':
          return consultationType == 'video';
        case 'reports':
          return consultationType == 'report';
        default:
          return true;
      }
    }).toList();
  }

  void _handleFilterTabSelected(int index) {
    setState(() {
      selectedFilterIndex = index;
    });
    HapticFeedback.lightImpact();
  }

  void _handleAvailabilityToggle(bool value) {
    setState(() {
      isOnline = value;
      currentStatus = value ? 'online' : 'offline';
    });
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'You are now online and accepting requests'
              : 'You are now offline and not accepting requests',
        ),
        backgroundColor: value
            ? AppTheme.getSuccessColor(context)
            : AppTheme.lightTheme.colorScheme.error,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() => isRefreshing = true);

    await _loadRequests(showLoader: false);

    setState(() => isRefreshing = false);
    HapticFeedback.lightImpact();
  }

  Future<void> _handleAcceptRequest(Map<String, dynamic> request) async {
    try {
      // 1️⃣ Tell backend: astrologer accepted
      await ChatService.accept(request["sessionId"]);

      // 2️⃣ Show CONNECTING popup locally
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ConnectingPopup(
          clientName: request["userName"] ?? "User",
          clientAvatar: request["userImage"] ?? "",
          isCall: request["type"] == "call",
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to accept request")),
      );
    }
  }

  void _handleDeclineRequest(Map<String, dynamic> request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DeclineReasonModal(
          onReasonSelected: (reason) {
            final clientName = request['clientName'] as String;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Declined consultation request from $clientName'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleRequestTap(Map<String, dynamic> request) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildRequestDetailsModal(request),
    );
  }

  Widget _buildRequestDetailsModal(Map<String, dynamic> request) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: request['clientAvatar'] as String,
                    width: 15.w,
                    height: 15.w,
                    fit: BoxFit.cover,
                    semanticLabel:
                        request['clientAvatarSemanticLabel'] as String,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request['clientName'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${request['consultationType'].toString().toUpperCase()} • ${request['duration']} min • ${request['offeredRate']}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            'Full Question:',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            request['question'] as String,
            style: theme.textTheme.bodyMedium,
          ),
          if (request['specialRequirements'] != null) ...[
            SizedBox(height: 2.h),
            Text(
              'Special Requirements:',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.secondary,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              request['specialRequirements'] as String,
              style: theme.textTheme.bodyMedium,
            ),
          ],
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleDeclineRequest(request);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(color: theme.colorScheme.error),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text('Decline'),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _handleAcceptRequest(request);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  child: Text('Accept'),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  void _showNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications feature coming soon!'),
      ),
    );
  }
}
