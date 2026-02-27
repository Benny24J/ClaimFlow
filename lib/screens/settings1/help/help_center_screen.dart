import 'package:flutter/material.dart';
import 'package:claimflow_africa/widgets/claims/bottom_navigation_bar.dart';
import 'package:claimflow_africa/dmodels/help_topic.dart';
import 'package:claimflow_africa/widgets/settings2/help/help_quick_actions.dart';
import 'package:claimflow_africa/widgets/settings2/help/help_topics_list.dart';
import 'package:claimflow_africa/widgets/settings2/help/help_support_card.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  List<HelpTopic> _filteredTopics = HelpTopic.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      _searchQuery = query;
      _filteredTopics = query.isEmpty
          ? HelpTopic.all
          : HelpTopic.all
              .where((t) =>
                  t.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help Center',
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search for help articles...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color:
                      theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  size: 20,
                ),
                filled: true,
                fillColor:
                    theme.colorScheme.onSurface.withValues(alpha: 0.06),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 24),

            
            if (_searchQuery.isEmpty) ...[
              const HelpQuickActions(),
            ],

            
            if (_filteredTopics.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'No articles found for "$_searchQuery"',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                ),
              )
            else
              HelpTopicsList(topics: _filteredTopics),
  
            const HelpSupportCard(),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
    );
  }
}