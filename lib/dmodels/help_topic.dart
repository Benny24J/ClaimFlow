class HelpTopic {
  final String id;
  final String title;
  final int articleCount;
  final String iconAsset;
  final String route;

  const HelpTopic({
    required this.id,
    required this.title,
    required this.articleCount,
    required this.iconAsset,
    required this.route,
  });

  static const List<HelpTopic> all = [
    HelpTopic(
      id: 'getting-started',
      title: 'Getting Started',
      articleCount: 3,
      iconAsset: 'getting_started',
      route: '/help/topic/getting-started',
    ),
    HelpTopic(
      id: 'claims',
      title: 'Claims Management',
      articleCount: 4,
      iconAsset: 'claims',
      route: '/help/topic/claims',
    ),
    HelpTopic(
      id: 'risk',
      title: 'Risk Prevention',
      articleCount: 3,
      iconAsset: 'risk',
      route: '/help/topic/risk',
    ),
    HelpTopic(
      id: 'financial',
      title: 'Financial Reports',
      articleCount: 3,
      iconAsset: 'financial',
      route: '/help/topic/financial',
    ),
    HelpTopic(
      id: 'settings',
      title: 'Team & Settings',
      articleCount: 3,
      iconAsset: 'settings',
      route: '/help/topic/settings',
    ),
  ];
}