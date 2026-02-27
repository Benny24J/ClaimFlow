import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:claimflow_africa/widgets/claimlist/claim_empty_state.dart';
import 'package:claimflow_africa/widgets/claimlist/claim_search_bar.dart';
import 'package:claimflow_africa/widgets/claimlist/claim_filter_tabs.dart';

void main() {
  group('ClaimList Sub-widgets Tests', () {
    testWidgets('ClaimEmptyState displays correct text for "All" filter', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: ClaimEmptyState(activeFilter: ClaimFilter.all),
        ),
      ));

      expect(find.text('No claims found'), findsOneWidget);
      expect(find.text('We couldn\'t find any claims matching\nyour current filters.'), findsOneWidget);
    });

    testWidgets('ClaimEmptyState displays correct text for "At Risk" filter', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: ClaimEmptyState(activeFilter: ClaimFilter.atRisk),
        ),
      ));

      expect(find.text('No at risk claims found.\nAll your claims look healthy!'), findsOneWidget);
    });

    testWidgets('ClaimEmptyState displays correct text for "Overdue" filter', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: ClaimEmptyState(activeFilter: ClaimFilter.overdue),
        ),
      ));

      expect(find.text('No overdue claims found.\nYou\'re all caught up!'), findsOneWidget);
    });

    testWidgets('ClaimSearchBar updates value on typing', (WidgetTester tester) async {
      String searchValue = '';
      final controller = TextEditingController();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ClaimSearchBar(
            controller: controller,
            onChanged: (val) => searchValue = val,
          ),
        ),
      ));

      expect(find.byType(TextField), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'John Doe');
      
      expect(searchValue, equals('John Doe'));
      expect(controller.text, equals('John Doe'));
    });

    testWidgets('ClaimFilterTabs displays tabs and handles selection', (WidgetTester tester) async {
      ClaimFilter selectedFilter = ClaimFilter.all;

      await tester.pumpWidget(StatefulBuilder(
        builder: (context, setState) {
          return MaterialApp(
            home: Scaffold(
              body: ClaimFilterTabs(
                selected: selectedFilter,
                onChanged: (newFilter) {
                  setState(() => selectedFilter = newFilter);
                },
              ),
            ),
          );
        },
      ));

      expect(find.text('All'), findsOneWidget);
      expect(find.text('At Risk'), findsOneWidget);
      expect(find.text('Overdue'), findsOneWidget);

      // Default should be All
      expect(selectedFilter, equals(ClaimFilter.all));

      // Tap 'At Risk'
      await tester.tap(find.text('At Risk'));
      await tester.pumpAndSettle();
      expect(selectedFilter, equals(ClaimFilter.atRisk));

      // Tap 'Overdue'
      await tester.tap(find.text('Overdue'));
      await tester.pumpAndSettle();
      expect(selectedFilter, equals(ClaimFilter.overdue));
    });
  });
}
