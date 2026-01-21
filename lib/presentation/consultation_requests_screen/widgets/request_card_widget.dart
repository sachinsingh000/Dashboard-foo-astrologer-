import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RequestCardWidget extends StatelessWidget {
	final Map<String, dynamic> request;
	final VoidCallback onAccept;
	final VoidCallback onDecline;
	final VoidCallback onTap;

	const RequestCardWidget({
		super.key,
		required this.request,
		required this.onAccept,
		required this.onDecline,
		required this.onTap,
	});

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		final consultationType = request['consultationType'] as String;
		final isUrgent = _isUrgent(request['timestamp'] as DateTime);
		final timeRemaining = _getTimeRemaining(request['timestamp'] as DateTime);

		return Container(
			margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
			decoration: BoxDecoration(
				color: theme.colorScheme.surface,
				borderRadius: BorderRadius.circular(16),
				border: isUrgent
						? Border.all(color: theme.colorScheme.error, width: 2)
						: Border.all(
						color: theme.colorScheme.outline.withValues(alpha: 0.2)),
				boxShadow: [
					BoxShadow(
						color: theme.shadowColor.withValues(alpha: 0.1),
						blurRadius: 8,
						offset: const Offset(0, 2),
					),
				],
			),
			child: Material(
				color: Colors.transparent,
				child: InkWell(
					onTap: onTap,
					borderRadius: BorderRadius.circular(16),
					child: Padding(
						padding: EdgeInsets.all(4.w),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								_buildHeader(context, theme, consultationType, isUrgent),
								SizedBox(height: 2.h),
								_buildClientInfo(context, theme),
								SizedBox(height: 2.h),
								_buildRequestDetails(context, theme),
								SizedBox(height: 2.h),
								_buildTimeAndRate(context, theme, timeRemaining),
								SizedBox(height: 3.h),
								_buildActionButtons(context, theme),
							],
						),
					),
				),
			),
		);
	}

	Widget _buildHeader(BuildContext context, ThemeData theme,
			String consultationType, bool isUrgent) {
		return Row(
			children: [
				Container(
					padding: EdgeInsets.all(2.w),
					decoration: BoxDecoration(
						color: _getConsultationTypeColor(consultationType)
								.withValues(alpha: 0.1),
						borderRadius: BorderRadius.circular(12),
					),
					child: CustomIconWidget(
						iconName: _getConsultationTypeIcon(consultationType),
						color: _getConsultationTypeColor(consultationType),
						size: 20,
					),
				),
				SizedBox(width: 3.w),
				Expanded(
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text(
								'${consultationType.toUpperCase()} Consultation',
								style: theme.textTheme.titleMedium?.copyWith(
									fontWeight: FontWeight.w600,
								),
							),
							Text(
								'${request['duration']} minutes',
								style: theme.textTheme.bodySmall?.copyWith(
									color: theme.colorScheme.onSurfaceVariant,
								),
							),
						],
					),
				),
				if (isUrgent)
					Container(
						padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
						decoration: BoxDecoration(
							color: theme.colorScheme.error,
							borderRadius: BorderRadius.circular(8),
						),
						child: Text(
							'URGENT',
							style: theme.textTheme.labelSmall?.copyWith(
								color: theme.colorScheme.onError,
								fontWeight: FontWeight.w600,
							),
						),
					),
			],
		);
	}

	Widget _buildClientInfo(BuildContext context, ThemeData theme) {
		return Row(
			children: [
				Container(
					width: 12.w,
					height: 12.w,
					decoration: BoxDecoration(
						shape: BoxShape.circle,
						border: Border.all(
							color: theme.colorScheme.outline.withValues(alpha: 0.3),
						),
					),
					child: ClipOval(
						child: CustomImageWidget(
							imageUrl: request['clientAvatar'] as String,
							width: 12.w,
							height: 12.w,
							fit: BoxFit.cover,
							semanticLabel: request['clientAvatarSemanticLabel'] as String,
						),
					),
				),
				SizedBox(width: 3.w),
				Expanded(
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Text(
								request['clientName'] as String,
								style: theme.textTheme.titleSmall?.copyWith(
									fontWeight: FontWeight.w600,
								),
							),
							if (request['clientLocation'] != null)
								Text(
									request['clientLocation'] as String,
									style: theme.textTheme.bodySmall?.copyWith(
										color: theme.colorScheme.onSurfaceVariant,
									),
								),
						],
					),
				),
				if (request['isReturningClient'] == true)
					Container(
						padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
						decoration: BoxDecoration(
							color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
							borderRadius: BorderRadius.circular(8),
						),
						child: Text(
							'Returning',
							style: theme.textTheme.labelSmall?.copyWith(
								color: theme.colorScheme.tertiary,
								fontWeight: FontWeight.w500,
							),
						),
					),
			],
		);
	}

	Widget _buildRequestDetails(BuildContext context, ThemeData theme) {
		final question = request['question'] as String;
		final previewText =
		question.length > 100 ? '${question.substring(0, 100)}...' : question;

		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				Text(
					'Question:',
					style: theme.textTheme.labelMedium?.copyWith(
						fontWeight: FontWeight.w600,
						color: theme.colorScheme.primary,
					),
				),
				SizedBox(height: 1.h),
				Text(
					previewText,
					style: theme.textTheme.bodyMedium,
					maxLines: 3,
					overflow: TextOverflow.ellipsis,
				),
				if (request['specialRequirements'] != null) ...[
					SizedBox(height: 1.h),
					Container(
						padding: EdgeInsets.all(2.w),
						decoration: BoxDecoration(
							color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
							borderRadius: BorderRadius.circular(8),
						),
						child: Row(
							children: [
								CustomIconWidget(
									iconName: 'info',
									color: theme.colorScheme.primary,
									size: 16,
								),
								SizedBox(width: 2.w),
								Expanded(
									child: Text(
										request['specialRequirements'] as String,
										style: theme.textTheme.bodySmall?.copyWith(
											color: theme.colorScheme.primary,
										),
									),
								),
							],
						),
					),
				],
			],
		);
	}

	Widget _buildTimeAndRate(
			BuildContext context, ThemeData theme, String timeRemaining) {
		return Row(
			children: [
				Expanded(
					child: Container(
						padding: EdgeInsets.all(3.w),
						decoration: BoxDecoration(
							color:
							theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
							borderRadius: BorderRadius.circular(12),
						),
						child: Column(
							children: [
								CustomIconWidget(
									iconName: 'schedule',
									color: theme.colorScheme.secondary,
									size: 20,
								),
								SizedBox(height: 1.h),
								Text(
									timeRemaining,
									style: theme.textTheme.labelMedium?.copyWith(
										fontWeight: FontWeight.w600,
										color: theme.colorScheme.secondary,
									),
								),
								Text(
									'remaining',
									style: theme.textTheme.labelSmall?.copyWith(
										color: theme.colorScheme.onSurfaceVariant,
									),
								),
							],
						),
					),
				),
				SizedBox(width: 3.w),
				Expanded(
					child: Container(
						padding: EdgeInsets.all(3.w),
						decoration: BoxDecoration(
							color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
							borderRadius: BorderRadius.circular(12),
						),
						child: Column(
							children: [
								CustomIconWidget(
									iconName: 'attach_money',
									color: theme.colorScheme.tertiary,
									size: 20,
								),
								SizedBox(height: 1.h),
								Text(
									request['offeredRate'] as String,
									style: theme.textTheme.labelMedium?.copyWith(
										fontWeight: FontWeight.w600,
										color: theme.colorScheme.tertiary,
									),
								),
								Text(
									'per minute',
									style: theme.textTheme.labelSmall?.copyWith(
										color: theme.colorScheme.onSurfaceVariant,
									),
								),
							],
						),
					),
				),
			],
		);
	}

	Widget _buildActionButtons(BuildContext context, ThemeData theme) {
		return Row(
			children: [
				Expanded(
					child: OutlinedButton(
						onPressed: () {
							HapticFeedback.lightImpact();
							onDecline();
						},
						style: OutlinedButton.styleFrom(
							foregroundColor: theme.colorScheme.error,
							side: BorderSide(color: theme.colorScheme.error),
							padding: EdgeInsets.symmetric(vertical: 2.h),
							shape: RoundedRectangleBorder(
								borderRadius: BorderRadius.circular(12),
							),
						),
						child: Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								CustomIconWidget(
									iconName: 'close',
									color: theme.colorScheme.error,
									size: 18,
								),
								SizedBox(width: 2.w),
								Text(
									'Decline',
									style: theme.textTheme.titleSmall?.copyWith(
										color: theme.colorScheme.error,
										fontWeight: FontWeight.w600,
									),
								),
							],
						),
					),
				),
				SizedBox(width: 3.w),
				Expanded(
					child: ElevatedButton(
						onPressed: () {
							HapticFeedback.mediumImpact();
							onAccept();
						},
						style: ElevatedButton.styleFrom(
							backgroundColor: theme.colorScheme.tertiary,
							foregroundColor: theme.colorScheme.onTertiary,
							padding: EdgeInsets.symmetric(vertical: 2.h),
							shape: RoundedRectangleBorder(
								borderRadius: BorderRadius.circular(12),
							),
						),
						child: Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children: [
								CustomIconWidget(
									iconName: 'check',
									color: theme.colorScheme.onTertiary,
									size: 18,
								),
								SizedBox(width: 2.w),
								Text(
									'Accept',
									style: theme.textTheme.titleSmall?.copyWith(
										color: theme.colorScheme.onTertiary,
										fontWeight: FontWeight.w600,
									),
								),
							],
						),
					),
				),
			],
		);
	}

	String _getConsultationTypeIcon(String type) {
		switch (type.toLowerCase()) {
			case 'chat':
				return 'chat';
			case 'audio':
				return 'call';
			case 'video':
				return 'videocam';
			case 'report':
				return 'description';
			default:
				return 'help';
		}
	}

	Color _getConsultationTypeColor(String type) {
		switch (type.toLowerCase()) {
			case 'chat':
				return const Color(0xFF4CAF50);
			case 'audio':
				return const Color(0xFF2196F3);
			case 'video':
				return const Color(0xFF9C27B0);
			case 'report':
				return const Color(0xFFFF9800);
			default:
				return const Color(0xFF757575);
		}
	}

	bool _isUrgent(DateTime timestamp) {
		final now = DateTime.now();
		final difference = now.difference(timestamp);
		return difference.inMinutes >= 7; // Urgent if more than 7 minutes old
	}

	String _getTimeRemaining(DateTime timestamp) {
		final now = DateTime.now();
		final difference = now.difference(timestamp);
		final remainingMinutes = 10 - difference.inMinutes;

		if (remainingMinutes <= 0) {
			return 'Expired';
		} else if (remainingMinutes == 1) {
			return '1 min';
		} else {
			return '${remainingMinutes} mins';
		}
	}
}
