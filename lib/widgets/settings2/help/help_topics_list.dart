import 'package:flutter/material.dart';
import 'package:claimflow_africa/dmodels/help_topic.dart';

class HelpTopicsList extends StatelessWidget {
  final List<HelpTopic> topics;

  const HelpTopicsList({super.key, required this.topics});

  IconData _topicIcon(String id) {
    switch (id) {
      case 'getting-started': return Icons.menu_book_outlined;
      case 'claims': return Icons.receipt_long_outlined;
      case 'risk': return Icons.shield_outlined;
      case 'financial': return Icons.attach_money_outlined;
      case 'settings': return Icons.people_outline;
      default: return Icons.article_outlined;
    }
  }

  Color _topicColor(String id) {
    switch (id) {
      case 'getting-started': return const Color(0xFF2196F3);
      case 'claims': return const Color(0xFF4CAF50);
      case 'risk': return const Color(0xFFE53935);
      case 'financial': return const Color(0xFF8BC34A);
      case 'settings': return const Color(0xFF9E9E9E);
      default: return const Color(0xFF9E9E9E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BROWSE BY TOPIC',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            children: topics.map((topic) {
              final index = topics.indexOf(topic);
              final isLast = index == topics.length - 1;
              return Column(
                children: [
                  _TopicTile(
                    topic: topic,
                    icon: _topicIcon(topic.id),
                    color: _topicColor(topic.id),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: theme.colorScheme.outline
                          .withValues(alpha: 0.1),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _TopicTile extends StatelessWidget {
  final HelpTopic topic;
  final IconData icon;
  final Color color;

  const _TopicTile({
    required this.topic,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => Navigator.pushNamed(context, topic.route,
          arguments: {'topic': topic}),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${topic.articleCount} articles',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
            ),
          ],
        ),
      ),
    );
  }
}