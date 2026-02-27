import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:claimflow_africa/screens/all/claim_list_screen.dart';
import 'package:claimflow_africa/dmodels/claim_model.dart';
import 'package:claimflow_africa/widgets/claimlist/claim_card.dart';
import 'package:claimflow_africa/widgets/claimlist/claim_empty_state.dart';

void main() {
  late Box<ClaimModel> testBox;

  setUp(() async {
    // Initialize Hive for testing
    await setUpTestHive();
    if (!Hive.isAdapterRegistered(0)) {
       Hive.registerAdapter(ClaimModelAdapter());
    }
    // Open a fresh box for each test
    testBox = await Hive.openBox<ClaimModel>('claims');
  });

  tearDown(() async {
    // Clean up the box after each test
    await testBox.clear();
    await tearDownTestHive();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      routes: {
        '/new-claim': (context) => const Scaffold(body: Text('NewClaimPlaceholder')),
        '/claim-details': (context) => const Scaffold(body: Text('ClaimDetailsPlaceholder')),
        '/dashboard': (context) => const Scaffold(body: Text('Dashboard')),
        '/claims': (context) => const Scaffold(body: Text('Claims')),
        '/risks': (context) => const Scaffold(body: Text('Risks')),
        '/ageing': (context) => const Scaffold(body: Text('Ageing')),
        '/settings': (context) => const Scaffold(body: Text('Settings')),
      },
      home: const ClaimListScreen(),
    );
  }

  testWidgets('ClaimListScreen displays empty state when no claims', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byType(ClaimEmptyState), findsOneWidget);
    expect(find.byType(ClaimCard), findsNothing);
  });

  testWidgets('ClaimListScreen displays claims and filters them', (WidgetTester tester) async {
    // Seed test data
    final claim1 = ClaimModel()
      ..localId = 'C001'
      ..patientName = 'Alice'
      ..nhiaId = 'N001'
      ..dateOfBirth = DateTime(1990)
      ..gender = 'Female'
      ..diagnosisCode = 'D01'
      ..procedureCode = 'P01'
      ..serviceDate = DateTime.now()
      ..insurer = 'Insurer A'
      ..totalClaimAmount = 5000 // Healthy claim
      ..notes = ''
      ..syncStatus = ClaimSyncStatus.synced.name
      ..createdAt = DateTime.now();

    final claim2 = ClaimModel()
      ..localId = 'C002'
      ..patientName = 'Bob'
      ..nhiaId = 'N002'
      ..dateOfBirth = DateTime(1985)
      ..gender = 'Male'
      ..diagnosisCode = 'D02'
      ..procedureCode = 'P02'
      ..serviceDate = DateTime.now()
      ..insurer = 'Insurer B'
      ..totalClaimAmount = 15000 // At Risk claim (>10000)
      ..notes = ''
      ..syncStatus = ClaimSyncStatus.failed.name // Overdue claim
      ..createdAt = DateTime.now();

    await testBox.addAll([claim1, claim2]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify all claims are displayed
    expect(find.byType(ClaimCard), findsNWidgets(2));
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);

    // Filter by "At Risk"
    await tester.tap(find.text('At Risk'));
    await tester.pumpAndSettle();

    // Only Bob should be displayed (amount > 10000)
    expect(find.byType(ClaimCard), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);

    // Filter by "Overdue"
    await tester.tap(find.text('Overdue'));
    await tester.pumpAndSettle();

    // Only Bob should be displayed (syncStatus == failed)
    expect(find.byType(ClaimCard), findsOneWidget);
    expect(find.text('Bob'), findsOneWidget);
    
    // Search functionality test
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();
    expect(find.byType(ClaimCard), findsNWidgets(2));

    await tester.enterText(find.byType(TextField), 'Alice');
    await tester.pumpAndSettle();
    
    // Only Alice should be displayed after search
    expect(find.byType(ClaimCard), findsOneWidget);
    expect(find.text('Alice'), findsOneWidget);
  });
}
