import 'package:claimflow_africa/widgets/ar/ai_recommendation_engine.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:claimflow_africa/theme.dart';
import 'package:claimflow_africa/widgets/ar/ageing_calculator.dart';


class AiRecommendationScreen extends StatefulWidget {
  final List<AgeingClaimItem> highRiskClaims;

  const AiRecommendationScreen({
    super.key,
    required this.highRiskClaims,
  });

  @override
  State<AiRecommendationScreen> createState() =>
      _AiRecommendationScreenState();
}

class _AiRecommendationScreenState extends State<AiRecommendationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  bool _isAnalysing = true;
  AiRecommendation? _recommendation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    // Simulate AI thinking
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() {
          _isAnalysing = false;
          _recommendation =
              AiRecommendationEngine.generate(widget.highRiskClaims);
        });
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ClaimFlowColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: ClaimFlowColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.auto_awesome,
                          color: ClaimFlowColors.primary,
                          size: 17,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'AI RECOMMENDATION',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                          color: ClaimFlowColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      size: 22,
                      color: ClaimFlowColors.textPrimary.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFFE5E5EA)),

            // Body
            Expanded(
              child: _isAnalysing
                  ? _AnalysingState()
                  : FadeTransition(
                      opacity: _fadeIn,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Issue Detected
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: ClaimFlowColors.textPrimary
                                        .withOpacity(0.06),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.access_time_rounded,
                                    size: 20,
                                    color: ClaimFlowColors.textPrimary
                                        .withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Issue Detected',
                                        style: GoogleFonts.sourceSans3(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: ClaimFlowColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${_recommendation!.claimCount} High-Risk Claim${_recommendation!.claimCount > 1 ? 's' : ''} Require Immediate Action',
                                        style: GoogleFonts.inter(
                                          fontSize: 14,
                                          color: ClaimFlowColors.textPrimary
                                              .withOpacity(0.55),
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 28),

                            // Why This Matters
                            Text(
                              'WHY THIS MATTERS',
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                                color: ClaimFlowColors.textPrimary
                                    .withOpacity(0.4),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              _recommendation!.whyItMatters,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: ClaimFlowColors.textPrimary
                                    .withOpacity(0.65),
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 24),

                            
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    ClaimFlowColors.primary.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: ClaimFlowColors.primary
                                      .withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SUGGESTED FIX',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                      color: ClaimFlowColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _recommendation!.suggestedFix,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: ClaimFlowColors.textPrimary
                                          .withOpacity(0.7),
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 36),

                            // Edit Claim Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/claims');
                                },
                                child: Text(
                                  'Edit Claim',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Continue Anyway
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Continue Anyway',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}



class _AnalysingState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: ClaimFlowColors.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Analysing claims...',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: ClaimFlowColors.textPrimary.withOpacity(0.45),
            ),
          ),
        ],
      ),
    );
  }
}