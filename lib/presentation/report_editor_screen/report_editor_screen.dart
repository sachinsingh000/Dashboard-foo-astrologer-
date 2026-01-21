import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/client_info_header_widget.dart';
import './widgets/draft_list_widget.dart';
import './widgets/formatting_toolbar_widget.dart';
import './widgets/report_stats_widget.dart';
import './widgets/report_template_widget.dart';

class ReportEditorScreen extends StatefulWidget {
  const ReportEditorScreen({super.key});

  @override
  State<ReportEditorScreen> createState() => _ReportEditorScreenState();
}

class _ReportEditorScreenState extends State<ReportEditorScreen>
    with TickerProviderStateMixin {
  late QuillController _quillController;
  late TabController _tabController;
  late Timer _autoSaveTimer;

  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool _isAutoSaving = false;
  DateTime? _lastSaved;
  int _wordCount = 0;
  int _estimatedReadingTime = 0;
  String _selectedReportType = 'Birth Chart Analysis';
  String _selectedTemplate = '';
  bool _isPreviewMode = false;

  // Mock client data
  final Map<String, dynamic> _currentClient = {
    'name': 'Sarah Johnson',
    'consultationType': 'Birth Chart Reading',
    'sessionDate': 'November 18, 2025',
    'sessionDuration': '45 minutes',
    'avatar':
    'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
  };

  // Mock templates data
  final List<Map<String, dynamic>> _templates = [
    {
      'name': 'Comprehensive Birth Chart',
      'description':
      'Complete natal chart analysis with planetary positions, houses, and aspects',
      'category': 'Birth Chart',
      'content':
      '''# Birth Chart Analysis for {CLIENT_NAME} ## Chart Overview Date of Birth: {DOB} Time of Birth: {TOB} Place of Birth: {POB} ## Sun Sign Analysis Your Sun is in {SUN_SIGN}, which represents your core identity and life purpose... ## Moon Sign Analysis Your Moon is in {MOON_SIGN}, revealing your emotional nature and inner self... ## Rising Sign Analysis Your Ascendant is in {RISING_SIGN}, showing how others perceive you... ## Planetary Positions ### Mercury - Communication & Mind ### Venus - Love & Relationships ### Mars - Action & Energy ### Jupiter - Growth & Expansion ### Saturn - Discipline & Lessons ## House Analysis ### 1st House - Self & Identity ### 2nd House - Values & Resources ### 3rd House - Communication & Siblings ## Major Aspects ### Conjunctions ### Trines ### Squares ### Oppositions ## Life Themes & Guidance Based on your chart, key themes in your life include... ## Recommendations 1. Focus areas for personal growth 2. Relationship compatibility insights 3. Career guidance based on planetary positions ''',
    },
    {
      'name': 'Celtic Cross Tarot Reading',
      'description': 'Traditional 10-card spread with detailed interpretations',
      'category': 'Tarot Reading',
      'content':
      '''# Celtic Cross Tarot Reading for {CLIENT_NAME} ## Reading Overview Date: {DATE} Question: {QUESTION} ## Card Positions & Meanings ### 1. Present Situation Card: {CARD_1} Meaning: This card represents your current circumstances... ### 2. Challenge/Cross Card: {CARD_2} Meaning: This shows what challenges or supports your situation... ### 3. Distant Past/Foundation Card: {CARD_3} Meaning: The foundation or root cause of your situation... ### 4. Recent Past Card: {CARD_4} Meaning: Recent events that have led to this moment... ### 5. Possible Outcome Card: {CARD_5} Meaning: One potential outcome if things continue as they are... ### 6. Immediate Future Card: {CARD_6} Meaning: What's likely to happen in the near future... ### 7. Your Approach Card: {CARD_7} Meaning: Your current approach or attitude... ### 8. External Influences Card: {CARD_8} Meaning: How others or external factors affect your situation... ### 9. Hopes & Fears Card: {CARD_9} Meaning: Your inner hopes and fears about this situation... ### 10. Final Outcome Card: {CARD_10} Meaning: The most likely final outcome... ## Overall Reading Summary The cards reveal a story about your journey... ## Guidance & Advice Based on this reading, I recommend... ''',
    },
    {
      'name': 'Numerology Life Path Report',
      'description':
      'Complete numerological analysis including life path, destiny, and soul numbers',
      'category': 'Numerology',
      'content':
      '''# Numerology Report for {CLIENT_NAME} ## Your Core Numbers Date of Birth: {DOB} Full Name: {FULL_NAME} ## Life Path Number: {LIFE_PATH} Your Life Path Number reveals your life's purpose and the lessons you're here to learn... ## Destiny Number: {DESTINY} Your Destiny Number shows your life's mission and what you're meant to achieve... ## Soul Urge Number: {SOUL_URGE} Your Soul Urge Number reveals your heart's deepest desires... ## Personality Number: {PERSONALITY} Your Personality Number shows how others perceive you... ## Birth Day Number: {BIRTH_DAY} Your Birth Day Number reveals special talents and abilities... ## Personal Year Number: {PERSONAL_YEAR} For this year, your Personal Year Number indicates... ## Compatibility Analysis Based on your numbers, you're most compatible with... ## Career Guidance Your numbers suggest careers in... ## Relationship Insights In relationships, you tend to... ## Life Challenges & Lessons Your numbers indicate these key life lessons... ## Lucky Numbers & Colors Your most favorable numbers: {LUCKY_NUMBERS} Your power colors: {LUCKY_COLORS} ''',
    },
    {
      'name': 'Palm Reading Analysis',
      'description':
      'Detailed palmistry reading covering major and minor lines',
      'category': 'Palmistry',
      'content':
      '''# Palm Reading for {CLIENT_NAME} ## Hand Analysis Overview Dominant Hand: {DOMINANT_HAND} Hand Shape: {HAND_SHAPE} Reading Date: {DATE} ## Major Lines Analysis ### Life Line Length: {LIFE_LINE_LENGTH} Depth: {LIFE_LINE_DEPTH} Interpretation: Your life line indicates... ### Heart Line Position: {HEART_LINE_POSITION} Curve: {HEART_LINE_CURVE} Interpretation: Your heart line reveals... ### Head Line Length: {HEAD_LINE_LENGTH} Slope: {HEAD_LINE_SLOPE} Interpretation: Your head line shows... ### Fate Line Presence: {FATE_LINE_PRESENCE} Direction: {FATE_LINE_DIRECTION} Interpretation: Your fate line indicates... ## Minor Lines ### Sun Line (Apollo Line) Your sun line suggests... ### Mercury Line (Health Line) Your mercury line indicates... ### Marriage Lines Number of lines: {MARRIAGE_LINES} Interpretation: These lines suggest... ## Mounts Analysis ### Mount of Venus Development: {VENUS_MOUNT} Meaning: This indicates... ### Mount of Jupiter Development: {JUPITER_MOUNT} Meaning: This shows... ### Mount of Saturn Development: {SATURN_MOUNT} Meaning: This reveals... ## Finger Analysis ### Thumb Shape and flexibility indicate... ### Index Finger (Jupiter) Length and shape suggest... ### Middle Finger (Saturn) Characteristics show... ### Ring Finger (Apollo) Features indicate... ### Little Finger (Mercury) Attributes reveal... ## Overall Palm Reading Summary Your palms tell a story of... ## Life Guidance Based on your palm reading, I recommend... ''',
    },
  ];

  // Mock drafts data
  List<Map<String, dynamic>> _drafts = [
    {
      'id': '1',
      'clientName': 'Emma Wilson',
      'reportType': 'Birth Chart Analysis',
      'lastModified': DateTime.now().subtract(const Duration(hours: 2)),
      'wordCount': 1250,
      'progress': 0.75,
      'content': 'Draft content for Emma Wilson...',
    },
    {
      'id': '2',
      'clientName': 'Michael Chen',
      'reportType': 'Tarot Reading',
      'lastModified': DateTime.now().subtract(const Duration(days: 1)),
      'wordCount': 890,
      'progress': 0.45,
      'content': 'Draft content for Michael Chen...',
    },
    {
      'id': '3',
      'clientName': 'Lisa Rodriguez',
      'reportType': 'Numerology Analysis',
      'lastModified': DateTime.now().subtract(const Duration(days: 2)),
      'wordCount': 1580,
      'progress': 0.90,
      'content': 'Draft content for Lisa Rodriguez...',
    },
  ];

  @override
  void initState() {
    super.initState();
    _quillController = QuillController.basic();
    _tabController = TabController(length: 3, vsync: this);

    // Initialize with welcome content
    _initializeEditor();

    // Setup auto-save timer
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _autoSave();
    });

    // Listen to text changes for word count
    _quillController.addListener(_updateWordCount);
  }

  @override
  void dispose() {
    _quillController.dispose();
    _tabController.dispose();
    _editorFocusNode.dispose();
    _scrollController.dispose();
    _autoSaveTimer.cancel();
    super.dispose();
  }

  void _initializeEditor() {
    final welcomeText = '''Welcome to Report Editor

Start creating your consultation report for ${_currentClient['name']}.

You can:
• Use the formatting toolbar above
• Insert images and charts
• Choose from pre-built templates
• Auto-save keeps your work safe

Begin typing your analysis below...
''';

    final document = Document()..insert(0, welcomeText);
    _quillController = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
    );
    _quillController.addListener(_updateWordCount);
    _updateWordCount();
  }

  void _updateWordCount() {
    final text = _quillController.document.toPlainText();
    final words = text.trim().split(RegExp(r'\s+'));
    final count = text.trim().isEmpty ? 0 : words.length;
    final readingTime =
    (count / 200).ceil(); // Average reading speed: 200 words/minute

    if (mounted) {
      setState(() {
        _wordCount = count;
        _estimatedReadingTime = readingTime;
      });
    }
  }

  Future<void> _autoSave() async {
    if (_quillController.document.toPlainText().trim().isEmpty) return;

    setState(() {
      _isAutoSaving = true;
    });

    // Simulate auto-save delay
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isAutoSaving = false;
        _lastSaved = DateTime.now();
      });
    }
  }

  void _insertTemplate(String templateContent) {
    // Replace placeholders with actual client data
    String content = templateContent
        .replaceAll('{CLIENT_NAME}', _currentClient['name'])
        .replaceAll('{DATE}', _currentClient['sessionDate'])
        .replaceAll('{DOB}', 'March 15, 1990')
        .replaceAll('{TOB}', '2:30 PM')
        .replaceAll('{POB}', 'New York, NY');

    final document = Document()..insert(0, content);
    _quillController.document = document;
    _quillController.updateSelection(
        const TextSelection.collapsed(offset: 0), ChangeSource.local);

    Navigator.pop(context);
    setState(() {});
  }

  Future<void> _insertImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // In a real app, you would upload the image and get a URL
        // For now, we'll show a placeholder
        final index = _quillController.selection.baseOffset;
        _quillController.document.insert(index, '\n[Image: ${image.name}]\n');
        _quillController.updateSelection(
          TextSelection.collapsed(offset: index + image.name.length + 4),
          ChangeSource.local,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to insert image: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _togglePreviewMode() {
    setState(() {
      _isPreviewMode = !_isPreviewMode;
    });
  }

  Future<void> _saveAndSend() async {
    if (_quillController.document.toPlainText().trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add content to your report before sending'),
        ),
      );
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Report'),
        content: Text(
          'Send this report to ${_currentClient['name']}? They will be notified immediately.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Send Report'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Simulate sending
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
          Text('Report sent to ${_currentClient['name']} successfully!'),
          backgroundColor: AppTheme.getSuccessColor(context),
        ),
      );

      // Navigate back to dashboard
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard-screen',
            (route) => false,
      );
    }
  }

  void _showTemplateLibrary() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Report Templates',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                itemCount: _templates.length,
                itemBuilder: (context, index) {
                  final template = _templates[index];
                  return ReportTemplateWidget(
                    templateName: template['name'],
                    description: template['description'],
                    category: template['category'],
                    isSelected: _selectedTemplate == template['name'],
                    onSelect: () {
                      setState(() {
                        _selectedTemplate = template['name'];
                      });
                      _insertTemplate(template['content']);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDraftSelected(Map<String, dynamic> draft) {
    final document = Document()..insert(0, draft['content']);
    _quillController.document = document;
    _quillController.updateSelection(
        const TextSelection.collapsed(offset: 0), ChangeSource.local);

    setState(() {
      _selectedReportType = draft['reportType'];
    });
  }

  void _onDraftDeleted(Map<String, dynamic> draft) {
    setState(() {
      _drafts.removeWhere((d) => d['id'] == draft['id']);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft deleted successfully'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(_isPreviewMode ? 'Report Preview' : 'Report Editor'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          if (!_isPreviewMode) ...[
            IconButton(
              onPressed: _showTemplateLibrary,
              icon: CustomIconWidget(
                iconName: 'library_books',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: _togglePreviewMode,
              icon: CustomIconWidget(
                iconName: 'preview',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ] else ...[
            IconButton(
              onPressed: _togglePreviewMode,
              icon: CustomIconWidget(
                iconName: 'edit',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ],
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'export_pdf':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('PDF export feature coming soon')),
                  );
                  break;
                case 'schedule_delivery':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Schedule delivery feature coming soon')),
                  );
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export_pdf',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf),
                    SizedBox(width: 8),
                    Text('Export as PDF'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'schedule_delivery',
                child: Row(
                  children: [
                    Icon(Icons.schedule_send),
                    SizedBox(width: 8),
                    Text('Schedule Delivery'),
                  ],
                ),
              ),
            ],
            child: CustomIconWidget(
              iconName: 'more_vert',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Editor'),
            Tab(text: 'Drafts'),
            Tab(text: 'Templates'),
          ],
        ),
      ),
      body: Column(
        children: [
          ClientInfoHeaderWidget(
            clientName: _currentClient['name'],
            consultationType: _currentClient['consultationType'],
            sessionDate: _currentClient['sessionDate'],
            sessionDuration: _currentClient['sessionDuration'],
            clientAvatar: _currentClient['avatar'],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEditorTab(),
                _buildDraftsTab(),
                _buildTemplatesTab(),
              ],
            ),
          ),
          if (_tabController.index == 0) ...[
            if (!_isPreviewMode)
              FormattingToolbarWidget(
                isBold: false,
                isItalic: false,
                isUnderline: false,
                isBulletList: false,
                onBoldPressed: () =>
                    _quillController.formatSelection(Attribute.bold),
                onItalicPressed: () =>
                    _quillController.formatSelection(Attribute.italic),
                onUnderlinePressed: () =>
                    _quillController.formatSelection(Attribute.underline),
                onBulletListPressed: () =>
                    _quillController.formatSelection(Attribute.ul),
                onAddHeadingPressed: () =>
                    _quillController.formatSelection(Attribute.h1),
                onAddImagePressed: _insertImage,
                onUndoPressed: () => _quillController.undo(),
                onRedoPressed: () => _quillController.redo(),
              ),
            ReportStatsWidget(
              wordCount: _wordCount,
              estimatedReadingTime: _estimatedReadingTime,
              lastSaved: _lastSaved,
              isAutoSaving: _isAutoSaving,
            ),
          ],
        ],
      ),
      floatingActionButton: _tabController.index == 0 && !_isPreviewMode
          ? FloatingActionButton.extended(
        onPressed: _saveAndSend,
        icon: CustomIconWidget(
          iconName: 'send',
          color: theme.colorScheme.onPrimary,
          size: 20,
        ),
        label: const Text('Send Report'),
      )
          : null,
    );
  }

  Widget _buildEditorTab() {
    final theme = Theme.of(context);

    if (_isPreviewMode) {
      return Container(
        padding: EdgeInsets.all(4.w),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(6.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Consultation Report',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Prepared for ${_currentClient['name']}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Divider(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                  SizedBox(height: 2.h),
                  Text(
                    _quillController.document.toPlainText(),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      child: QuillEditor.basic(
        controller: _quillController,
        focusNode: _editorFocusNode,
        scrollController: _scrollController,
      ),
    );
  }

  Widget _buildDraftsTab() {
    return DraftListWidget(
      drafts: _drafts,
      onDraftSelected: _onDraftSelected,
      onDraftDeleted: _onDraftDeleted,
    );
  }

  Widget _buildTemplatesTab() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemCount: _templates.length,
      itemBuilder: (context, index) {
        final template = _templates[index];
        return ReportTemplateWidget(
          templateName: template['name'],
          description: template['description'],
          category: template['category'],
          isSelected: _selectedTemplate == template['name'],
          onSelect: () {
            setState(() {
              _selectedTemplate = template['name'];
            });
            _insertTemplate(template['content']);
            _tabController.animateTo(0); // Switch to editor tab
          },
        );
      },
    );
  }
}
