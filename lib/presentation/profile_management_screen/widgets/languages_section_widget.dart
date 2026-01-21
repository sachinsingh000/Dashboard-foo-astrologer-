import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LanguagesSectionWidget extends StatefulWidget {
  final List<String> selectedLanguages;
  final Function(List<String>) onLanguagesChanged;
  final VoidCallback onSave;
  final bool isLoading;

  const LanguagesSectionWidget({
    super.key,
    required this.selectedLanguages,
    required this.onLanguagesChanged,
    required this.onSave,
    this.isLoading = false,
  });

  @override
  State<LanguagesSectionWidget> createState() => _LanguagesSectionWidgetState();
}

class _LanguagesSectionWidgetState extends State<LanguagesSectionWidget> {
  final List<String> _availableLanguages = [
    'English',
    'Hindi',
    'Bengali',
    'Telugu',
    'Marathi',
    'Tamil',
    'Gujarati',
    'Urdu',
    'Kannada',
    'Odia',
    'Malayalam',
    'Punjabi',
    'Assamese',
    'Maithili',
    'Sanskrit',
    'Spanish',
    'French',
    'German',
    'Italian',
    'Portuguese',
    'Russian',
    'Chinese',
    'Japanese',
    'Korean',
    'Arabic',
  ];

  late List<String> _tempSelectedLanguages;

  @override
  void initState() {
    super.initState();
    _tempSelectedLanguages = List.from(widget.selectedLanguages);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
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
          Row(
            children: [
              CustomIconWidget(
                iconName: 'language',
                size: 6.w,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: 3.w),
              Text(
                'Languages Spoken',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Select languages you can conduct consultations in',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          SizedBox(height: 2.h),
          DropdownSearch<String>.multiSelection(
            items: (filter, infiniteScrollProps) async => _availableLanguages,
            selectedItems: _tempSelectedLanguages,
            onChanged: (List<String> selectedItems) {
              setState(() {
                _tempSelectedLanguages = selectedItems;
              });
              widget.onLanguagesChanged(_tempSelectedLanguages);
            },
            popupProps: PopupPropsMultiSelection.menu(
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                decoration: InputDecoration(
                  hintText: 'Search languages...',
                  prefixIcon: CustomIconWidget(
                    iconName: 'search',
                    size: 5.w,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              itemBuilder: (context, item, isSelected, isDisabled) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: isSelected
                            ? 'check_box'
                            : 'check_box_outline_blank',
                        size: 5.w,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          item,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              containerBuilder: (context, popupWidget) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .shadowColor
                            .withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: popupWidget,
                );
              },
            ),
            decoratorProps: DropDownDecoratorProps(
              decoration: InputDecoration(
                hintText: 'Select languages...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                suffixIcon: CustomIconWidget(
                  iconName: 'arrow_drop_down',
                  size: 6.w,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            dropdownBuilder: (context, selectedItems) {
              if (selectedItems.isEmpty) {
                return Text(
                  'Select languages...',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                );
              }

              return Wrap(
                spacing: 1.w,
                runSpacing: 0.5.h,
                children: selectedItems.map((language) {
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          language,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        SizedBox(width: 1.w),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _tempSelectedLanguages.remove(language);
                            });
                            widget.onLanguagesChanged(_tempSelectedLanguages);
                          },
                          child: CustomIconWidget(
                            iconName: 'close',
                            size: 3.w,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_tempSelectedLanguages.length} language${_tempSelectedLanguages.length != 1 ? 's' : ''} selected',
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
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
