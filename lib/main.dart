import 'package:claimflow_africa/dmodels/claim_model.dart';
import 'package:claimflow_africa/dmodels/clinic_model.dart';
import 'package:claimflow_africa/dmodels/user_profile_model.dart';
import 'package:claimflow_africa/myApp.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ClaimModelAdapter());
  await Hive.openBox<ClaimModel>('claims');
  final box = Hive.box<ClaimModel>('claims');
  print(' Hive ready — Claims in local db: ${box.length}');
  Hive.registerAdapter(UserProfileModelAdapter());
  await Hive.openBox<UserProfileModel>('userProfile');
  Hive.registerAdapter(ClinicModelAdapter());
await Hive.openBox<ClinicModel>('clinics');

  await Supabase.initialize(
    url: 'https://hihlqwjditxxscreeuci.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhpaGxxd2pkaXR4eHNjcmVldWNpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM5MzQzNjAsImV4cCI6MjA4OTUxMDM2MH0.QZJQZjGwXRzPcJXuS0vTzt2VNdLZ91oO3wv5SSJh5UA',
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
