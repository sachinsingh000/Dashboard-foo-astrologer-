import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionItem extends StatelessWidget {
    final Map<String, dynamic> transaction;
    final VoidCallback onTap;

    const TransactionItem({
        super.key,
        required this.transaction,
        required this.onTap,
    });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final type = transaction['type'] as String;
        final amount = transaction['amount'] as String;
        final isCredit = (transaction['isCredit'] as bool?) ?? true;
        final clientName = transaction['clientName'] as String? ?? 'Unknown';
        final timestamp = transaction['timestamp'] as DateTime;
        final status = transaction['status'] as String? ?? 'completed';

        return Slidable(
            key: ValueKey(transaction['id']),
            endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                    SlidableAction(
                        onPressed: (_) => onTap(),
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        icon: Icons.info_outline,
                        label: 'Details',
                        borderRadius: BorderRadius.circular(12),
                    ),
                ],
            ),
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.1),
                        width: 1,
                    ),
                ),
                child: Row(
                    children: [
                        Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: BoxDecoration(
                                color: _getTypeColor(type, theme).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                                child: CustomIconWidget(
                                    iconName: _getTypeIcon(type),
                                    color: _getTypeColor(type, theme),
                                    size: 20,
                                ),
                            ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Expanded(
                                                child: Text(
                                                    _getTransactionTitle(type, clientName),
                                                    style: theme.textTheme.titleSmall?.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                ),
                                            ),
                                            Text(
                                                '${isCredit ? '+' : '-'}$amount',
                                                style: theme.textTheme.titleSmall?.copyWith(
                                                    color: isCredit
                                                        ? AppTheme.getSuccessColor(context)
                                                        : theme.colorScheme.error,
                                                    fontWeight: FontWeight.w700,
                                                ),
                                            ),
                                        ],
                                    ),
                                    SizedBox(height: 0.5.h),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                            Expanded(
                                                child: Text(
                                                    _formatTimestamp(timestamp),
                                                    style: theme.textTheme.bodySmall?.copyWith(
                                                        color: theme.colorScheme.onSurfaceVariant,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                ),
                                            ),
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 2.w, vertical: 0.5.h),
                                                decoration: BoxDecoration(
                                                    color: _getStatusColor(status, theme)
                                                        .withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                    status.toUpperCase(),
                                                    style: theme.textTheme.labelSmall?.copyWith(
                                                        color: _getStatusColor(status, theme),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 9.sp,
                                                    ),
                                                ),
                                            ),
                                        ],
                                    ),
                                ],
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    Color _getTypeColor(String type, ThemeData theme) {
        switch (type.toLowerCase()) {
            case 'chat':
                return theme.colorScheme.primary;
            case 'audio':
                return Colors.green; // AppTheme.getSuccessColor(context);
            case 'video':
                return theme.colorScheme.secondary;
            case 'report':
                return Colors.orange; // AppTheme.getWarningColor(context);
            case 'withdrawal':
                return theme.colorScheme.error;
            case 'refund':
                return theme.colorScheme.tertiary;
            case 'bonus':
                return theme.colorScheme.primary;
            default:
                return theme.colorScheme.onSurfaceVariant;
        }
    }

    String _getTypeIcon(String type) {
        switch (type.toLowerCase()) {
            case 'chat':
                return 'chat';
            case 'audio':
                return 'phone';
            case 'video':
                return 'videocam';
            case 'report':
                return 'description';
            case 'withdrawal':
                return 'account_balance_wallet';
            case 'refund':
                return 'refresh';
            case 'bonus':
                return 'card_giftcard';
            default:
                return 'attach_money';
        }
    }

    Color _getStatusColor(String status, ThemeData theme) {
        switch (status.toLowerCase()) {
            case 'completed':
                return Colors.green; // AppTheme.getSuccessColor(context);
            case 'pending':
                return Colors.orange; // AppTheme.getWarningColor(context);
            case 'failed':
                return theme.colorScheme.error;
            case 'processing':
                return theme.colorScheme.primary;
            default:
                return theme.colorScheme.onSurfaceVariant;
        }
    }

    String _getTransactionTitle(String type, String clientName) {
        switch (type.toLowerCase()) {
            case 'chat':
                return 'Chat with $clientName';
            case 'audio':
                return 'Audio call with $clientName';
            case 'video':
                return 'Video call with $clientName';
            case 'report':
                return 'Report for $clientName';
            case 'withdrawal':
                return 'Withdrawal to Bank';
            case 'refund':
                return 'Refund to $clientName';
            case 'bonus':
                return 'Platform Bonus';
            default:
                return 'Transaction';
        }
    }

    String _formatTimestamp(DateTime timestamp) {
        final now = DateTime.now();
        final difference = now.difference(timestamp);

        if (difference.inDays > 0) {
            return '${difference.inDays}d ago';
        } else if (difference.inHours > 0) {
            return '${difference.inHours}h ago';
        } else if (difference.inMinutes > 0) {
            return '${difference.inMinutes}m ago';
        } else {
            return 'Just now';
        }
    }
}
