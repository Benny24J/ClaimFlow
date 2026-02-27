import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:claimflow_africa/theme.dart';

class PasswordSuccessDialog extends StatelessWidget {
  const PasswordSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        decoration: BoxDecoration(
          color: ClaimFlowColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: ClaimFlowColors.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: ClaimFlowColors.primary.withOpacity(0.25),
                  width: 6,
                ),
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 36,
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              'Password Updated',
              style: GoogleFonts.sourceSans3(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: ClaimFlowColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              'SUCCESSFULLY',
              style: GoogleFonts.sourceSans3(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: ClaimFlowColors.textPrimary,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Subtitle
            Text(
              'Your password has been Updated\nSuccessfully',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: ClaimFlowColors.primary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Authenticate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pushReplacementNamed(context, '/signin');
                },
                child: Text(
                  'Authenticate',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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


void showPasswordSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (_) => const PasswordSuccessDialog(),
  );
}