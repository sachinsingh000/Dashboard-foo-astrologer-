import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/availability_toggle.dart';
import './widgets/consultation_history_list.dart';
import './widgets/earnings_overview_card.dart';
import './widgets/metrics_cards.dart';
import './widgets/quick_actions_bar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _currentBottomNavIndex = 0;
  AvailabilityStatus _currentAvailabilityStatus = AvailabilityStatus.offline;
  bool _isLoading = false;
  bool _hasIncomingRequest = false;

  // Mock data
  double _todayEarnings = 245.50;
  int _consultationCount = 8;
  String _averageSessionDuration = '32m';
  int _pendingRequests = 3;
  int _activeChatSessions = 2;
  double _walletBalance = 1250.75;
  int _todayScheduleCount = 5;

  final List<Map<String, dynamic>> _consultationHistory = [
    {
      'id': 1,
      'clientName': 'Sarah Johnson',
      'serviceType': 'Video Call',
      'duration': '45m',
      'earnings': 67.50,
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'Completed',
    },
    {
      'id': 2,
      'clientName': 'Michael Chen',
      'serviceType': 'Chat',
      'duration': '28m',
      'earnings': 42.00,
      'timestamp': DateTime.now().subtract(const Duration(hours: 4)),
      'status': 'Completed',
    },
    {
      'id': 3,
      'clientName': 'Emma Rodriguez',
      'serviceType': 'Audio Call',
      'duration': '35m',
      'earnings': 52.50,
      'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
      'status': 'Completed',
    },
    {
      'id': 4,
      'clientName': 'David Wilson',
      'serviceType': 'Report',
      'duration': '2h',
      'earnings': 85.00,
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'Pending',
    },
    {
      'id': 5,
      'clientName': 'Lisa Thompson',
      'serviceType': 'Chat',
      'duration': '22m',
      'earnings': 33.00,
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'Completed',
    },
  ];

  @override
  void initState() {
    super.initState();
    _simulateIncomingRequests();
  }

  void _simulateIncomingRequests() {
    Future.delayed(const Duration(seconds: 10), () {
      if (_currentAvailabilityStatus == AvailabilityStatus.online && mounted) {
        setState(() {
          _hasIncomingRequest = true;
          _pendingRequests++;
        });
        _showIncomingRequestNotification();
      }
    });
  }

  void _showIncomingRequestNotification() {
    HapticFeedback.mediumImpact();

    Flushbar(
      message: 'New consultation request from Jennifer Martinez',
      duration: const Duration(seconds: 5),
      backgroundColor: AppTheme.getSuccessColor(context),
      icon: CustomIconWidget(
        iconName: 'notifications',
        color: Colors.white,
        size: 24,
      ),
      mainButton: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/consultation-requests-screen');
        },
        child: const Text(
          'VIEW',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      flushbarPosition: FlushbarPosition.TOP,
      margin: EdgeInsets.all(4.w),
      borderRadius: BorderRadius.circular(12),
    ).show(context);
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _todayEarnings += 15.50; // Simulate new earnings
        _consultationCount += 1;
      });
    }
  }

  void _onAvailabilityChanged(AvailabilityStatus status) {
    setState(() => _currentAvailabilityStatus = status);

    String message;
    Color backgroundColor;

    switch (status) {
      case AvailabilityStatus.online:
        message = 'You\'re now online and visible to clients';
        backgroundColor = AppTheme.getSuccessColor(context);
        _simulateIncomingRequests();
        break;
      case AvailabilityStatus.busy:
        message = 'Status updated to busy - limited availability';
        backgroundColor = AppTheme.getWarningColor(context);
        break;
      case AvailabilityStatus.offline:
        message = 'You\'re now offline - clients can\'t reach you';
        backgroundColor = Theme.of(context).colorScheme.outline;
        break;
    }

    Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: backgroundColor,
      flushbarPosition: FlushbarPosition.BOTTOM,
      margin: EdgeInsets.all(4.w),
      borderRadius: BorderRadius.circular(12),
    ).show(context);
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentBottomNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar.dashboard(title: 'AstroPro Dashboard'),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: theme.colorScheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Earnings Overview Card
                EarningsOverviewCard(
                  todayEarnings: _todayEarnings,
                  consultationCount: _consultationCount,
                  averageSessionDuration: _averageSessionDuration,
                  onTap: () => Navigator.pushNamed(
                      context, '/wallet-and-earnings-screen'),
                ),

                // Availability Toggle
                AvailabilityToggle(
                  currentStatus: _currentAvailabilityStatus,
                  onStatusChanged: _onAvailabilityChanged,
                ),

                // Metrics Cards
                MetricsCards(
                  pendingRequests: _pendingRequests,
                  activeChatSessions: _activeChatSessions,
                  walletBalance: _walletBalance,
                  todayScheduleCount: _todayScheduleCount,
                ),

                // Quick Actions Bar
                QuickActionsBar(
                  onUpdateAvailability: () => _showAvailabilityDialog(),
                  onViewRequests: () => Navigator.pushNamed(
                      context, '/consultation-requests-screen'),
                  onAccessWallet: () => Navigator.pushNamed(
                      context, '/wallet-and-earnings-screen'),
                  onCreateReport: () =>
                      Navigator.pushNamed(context, '/report-editor-screen'),
                ),

                SizedBox(height: 2.h),

                // Consultation History List
                ConsultationHistoryList(
                  consultations: _consultationHistory,
                  onRefresh: _refreshData,
                ),

                SizedBox(height: 10.h), // Bottom padding for FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/report-editor-screen'),
        icon: CustomIconWidget(
          iconName: 'add',
          color: theme.colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'New Report',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
      ),
      bottomNavigationBar: CustomBottomBar.standard(
        currentIndex: _currentBottomNavIndex,
        onTap: _onBottomNavTap,
      ),
    );
  }

  void _showAvailabilityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Availability'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AvailabilityStatus.values.map((status) {
            return RadioListTile<AvailabilityStatus>(
              title: Text(_getStatusText(status)),
              value: status,
              groupValue: _currentAvailabilityStatus,
              onChanged: (value) {
                if (value != null) {
                  Navigator.pop(context);
                  _onAvailabilityChanged(value);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  String _getStatusText(AvailabilityStatus status) {
    switch (status) {
      case AvailabilityStatus.online:
        return 'Online - Available for consultations';
      case AvailabilityStatus.busy:
        return 'Busy - Limited availability';
      case AvailabilityStatus.offline:
        return 'Offline - Not accepting requests';
    }
  }
}
