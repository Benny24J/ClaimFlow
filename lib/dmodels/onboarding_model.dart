
class OnboardingItem {
  final String title;
  final String description;
  final String imageAsset;

  const OnboardingItem({
    required this.title,
    required this.description,
    required this.imageAsset,
  });
}

class OnboardingData {
  static const items = <OnboardingItem>[
    OnboardingItem(
      title: 'Stop Losing Money To Claim Rejections',
      description:
          'Submit accurate claims, avoid penalties, and protect your clinics revenue.',
      imageAsset: 'assets/images/onb1.png',
    ),
    OnboardingItem(
      title: 'Catch Errors Before They Cost You',
      description:
          'Flag missing fields, late submissions, penalty risks even offline.',
      imageAsset: 'assets/images/onb2.png',
    ),
    OnboardingItem(
      title: 'Stronger Cash Flow, Timely Salaries',
      description:
          'Track unpaid claims, reduce rejections, and stabilize your finances.',
      imageAsset: 'assets/images/onb3.jpg',
    ),
  ];
}