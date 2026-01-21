import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AvailabilitySectionWidget extends StatefulWidget {
    final Map<String, List<String>> weeklySchedule;
    final List<DateTime> holidays;
    final Function(Map<String, List<String>>) onScheduleChanged;
    final Function(List<DateTime>) onHolidaysChanged;
    final VoidCallback onSave;
    final bool isLoading;

    const AvailabilitySectionWidget({
        super.key,
        required this.weeklySchedule,
        required this.holidays,
        required this.onScheduleChanged,
        required this.onHolidaysChanged,
        required this.onSave,
        this.isLoading = false,
    });

    @override
    State<AvailabilitySectionWidget> createState() =>
        _AvailabilitySectionWidgetState();
}

class _AvailabilitySectionWidgetState extends State<AvailabilitySectionWidget>
    with TickerProviderStateMixin {
    late TabController _tabController;
    late Map<String, List<String>> _tempWeeklySchedule;
    late List<DateTime> _tempHolidays;

    final List<String> _daysOfWeek = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
    ];

    final List<String> _timeSlots = [
        '06:00',
        '07:00',
        '08:00',
        '09:00',
        '10:00',
        '11:00',
        '12:00',
        '13:00',
        '14:00',
        '15:00',
        '16:00',
        '17:00',
        '18:00',
        '19:00',
        '20:00',
        '21:00',
        '22:00',
        '23:00'
    ];

    DateTime _focusedDay = DateTime.now();
    DateTime? _selectedDay;

    @override
    void initState() {
        super.initState();
        _tabController = TabController(length: 2, vsync: this);
        _tempWeeklySchedule = Map.from(widget.weeklySchedule);
        _tempHolidays = List.from(widget.holidays);

        // Initialize empty schedules for days not present
        for (String day in _daysOfWeek) {
            _tempWeeklySchedule.putIfAbsent(day, () => []);
        }
    }

    @override
    void dispose() {
        _tabController.dispose();
        super.dispose();
    }

    Widget _buildScheduleTab() {
        return SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        'Set your weekly availability',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    ),
                    SizedBox(height: 2.h),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _daysOfWeek.length,
                        separatorBuilder: (context, index) => SizedBox(height: 2.h),
                        itemBuilder: (context, index) {
                            final day = _daysOfWeek[index];
                            final selectedSlots = _tempWeeklySchedule[day] ?? [];

                            return Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .outline
                                            .withValues(alpha: 0.3),
                                    ),
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Row(
                                            children: [
                                                Text(
                                                    day,
                                                    style:
                                                    Theme.of(context).textTheme.titleSmall?.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                    ),
                                                ),
                                                const Spacer(),
                                                Switch(
                                                    value: selectedSlots.isNotEmpty,
                                                    onChanged: (value) {
                                                        setState(() {
                                                            if (value) {
                                                                _tempWeeklySchedule[day] = [
                                                                    '09:00',
                                                                    '10:00',
                                                                    '11:00',
                                                                    '14:00',
                                                                    '15:00',
                                                                    '16:00'
                                                                ];
                                                            } else {
                                                                _tempWeeklySchedule[day] = [];
                                                            }
                                                        });
                                                        widget.onScheduleChanged(_tempWeeklySchedule);
                                                    },
                                                ),
                                            ],
                                        ),
                                        if (selectedSlots.isNotEmpty) ...[
                                            SizedBox(height: 2.h),
                                            Text(
                                                'Available time slots:',
                                                style:
                                                Theme.of(context).textTheme.labelMedium?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                ),
                                            ),
                                            SizedBox(height: 1.h),
                                            Wrap(
                                                spacing: 2.w,
                                                runSpacing: 1.h,
                                                children: _timeSlots.map((timeSlot) {
                                                    final isSelected = selectedSlots.contains(timeSlot);

                                                    return GestureDetector(
                                                        onTap: () {
                                                            setState(() {
                                                                if (isSelected) {
                                                                    _tempWeeklySchedule[day]?.remove(timeSlot);
                                                                } else {
                                                                    _tempWeeklySchedule[day]?.add(timeSlot);
                                                                }
                                                            });
                                                            widget.onScheduleChanged(_tempWeeklySchedule);
                                                        },
                                                        child: Container(
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal: 3.w, vertical: 1.h),
                                                            decoration: BoxDecoration(
                                                                color: isSelected
                                                                    ? Theme.of(context).colorScheme.primary
                                                                    : Theme.of(context).colorScheme.surface,
                                                                border: Border.all(
                                                                    color: isSelected
                                                                        ? Theme.of(context).colorScheme.primary
                                                                        : Theme.of(context).colorScheme.outline,
                                                                ),
                                                                borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            child: Text(
                                                                timeSlot,
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .labelSmall
                                                                    ?.copyWith(
                                                                    color: isSelected
                                                                        ? Theme.of(context)
                                                                        .colorScheme
                                                                        .onPrimary
                                                                        : Theme.of(context)
                                                                        .colorScheme
                                                                        .onSurface,
                                                                    fontWeight: isSelected
                                                                        ? FontWeight.w600
                                                                        : FontWeight.w400,
                                                                ),
                                                            ),
                                                        ),
                                                    );
                                                }).toList(),
                                            ),
                                        ],
                                    ],
                                ),
                            );
                        },
                    ),
                ],
            ),
        );
    }

    Widget _buildHolidaysTab() {
        return SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        'Mark your unavailable dates',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outline
                                    .withValues(alpha: 0.3),
                            ),
                        ),
                        child: TableCalendar<DateTime>(
                            firstDay: DateTime.now(),
                            lastDay: DateTime.now().add(const Duration(days: 365)),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) {
                                return _tempHolidays.any((holiday) => isSameDay(holiday, day));
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                                setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay = focusedDay;

                                    final existingIndex = _tempHolidays.indexWhere(
                                            (holiday) => isSameDay(holiday, selectedDay),
                                    );

                                    if (existingIndex >= 0) {
                                        _tempHolidays.removeAt(existingIndex);
                                    } else {
                                        _tempHolidays.add(selectedDay);
                                    }
                                });
                                widget.onHolidaysChanged(_tempHolidays);
                            },
                            calendarStyle: CalendarStyle(
                                outsideDaysVisible: false,
                                selectedDecoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.error,
                                    shape: BoxShape.circle,
                                ),
                                todayDecoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withValues(alpha: 0.5),
                                    shape: BoxShape.circle,
                                ),
                                markerDecoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.error,
                                    shape: BoxShape.circle,
                                ),
                            ),
                            headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextStyle: Theme.of(context).textTheme.titleMedium!,
                                leftChevronIcon: CustomIconWidget(
                                    iconName: 'chevron_left',
                                    size: 6.w,
                                    color: Theme.of(context).colorScheme.onSurface,
                                ),
                                rightChevronIcon: CustomIconWidget(
                                    iconName: 'chevron_right',
                                    size: 6.w,
                                    color: Theme.of(context).colorScheme.onSurface,
                                ),
                            ),
                            eventLoader: (day) {
                                return _tempHolidays
                                    .where((holiday) => isSameDay(holiday, day))
                                    .toList();
                            },
                        ),
                    ),
                    SizedBox(height: 2.h),
                    if (_tempHolidays.isNotEmpty) ...[
                        Text(
                            'Marked unavailable dates:',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                            ),
                        ),
                        SizedBox(height: 1.h),
                        Wrap(
                            spacing: 2.w,
                            runSpacing: 1.h,
                            children: _tempHolidays.map((holiday) {
                                return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error
                                            .withValues(alpha: 0.1),
                                        border: Border.all(
                                            color: Theme.of(context).colorScheme.error,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                            Text(
                                                '${holiday.day}/${holiday.month}/${holiday.year}',
                                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                    color: Theme.of(context).colorScheme.error,
                                                    fontWeight: FontWeight.w500,
                                                ),
                                            ),
                                            SizedBox(width: 1.w),
                                            GestureDetector(
                                                onTap: () {
                                                    setState(() {
                                                        _tempHolidays.remove(holiday);
                                                    });
                                                    widget.onHolidaysChanged(_tempHolidays);
                                                },
                                                child: CustomIconWidget(
                                                    iconName: 'close',
                                                    size: 3.w,
                                                    color: Theme.of(context).colorScheme.error,
                                                ),
                                            ),
                                        ],
                                    ),
                                );
                            }).toList(),
                        ),
                    ],
                ],
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                    BoxShadow(
                        color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                    ),
                ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Row(
                            children: [
                                CustomIconWidget(
                                    iconName: 'schedule',
                                    size: 6.w,
                                    color: Theme.of(context).colorScheme.primary,
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                    'Availability Preferences',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                    ),
                                ),
                            ],
                        ),
                    ),
                    TabBar(
                        controller: _tabController,
                        tabs: const [
                            Tab(text: 'Weekly Schedule'),
                            Tab(text: 'Holidays'),
                        ],
                    ),
                    SizedBox(
                        height: 50.h,
                        child: TabBarView(
                            controller: _tabController,
                            children: [
                                _buildScheduleTab(),
                                _buildHolidaysTab(),
                            ],
                        ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Row(
                            children: [
                                Expanded(
                                    child: Text(
                                        'Total available slots: ${_tempWeeklySchedule.values.fold<int>(0, (sum, slots) => sum + slots.length)} per week',
                                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                    ),
                                ),
                                SizedBox(width: 3.w),
                                ElevatedButton(
                                    onPressed: widget.isLoading ? null : widget.onSave,
                                    style: ElevatedButton.styleFrom(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                        ),
                                    ),
                                    child: widget.isLoading
                                        ? SizedBox(
                                        width: 4.w,
                                        height: 4.w,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                                Theme.of(context).colorScheme.onPrimary,
                                            ),
                                        ),
                                    )
                                        : Text(
                                        'Save',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                            color: Theme.of(context).colorScheme.onPrimary,
                                            fontWeight: FontWeight.w600,
                                        ),
                                    ),
                                ),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }
}
