import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/earnings_chart.dart';
import './widgets/earnings_summary_card.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/payout_method_card.dart';
import './widgets/transaction_item.dart';

class WalletAndEarningsScreen extends StatefulWidget {
  const WalletAndEarningsScreen({super.key});

  @override
  State<WalletAndEarningsScreen> createState() =>
      _WalletAndEarningsScreenState();
}

class _WalletAndEarningsScreenState extends State<WalletAndEarningsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String _selectedChartPeriod = '7D';
  Map<String, dynamic> _currentFilters = {
    'transactionType': 'All',
    'status': 'All',
    'dateRange': 'All Time',
    'minAmount': 0.0,
    'maxAmount': 5000.0,
  };

  // Mock data for wallet and earnings
  final Map<String, dynamic> _walletData = {
    'availableBalance': 2847.50,
    'totalEarnings': 15420.75,
    'pendingAmount': 320.00,
    'commission': 15.5, // percentage
  };

  final List<Map<String, dynamic>> _earningsSummary = [
    {
      'title': 'Today',
      'amount': '\$125.50',
      'percentage': '+12.5%',
      'isPositive': true,
      'icon': Icons.today,
    },
    {
      'title': 'This Week',
      'amount': '\$890.25',
      'percentage': '+8.3%',
      'isPositive': true,
      'icon': Icons.calendar_view_week,
    },
    {
      'title': 'This Month',
      'amount': '\$3,245.80',
      'percentage': '-2.1%',
      'isPositive': false,
      'icon': Icons.calendar_month,
    },
  ];

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': '1',
      'type': 'chat',
      'clientName': 'Sarah Johnson',
      'amount': '\$45.00',
      'isCredit': true,
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'completed',
      'duration': '30 minutes',
      'commission': '\$6.75',
    },
    {
      'id': '2',
      'type': 'video',
      'clientName': 'Michael Chen',
      'amount': '\$120.00',
      'isCredit': true,
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'status': 'completed',
      'duration': '45 minutes',
      'commission': '\$18.00',
    },
    {
      'id': '3',
      'type': 'withdrawal',
      'clientName': 'Bank Transfer',
      'amount': '\$500.00',
      'isCredit': false,
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'processing',
      'duration': null,
      'commission': null,
    },
    {
      'id': '4',
      'type': 'report',
      'clientName': 'Emma Wilson',
      'amount': '\$75.00',
      'isCredit': true,
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'completed',
      'duration': null,
      'commission': '\$11.25',
    },
    {
      'id': '5',
      'type': 'audio',
      'clientName': 'David Rodriguez',
      'amount': '\$60.00',
      'isCredit': true,
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'completed',
      'duration': '25 minutes',
      'commission': '\$9.00',
    },
    {
      'id': '6',
      'type': 'refund',
      'clientName': 'Lisa Anderson',
      'amount': '\$30.00',
      'isCredit': false,
      'timestamp': DateTime.now().subtract(const Duration(days: 4)),
      'status': 'completed',
      'duration': null,
      'commission': null,
    },
    {
      'id': '7',
      'type': 'bonus',
      'clientName': 'Platform Bonus',
      'amount': '\$50.00',
      'isCredit': true,
      'timestamp': DateTime.now().subtract(const Duration(days: 5)),
      'status': 'completed',
      'duration': null,
      'commission': null,
    },
  ];

  final List<Map<String, dynamic>> _chartData = [
    {'label': 'Mon', 'value': 1200.0},
    {'label': 'Tue', 'value': 1800.0},
    {'label': 'Wed', 'value': 1500.0},
    {'label': 'Thu', 'value': 2200.0},
    {'label': 'Fri', 'value': 2800.0},
    {'label': 'Sat', 'value': 3200.0},
    {'label': 'Sun', 'value': 2900.0},
  ];

  final List<Map<String, dynamic>> _payoutMethods = [
    {
      'id': '1',
      'type': 'bank',
      'bankName': 'Chase Bank',
      'accountNumber': '1234567890',
      'holderName': 'Dr. Priya Sharma',
      'isDefault': true,
    },
    {
      'id': '2',
      'type': 'paypal',
      'bankName': 'PayPal',
      'accountNumber': 'priya.sharma@email.com',
      'holderName': 'Dr. Priya Sharma',
      'isDefault': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar.standard(
        title: 'Wallet & Earnings',
      ),
      body: Column(
        children: [
          _buildTabBar(context),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(context),
                _buildTransactionsTab(context),
                _buildAnalyticsTab(context),
                _buildPayoutTab(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar.standard(
        currentIndex: 3,
        onTap: (index) => _onBottomNavTap(index),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Transactions'),
          Tab(text: 'Analytics'),
          Tab(text: 'Payout'),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            _buildWalletBalanceCard(context),
            SizedBox(height: 3.h),
            _buildEarningsSummarySection(context),
            SizedBox(height: 3.h),
            _buildQuickActionsSection(context),
            SizedBox(height: 3.h),
            _buildRecentTransactionsSection(context),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsTab(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'All Transactions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                onPressed: _showFilterBottomSheet,
                icon: CustomIconWidget(
                  iconName: 'filter_list',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: _transactions.isEmpty
                ? _buildEmptyTransactions(context)
                : ListView.builder(
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _transactions[index];
                      return TransactionItem(
                        transaction: transaction,
                        onTap: () => _showTransactionDetails(transaction),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 2.h),
            EarningsChart(
              chartData: _chartData,
              selectedPeriod: _selectedChartPeriod,
              onPeriodChanged: (period) {
                setState(() {
                  _selectedChartPeriod = period;
                });
              },
            ),
            SizedBox(height: 3.h),
            _buildConsultationBreakdown(context),
            SizedBox(height: 3.h),
            _buildPerformanceMetrics(context),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPayoutTab(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            _buildPayoutSummary(context),
            SizedBox(height: 3.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payout Methods',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _addPayoutMethod,
                    icon: CustomIconWidget(
                      iconName: 'add',
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                    label: const Text('Add Method'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            ..._payoutMethods.map((method) => PayoutMethodCard(
                  payoutMethod: method,
                  onEdit: () => _editPayoutMethod(method),
                  onDelete: () => _deletePayoutMethod(method),
                )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletBalanceCard(BuildContext context) {
    final theme = Theme.of(context);
    final availableBalance = _walletData['availableBalance'] as double;
    final pendingAmount = _walletData['pendingAmount'] as double;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Balance',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                ),
              ),
              CustomIconWidget(
                iconName: 'account_balance_wallet',
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                size: 24,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            '\$${availableBalance.toStringAsFixed(2)}',
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 32.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pending',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      '\$${pendingAmount.toStringAsFixed(2)}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: availableBalance >= 50 ? _initiateWithdrawal : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.onPrimary,
                  foregroundColor: theme.colorScheme.primary,
                  padding:
                      EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                ),
                child: const Text('Withdraw'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsSummarySection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Earnings Summary',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 20.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: _earningsSummary.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final summary = _earningsSummary[index];
              return EarningsSummaryCard(
                title: summary['title'] as String,
                amount: summary['amount'] as String,
                percentage: summary['percentage'] as String,
                isPositive: summary['isPositive'] as bool,
                icon: summary['icon'] as IconData,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  context: context,
                  icon: 'download',
                  label: 'Download Statement',
                  onTap: _downloadStatement,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildQuickActionButton(
                  context: context,
                  icon: 'receipt',
                  label: 'Tax Information',
                  onTap: _viewTaxInfo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required BuildContext context,
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.getAccentColor(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w500,
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

  Widget _buildRecentTransactionsSection(BuildContext context) {
    final theme = Theme.of(context);
    final recentTransactions = _transactions.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  _tabController.animateTo(1);
                },
                child: const Text('View All'),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        ...recentTransactions.map((transaction) => TransactionItem(
              transaction: transaction,
              onTap: () => _showTransactionDetails(transaction),
            )),
      ],
    );
  }

  Widget _buildConsultationBreakdown(BuildContext context) {
    final theme = Theme.of(context);

    final consultationData = [
      {
        'type': 'Chat',
        'count': 45,
        'earnings': 1350.0,
        'color': theme.colorScheme.primary
      },
      {
        'type': 'Audio',
        'count': 28,
        'earnings': 1680.0,
        'color': AppTheme.getSuccessColor(context)
      },
      {
        'type': 'Video',
        'count': 15,
        'earnings': 1800.0,
        'color': theme.colorScheme.secondary
      },
      {
        'type': 'Report',
        'count': 12,
        'earnings': 900.0,
        'color': AppTheme.getWarningColor(context)
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consultation Breakdown',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 25.h,
                  child: Semantics(
                    label: "Consultation type breakdown pie chart",
                    child: PieChart(
                      PieChartData(
                        sections: consultationData.map((data) {
                          final earnings = data['earnings'] as double;
                          final total = consultationData.fold<double>(
                            0,
                            (sum, item) => sum + (item['earnings'] as double),
                          );
                          final percentage = (earnings / total * 100);

                          return PieChartSectionData(
                            color: data['color'] as Color,
                            value: earnings,
                            title: '${percentage.toStringAsFixed(1)}%',
                            radius: 60,
                            titleStyle: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }).toList(),
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 3,
                child: Column(
                  children: consultationData.map((data) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      child: Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: data['color'] as Color,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['type'] as String,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${data['count']} sessions • \$${(data['earnings'] as double).toStringAsFixed(0)}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics(BuildContext context) {
    final theme = Theme.of(context);

    final metrics = [
      {
        'title': 'Average Session Value',
        'value': '\$67.50',
        'change': '+5.2%',
        'isPositive': true
      },
      {
        'title': 'Conversion Rate',
        'value': '78.5%',
        'change': '+2.1%',
        'isPositive': true
      },
      {
        'title': 'Client Retention',
        'value': '85.3%',
        'change': '-1.2%',
        'isPositive': false
      },
      {
        'title': 'Response Time',
        'value': '2.3 min',
        'change': '-15.4%',
        'isPositive': true
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Metrics',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...metrics.map((metric) {
            final isPositive = metric['isPositive'] as bool;
            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.getAccentColor(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          metric['title'] as String,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          metric['value'] as String,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: isPositive
                          ? AppTheme.getSuccessColor(context)
                              .withValues(alpha: 0.1)
                          : theme.colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName:
                              isPositive ? 'trending_up' : 'trending_down',
                          color: isPositive
                              ? AppTheme.getSuccessColor(context)
                              : theme.colorScheme.error,
                          size: 12,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          metric['change'] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isPositive
                                ? AppTheme.getSuccessColor(context)
                                : theme.colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPayoutSummary(BuildContext context) {
    final theme = Theme.of(context);
    final commission = _walletData['commission'] as double;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payout Information',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildPayoutInfoItem(
                  context: context,
                  title: 'Platform Commission',
                  value: '${commission.toStringAsFixed(1)}%',
                  subtitle: 'Per transaction',
                ),
              ),
              Expanded(
                child: _buildPayoutInfoItem(
                  context: context,
                  title: 'Processing Time',
                  value: '2-3 days',
                  subtitle: 'Bank transfer',
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildPayoutInfoItem(
                  context: context,
                  title: 'Minimum Withdrawal',
                  value: '\$50.00',
                  subtitle: 'Required amount',
                ),
              ),
              Expanded(
                child: _buildPayoutInfoItem(
                  context: context,
                  title: 'Next Payout',
                  value: 'Nov 25',
                  subtitle: 'Scheduled date',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutInfoItem({
    required BuildContext context,
    required String title,
    required String value,
    required String subtitle,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.getAccentColor(context),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            subtitle,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTransactions(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'receipt_long',
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 64,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Transactions Yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Start accepting consultations to see your transaction history here.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, '/consultation-requests-screen'),
              child: const Text('View Consultation Requests'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _onBottomNavTap(int index) {
    // Handle bottom navigation
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilters: _currentFilters,
        onApplyFilters: (filters) {
          setState(() {
            _currentFilters = filters;
          });
        },
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Transaction Details',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: theme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                        'Transaction ID', transaction['id'] as String),
                    _buildDetailRow(
                        'Type', (transaction['type'] as String).toUpperCase()),
                    _buildDetailRow('Client',
                        transaction['clientName'] as String? ?? 'N/A'),
                    _buildDetailRow('Amount', transaction['amount'] as String),
                    if (transaction['duration'] != null)
                      _buildDetailRow(
                          'Duration', transaction['duration'] as String),
                    if (transaction['commission'] != null)
                      _buildDetailRow(
                          'Commission', transaction['commission'] as String),
                    _buildDetailRow('Status',
                        (transaction['status'] as String).toUpperCase()),
                    _buildDetailRow('Date',
                        _formatFullDate(transaction['timestamp'] as DateTime)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _initiateWithdrawal() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Withdraw Funds',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: theme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.getAccentColor(context),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Balance',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '\$${(_walletData['availableBalance'] as double).toStringAsFixed(2)}',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Withdrawal Amount',
                        prefixText: '\$',
                        helperText: 'Minimum withdrawal: \$50.00',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Payout Method',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              theme.colorScheme.outline.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'account_balance',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chase Bank',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '****7890',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Change'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.getWarningColor(context)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'info',
                            color: AppTheme.getWarningColor(context),
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Processing time: 2-3 business days',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.getWarningColor(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Withdrawal request submitted successfully'),
                      ),
                    );
                  },
                  child: const Text('Submit Withdrawal Request'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadStatement() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Statement download started'),
      ),
    );
  }

  void _viewTaxInfo() {
    Navigator.pushNamed(context, '/tax-information-screen');
  }

  void _addPayoutMethod() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add payout method feature coming soon'),
      ),
    );
  }

  void _editPayoutMethod(Map<String, dynamic> method) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit ${method['type']} method'),
      ),
    );
  }

  void _deletePayoutMethod(Map<String, dynamic> method) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payout Method'),
        content: Text(
            'Are you sure you want to delete this ${method['type']} payout method?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _payoutMethods.removeWhere((m) => m['id'] == method['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Payout method deleted successfully'),
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}