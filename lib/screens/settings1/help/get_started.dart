import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:claimflow_africa/theme.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  final List<Map<String, String>> articles = const [
    {'title': 'How to Create Your First Claim', 'readTime': '3 min read'},
    {'title': 'How to Create Your First Claim', 'readTime': '3 min read'},
    {'title': 'How to Create Your First Claim', 'readTime': '3 min read'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClaimFlowColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: ClaimFlowColors.textPrimary,
                  size: 24,
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Main Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: ClaimFlowColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header Row
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 16),
                      child: Row(
                        children: [
                          // Icon Box
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: ClaimFlowColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.article_outlined,
                              color: ClaimFlowColors.primary,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Title & subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Getting Started',
                                  style: GoogleFonts.sourceSans3(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ClaimFlowColors.textPrimary,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${articles.length} articles',
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: ClaimFlowColors.textPrimary
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Chevron down
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: ClaimFlowColors.textPrimary.withOpacity(0.4),
                            size: 22,
                          ),
                        ],
                      ),
                    ),

                    // Divider
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: ClaimFlowColors.textPrimary.withOpacity(0.08),
                    ),

                    // Article Rows
                    ...articles.asMap().entries.map((entry) {
                      final index = entry.key;
                      final article = entry.value;
                      final isLast = index == articles.length - 1;

                      return Column(
                        children: [
                          _ArticleRow(
                            title: article['title']!,
                            readTime: article['readTime']!,
                          ),
                          if (!isLast)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: ClaimFlowColors.textPrimary.withOpacity(0.08),
                              indent: 18,
                              endIndent: 18,
                            ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleRow extends StatefulWidget {
  final String title;
  final String readTime;

  const _ArticleRow({required this.title, required this.readTime});

  @override
  State<_ArticleRow> createState() => _ArticleRowState();
}

class _ArticleRowState extends State<_ArticleRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        // TODO: Navigate to article detail screen
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: _pressed
            ? ClaimFlowColors.primary.withOpacity(0.04)
            : ClaimFlowColors.surface,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.sourceSans3(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: ClaimFlowColors.textPrimary,
                      letterSpacing: -0.1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.readTime,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: ClaimFlowColors.textPrimary.withOpacity(0.45),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: ClaimFlowColors.textPrimary.withOpacity(0.3),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}